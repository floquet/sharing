! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! https://stackoverflow.com/questions/8508590/standard-input-and-output-units-in-fortran-90
module mSolutionSVD

    use, intrinsic :: iso_fortran_env,  only : stdout => output_unit
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mBuildAFourier,                 only : linearSystem
    !use mLapackErrors,                  only : lapackErrorsDGETRF, lapackErrorsDGETRI
    use mLapackInterfaces,              only : DGESVD
    use mMatrixWriter,                  only : print_matrix
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none
    ! LAPACK routines
    !external :: DGESVD ! LAPACK routines
    !external DGESVD, DDISNA ! LAPACK routines
    ! https://www.netlib.org/lapack/explore-3.1.1-html/dgesvd.f.html
    ! https://www.netlib.org/lapack/explore-3.1.1-html/ddisna.f.html

    integer ( kind = ip ) :: io_stat = 0, output_unit = 6
    character ( kind = kindA, len = 512 ) :: io_msg = ""

    type :: solutionSVD
        ! rank 2
        real ( kind = rp ), allocatable :: W ( : , : ), Winv ( : , : ), Wtemp ( : , : )
        ! A is m x n
        ! data vectors length m
        real ( kind = rp ), allocatable :: Asb ( : )
        ! data vectors length n ( = d + 1 )
        real ( kind = rp ), allocatable :: amplitude ( : ), error ( : ), residual ( : ), signalNoise ( : )

        ! rank 0
        real( rp ) :: sse

        ! scalar
        integer ( kind = ip ) :: len_data = 0, len_solution = 0, order_of_fit = 0
        character ( kind = kindA, len =  64 ) :: tag = "", method = "", quarry = "", fit_type = ""
        character ( kind = kindA, len = 512 ) :: data_source = ""
        ! types
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: svd_pseudoinverse_solve  => svd_pseudoinverse_solve_sub
    end type solutionSVD

    private :: svd_pseudoinverse_solve_sub

