! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! https://stackoverflow.com/questions/8508590/standard-input-and-output-units-in-fortran-90
module mSolutionNormal

    use, intrinsic :: iso_fortran_env,  only : iostat_end, stdout => output_unit
    use mAllocations,                   only : rank_one_reals_sub, rank_two_reals_sub
    use mBuildAFourier,                 only : systemMatrix
    use mLapackErrors,                  only : lapackErrorsDGETRF, lapackErrorsDGETRI
    use mMatrixWriter,                  only : open_file_print_matrix
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none

    ! LAPACK routines
    
    ! DGETRF computes an LU factorization of a general M-by-N matrix A using partial pivoting with row interchanges.
    ! The factorization has the form
    !   A = P * L * U
    ! where P is a permutation matrix, L is lower triangular with unit
    ! diagonal elements (lower trapezoidal if m > n), and U is upper
    ! triangular (upper trapezoidal if m < n).
    ! This is the right-looking Level 3 BLAS version of the algorithm.
    ! http://www.netlib.org/lapack/explore-3.1.1-html/dgetrf.f.html
    external DGETRF
    ! DGETRI computes the inverse of a matrix using the LU factorization computed by DGETRF.
    ! This method inverts U and then computes inv(A) by solving the system
    ! inv(A)*L = inv(U) for inv(A).
    ! http://www.netlib.org/lapack/explore-3.1.1-html/dgetri.f.html
    external DGETRI

    integer ( kind = ip ) :: io_stat = 0, output_unit = 6
    character ( kind = kindA, len = 512 ) :: io_msg = ""

    type :: solutionNormal
        ! rank 2
        real ( kind = rp ), allocatable :: W     ( : , : )
        real ( kind = rp ), allocatable :: Winv  ( : , : )
        real ( kind = rp ), allocatable :: Wtemp ( : , : )
        ! A is m x n
        ! data vectors length m
        real ( kind = rp ), allocatable :: Asb ( : )
        ! data vectors length n ( = d + 1 )
        real ( kind = rp ), allocatable :: amplitude   ( : )
        real ( kind = rp ), allocatable :: error       ( : )
        real ( kind = rp ), allocatable :: residual    ( : )
        real ( kind = rp ), allocatable :: signalNoise ( : )

        ! rank 0
        real( rp ) :: sse

        ! scalar
        integer ( kind = ip ) :: len_data = 0
        integer ( kind = ip ) :: len_solution = 0
        integer ( kind = ip ) :: order_of_fit = 0
        character ( kind = kindA, len =  64 ) :: tag = ""
        character ( kind = kindA, len =  64 ) :: method = ""
        character ( kind = kindA, len =  64 ) :: quarry = ""
        character ( kind = kindA, len =  64 ) :: fit_type = ""
        character ( kind = kindA, len = 512 ) :: data_source = ""
    contains
        procedure, public :: normal_equations_create => normal_equations_create_sub
        procedure, public :: normal_equations_solve  => normal_equations_solve_sub
    end type solutionNormal

    private :: normal_equations_create_sub, normal_equations_solve_sub