contains

    subroutine svd_pseudoinverse_solve_sub ( me, myLinearSystem )
        class ( solutionSVD ), target :: me
        type ( linearSystem ), intent ( inout ) :: myLinearSystem
        ! rank 2:
        real ( kind = rp ), allocatable :: Apseudoinverse ( : , : ), &  ! n x m
                                           Sigma( : , : ), &
                                           u  ( : , : ), &              ! LDU x MMAX
                                           vt ( : , : )                 ! LDVT x NMAX,
        ! rank 1: length nmax
        real ( kind = rp ), allocatable :: WORK ( : ), spectrum ( : )

        integer ( kind = ip ) :: m = 0, n = 0, & ! A dimensions
                                 row = 0, &      ! dummy counter
                                 info = 0, LWORK = 0, mx = 0, mn = 0 ! Lapack
            ! Problem:  Ax = b
            ! Solution: x_{LS} = A^{+} b

            ! measure
            ! m : rows
            ! n : columns
            m = size ( myLinearSystem % A, 1 )
            n = size ( myLinearSystem % A, 2 )
            ! LWORK >= MAX(1, 3*MIN(M,N) + MAX(M,N), 5*MIN(M,N) )
            mx = max ( m, n )
            mn = min ( m, n )
            LWORK = max ( 3 * mn + mx, 5 * mn )
            write ( * , fmt = '( 10g0 )' )  "m = ", m, "; n = ", n, "; mn = ", mn, "; mx = ", mx, "; lwork = ", lwork

            ! allocations
            ! rank 2
            ! columns space LDU x MMAX
            call me % myKit % allocate_rank_two_reals ( real_array = u, numRows = m, numColumns = m )
            ! row space LDVT x NMAX
            call me % myKit % allocate_rank_two_reals ( real_array = vt, numRows = n, numColumns = n )

            ! rank 1: use for LWORK = -1 query here (needs 1 element)
            call me % myKit % allocate_rank_one_reals ( real_array = work, index_min = 1, index_max = 1 )
            call me % myKit % allocate_rank_one_reals ( real_array = spectrum, index_min = 1, index_max = mn )
            write ( * , fmt = '( 9g0 )' ) "Allocations successful: shape ( u ) = ", shape ( u ), "; shape ( vt ) = ", shape ( vt ),&
                                            "; length ( work ) = ", size ( work )
            ! query for optimal block size
            ! LWORK is INTEGER
            ! The dimension of the array WORK.  LWORK >= max(1,N).
            ! For optimal performance LWORK >= N * NB, where NB is
            ! the optimal blocksize returned by ILAENV.

            ! If LWORK = -1, then a workspace query is assumed; the routine
            ! only calculates the optimal size of the WORK array, returns
            ! this value as the first entry of the WORK array, and no error
            ! message related to LWORK is issued by XERBLA.
            write ( * , fmt = '( 10g0 )' ) "Going into DGESVD: m = ", m, ", n = ", n, ", LDA = ", m, ", LDU = ", m, ", LDVT = ", n
            write ( * , fmt = '( 10g0 )' ) "LWORK = -1, INFO = ", info, ", WORK = ", WORK
            !call DGESVD ( JOBU = 'A', JOBVT = 'A', M = m, N = n, A = myLinearSystem % A, LDA = m, S = spectrum, &
            !                 U = u, LDU = m, VT = vt, LDVT = n, WORK = WORK, LWORK = -1, INFO = info )
            write ( * , fmt = '( 2g0 )' ) "Result of query with LWORK = -1: optimum array size lwork = ", WORK ( 1 )

            lwork = int ( WORK ( 1 ) + 0.4_rp, kind = ip ) ! int acts as FLOOR function
            lwork = max ( 3 * mn + mx, 5 * mn )
            write ( * , fmt = '( 2g0 )' ) "LWORK = ", lwork
            call DGESVD ( JOBU = 'A', JOBVT = 'A', M = m, N = n, A = myLinearSystem % A, LDA = m, S = spectrum, &
                            U = u, LDU = m, VT = vt, LDVT = n, WORK = WORK, LWORK = lwork, INFO = info )

            ! delay allocation until SVD computation completes to avoid a (potentially long) computation
            ! which would be wasted if the the SVD routines fail
            call me % myKit % allocate_rank_two_reals ( real_array = Sigma, numRows = m, numColumns = n )

            ! assemble the pseudoinverse of the Sigma matrix
            do row = 1, n ! assume tall matrix
                Sigma( row, row ) = 1 / spectrum ( row )
            end do
            !( Sigma( 1 : row, 1 : row ) = 1 / S ( 1 : row ), row = 1, rank )
            Apseudoinverse = matmul ( Sigma, transpose ( u ) )
            Apseudoinverse = matmul ( transpose ( vt ), Apseudoinverse )
            call print_matrix ( A = Apseudoinverse, myFormat = 'F8.3', spaces = 2, dims = [ m, n ], my_io_unit = stdout )

        return
    end subroutine svd_pseudoinverse_solve_sub

end module mSolutionSVD

! http://www.netlib.org/lapack/lug/node131.html#20797
! For example, for SGEQRF on a single processor of a CRAY-2, NB = 32 was observed to be a good block size, and the performance of
! the block algorithm with this block size surpasses the unblocked algorithm for square matrices between N = 176 and N = 192.
! Experiments with crossover points from 64 to 192 found that NX = 128 was a good choice, although the results for NX from 3!NB to
! 5!NB are broadly similar. This means that matrices with N <= 128 should use the unblocked algorithm, and for N > 128 block
! updates should be used until the remaining submatrix has order less than 128. The performance of the unblocked (NB = 1) and
! blocked (NB = 32)

! By experimenting with small values of the block size, it should be straightforward to choose NBMIN, the smallest block size that
! gives a performance improvement over the unblocked algorithm. Note that on some machines, the optimal block size may be 1
! (the unblocked algorithm gives the best performance); in this case, the choice of NBMIN is arbitrary. The prototype version of
! ILAENV sets NBMIN to 2, so that blocking is always done, even though this could lead to poor performance from a block routine if
! insufficient workspace is supplied

! code:
! http://www.netlib.org/lapack/explore-html/d3/d6a/dgetrf_8f_source.html

! into dgetrf: rows = 8, cols = 8, lda = 9
! size ( pivotIndices ) = 8, info = 0
! sigma(49090,0x11286adc0) malloc: Incorrect checksum for freed object 0x7fa623504b78: probably modified after being freed.
! Corrupt value: 0xbfe55f68db289e9f
! sigma(49090,0x11286adc0) malloc: !!! set a breakpoint in malloc_error_break to debug
!
! Program received signal SIGABRT: Process abort signal.