contains

    subroutine normal_equations_create_sub ( me, mySystem )
        class ( solutionNormal ), target :: me
        type ( systemMatrix ), intent ( in ) :: mySystem

            me % method = "normal equations"
            me % len_data     = mySystem % rows
            me % len_solution = mySystem % cols
            write ( * , * ) "mySystem % rows = ", mySystem % rows
            write ( * , * ) "mySystem % cols = ", mySystem % cols
            write ( * , * ) "me % len_solution = ", me % len_solution

            ! RHS
            call rank_one_reals_sub ( real_array = me % Asb, numRows = me % len_data )

            ! memory allocations for W
            call rank_two_reals_sub ( real_array = me % W,     numRows = me % len_solution, numColumns = me % len_solution )
            call rank_two_reals_sub ( real_array = me % Winv,  numRows = me % len_solution, numColumns = me % len_solution )
            call rank_two_reals_sub ( real_array = me % Wtemp, numRows = me % len_solution, numColumns = me % len_solution )
            ! https://software.intel.com/en-us/forums/intel-fortran-compiler/topic/271179
            ! It is not the use of a pointer that induces creation of temporaries, but expressions such as
            ! matmul(tp1,transpose(tp1))
            ! Space for the transpose and space for the product may be needed, although the compiler-optimizer can analyze the situation and decide if one or more temporary arrays can be dispensed with.            ! build A
            ! build product matrix (LHS)
            me % W ( : , : ) = matmul ( transpose ( mySystem % A ( : , : ) ) , mySystem % A ( : , : ) )
            !write ( * , * ) "shape A* = ", shape ( transpose ( mySystem % A ) )
            !write ( * , * ) "shape A = ", shape ( mySystem % A )
            !write ( * , * ) "shape W = ", shape ( me % W )
            call open_file_print_matrix ( A = me % W, myFormat = "F11 .5", spaces = 1, moniker = "fresh", &
                                            dims = [ me % len_solution, me % len_solution ], myFile = "fresh-out.txt" )
            ! build RHS
            me % Asb ( : )   = matmul ( transpose ( mySystem % A ( : , : ) ), mySystem % b ( : ) )

        return
    end subroutine normal_equations_create_sub

    subroutine normal_equations_solve_sub ( me, mySystem )
        class ( solutionNormal ), target :: me
        type ( systemMatrix ), intent ( in ) :: mySystem
        ! locals
        real ( kind = rp )    :: lapackWorkArray ( 1 : me % len_solution )
        real ( kind = rp )    :: factor = 0
        integer ( kind = ip ) :: pivotIndices    ( 1 : me % len_solution )
        integer ( kind = ip ) :: rows = 0, cols = 0
        integer ( kind = ip ) :: info = 0, lda = 0, lwork = 16
        integer ( kind = ip ) :: k = 0
        ! LWORK is INTEGER
        ! The dimension of the array WORK.  LWORK >= max(1,N).
        ! For optimal performance LWORK >= N*NB, where NB is
        ! the optimal blocksize returned by ILAENV.

        ! If LWORK = -1, then a workspace query is assumed; the routine
        ! only calculates the optimal size of the WORK array, returns
        ! this value as the first entry of the WORK array, and no error
        ! message related to LWORK is issued by XERBLA.

            ! Ax = b
            ! x_{LS} = ( A*A )^{-1} A* b

            ! invert product matrix W = A*A
            ! compute A = P * L * U factorization using partial pivoting with row interchanges.
            ! Wtemo starts as W, completes as Winv
            me % Wtemp ( : , : ) = me % W ( : , : )
            rows = size ( me % W ( : , : ), 1 )
            cols = size ( me % W ( : , : ), 2 )
            lda = rows
            ! lda > max ( 1, rows )
            lda = rows + 1
            call open_file_print_matrix ( A = me % Wtemp ( : , : ), myFormat = "F11 .5", spaces = 1, moniker = "dgetrf in", &
                                            dims = [ rows, cols ], myFile = "dgetrf-in.txt" )
            ! LDA  (input) INTEGER
            !   The leading dimension of the array A.  LDA >= max(1,M).
            ! IPIV  (output) INTEGER array, dimension (min(M,N))
            !   The pivot indices; for 1 <= i <= min(M,N), row i of the matrix was interchanged with row IPIV(i).
            ! call dgetrf( M = rows, N = cols, A = me % Wtemp ( : , : ), LDA = lda, IPIV = pivotIndices, INFO = info )
            write ( * , fmt = '( 6g0 )' ) "into dgetrf: rows = ", rows, ", cols = ", cols, ", lda = ", lda
            write ( * , fmt = '( 6g0 )' ) "size ( pivotIndices ) = ", size ( pivotIndices ), ", info = ", info
            call dgetrf( rows, cols, me % Wtemp ( : , : ), lda, pivotIndices, info )
            call open_file_print_matrix ( A = me % Wtemp ( : , : ), myFormat = "F11 .5", spaces = 1, moniker = "dgetrf out", &
                                            dims = [ rows, cols ], myFile = "dgetrf-out.txt" )
            if ( info /= 0 ) then
                call lapackErrorsDGETRF ( info )
                stop "Error from 'dgetrf' in routine 'normal_equations_solve_sub'"
            end if
            ! invert U and then compute inv(A) by solving the system
            ! inv(A) * L = inv(U) for inv(A).
            call open_file_print_matrix ( A = me % Wtemp, myFormat = "F11 .5", spaces = 1, moniker = "dgetri in", &
                                            dims = [ 361, 8 ], myFile = "dgetri-in.txt" )
            call dgetri( rows, me % Wtemp, cols, pivotIndices, lapackWorkArray, lwork, info )
            call open_file_print_matrix ( A = me % Wtemp, myFormat = "F11 .5", spaces = 1, moniker = "dgetri in", &
                                            dims = [ 361, 8 ], myFile = "dgetri-in.txt" )
            if ( info /= 0 ) then
                call lapackErrorsDGETRI ( info )
                stop "Error from 'dgetri' in routine 'normal_equations_solve_sub'"
            end if

            ! least squares solution
            me % Winv ( : , : ) = me % Wtemp ( : , : )
            me % amplitude ( : ) = matmul ( me % Winv ( : , : ), me % Asb )
            ! error analysis
            me % residual ( : ) = mySystem % b ( : ) - matmul ( mySystem % A ( : , : ), me % amplitude )
            me % sse = dot_product ( me % residual ( : ), me % residual ( : ) )
            factor =  me % sse / real ( me % len_data - me % len_solution , rp )
            me % error ( : ) = [ ( me % Winv ( k, k ), k = 1, me % len_solution ) ]
            me % error ( : ) = sqrt ( factor * me % error ( : ) )
            me % signalNoise ( : ) = me % amplitude ( : ) / me % residual ( : )

        return
    end subroutine normal_equations_solve_sub

end module mSolutionNormal

! http://www.netlib.org/lapack/lug/node131.html#20797
! For example, for SGEQRF on a single processor of a CRAY-2, NB = 32 was observed to be a good block size, and the performance of
! the block algorithm with this block size surpasses the unblocked algorithm for square matrices between N = 176 and N = 192.
! Experiments with crossover points from 64 to 192 found that NX = 128 was a good choice, although the results for NX from 3*NB to
! 5*NB are broadly similar. This means that matrices with N <= 128 should use the unblocked algorithm, and for N > 128 block
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
! sigma(49090,0x11286adc0) malloc: *** set a breakpoint in malloc_error_break to debug
!
! Program received signal SIGABRT: Process abort signal.
