! http://www.nag.com/lapack-ex/examples/source/dgesvd-ex.f
! a simplex example of the SVD compared to Mathematic
! answers agree to full double precision
program lapack_demo_svd

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version

    use mMatrixReader,  only : read_matrix_file
    use mMatrixWriter,  only : print_matrix
    use mSetPrecision,  only : rp
    use mSVDparameters, only : A, LDA, LDU, LDVT, LWORK, MMAX, NMAX, &
                               M, N, Ap, Sp, id_col, id_row, myA, myU, myV, &
                               m_row, n_col, rank, io_write
    implicit none

    external DGESVD, DDISNA ! LAPACK routines
    ! https://www.netlib.org/lapack/explore-3.1.1-html/dgesvd.f.html
    ! https://www.netlib.org/lapack/explore-3.1.1-html/ddisna.f.html

    ! parameters
    real ( rp ),           parameter :: s_mm ( 1 : 2 ) = [ sqrt ( 2.0_rp ),  1.0_rp ] ! exact singular values
    character ( len = * ), parameter :: inputMatrix = "sample_matrix.txt"
    ! rank 2
    ! real ( rp )
    real ( rp ) :: U  ( LDU,  MMAX ) = 0.0_rp
    real ( rp ) :: VT ( LDVT, NMAX ) = 0.0_rp
    ! rank 1
    real ( rp ) :: RCONDU ( NMAX ) = 0.0_rp, VERRBD ( NMAX ) = 0.0_rp, S ( NMAX )     = 0.0_rp, &
                   RCONDV ( NMAX ) = 0.0_rp, UERRBD ( NMAX ) = 0.0_rp, WORK ( LWORK ) = 0.0_rp
    ! rank 0
    real ( rp ) :: EPS = 0.0_rp, SERRBD = 0.0_rp

    integer     :: INFO = 0, LWKOPT = 0
    integer     :: io_status = 0, row = 0

        call read_matrix_file ( inputMatrix )
        call print_matrix ( A = A, myFormat = 'E20.13', spaces = 3, dims = [ m_row, n_col ], my_io_unit = io_write )
        myA = A ( 1 : m_row, 1 : n_col )

        ! Compute the singular values and left and right singular vectors of A (A = U S (V'), m >= n )
        ! Overwrite A by U
        ! DGESVD computes the singular value decomposition (SVD) of a real
        ! m-by-n matrix A, optionally computing the left and/or right singular
        ! vectors. The SVD for a matrix A is

        ! A = U * SIGMA * transpose(V)
        ! where SIGMA is an m-by-n matrix which is zero except for its
        ! min(m,n) diagonal elements, U is an m-by-m orthogonal matrix, and
        ! V is an n-by-n orthogonal matrix.  The diagonal elements of SIGMA
        ! are the singular values of A; they are real and non-negative, and
        ! are returned in descending order.  The first min(m,n) columns of
        ! U and V are the left and right singular vectors of A.

        ! Note that the routine returns V**T, not V.
        call DGESVD ( 'A', 'Singular vectors ( V )', M, N, A, LDA, S, U, LDU, VT, LDVT, WORK, LWORK, INFO )

        LWKOPT = floor( WORK ( 1 ) )
        write ( io_write, 200 ) LWKOPT, LWORK

        write ( * , 300 ) info
        if ( info > 0 ) then
            write ( unit = *, fmt = '( "Error in slot ", g0, " in call to sgesvd." )', iostat = io_status ) info
        else if ( info < 0 ) then
            write ( unit = *, fmt = '( "Number of superdiagonals which did not converge = ", g0,  "." )', iostat = io_status ) -info
        end if

        write ( io_write, * )
        write ( io_write, * ) 'DGESVD Example Program Results'
        write ( io_write, * )
        write ( io_write, * ) 'Singular values, LAPACK:'
        write ( io_write, * ) 'S = ', S
        write ( io_write, * ) 'Singular values, Mathematica:'
        write ( io_write, * ) 'S = ', s_mm
        write ( io_write, * ) 'Singular values, differenced: (0 is ideal)'
        write ( io_write, * ) 'S = ', ( ( s ( row ) - s_mm ( row ) ), row = 1, 2 )
        write ( io_write, * )
        call print_matrix ( A = U, myFormat = 'F7.3', spaces = 3, moniker = 'codomain U', dims = [ 6, 6 ], my_io_unit = io_write )
        call print_matrix ( A = transpose ( VT ), myFormat = 'F7.3', spaces = 3, moniker = 'domain V', dims = [ 4, 4 ], &
                            my_io_unit = io_write )

        EPS = epsilon ( 1.0_rp )
        SERRBD = EPS * S ( 1 )

        ! DDISNA computes the reciprocal condition numbers for the eigenvectors
        ! of a real symmetric or complex Hermitian matrix or for the left or
        ! right singular vectors of a general m-by-n matrix. The reciprocal
        ! condition number is the 'gap' between the corresponding eigenvalue or
        ! singular value and the nearest other one.
        call DDISNA ( 'Left',  M, N, S, RCONDU, INFO )
        call DDISNA ( 'Right', M, N, S, RCONDV, INFO )

        ! compute the error estimates for the singular vectors
        UERRBD ( 1 : rank ) = SERRBD / RCONDU ( 1 : rank )
        VERRBD ( 1 : rank ) = SERRBD / RCONDV ( 1 : rank )

        write ( io_write, fmt = '( /, 2g0 )' ) " Machine epsilon at this precision = ", EPS
        write ( io_write, * ) "Errors <= epsilon are ideal"
        write ( io_write, * ) 'Error estimate for the singular values:'
        write ( io_write, 310 ) SERRBD, SERRBD / EPS
        write ( io_write, * )
        write ( io_write, * ) 'Error estimates for the left singular vectors:'
        write ( io_write, 320 ) ( [ UERRBD ( row ), UERRBD ( row ) / EPS ], row = 1, rank )
        write ( io_write, * )
        write ( io_write, * ) 'Error estimates for the right singular vectors:'
        write ( io_write, 320 ) ( [ VERRBD ( row ), VERRBD ( row ) / EPS ], row = 1, rank )

        ! assemble the pseudoinverse matrix
        do row = 1, rank
          Sp ( row, row ) = 1 / S ( row )
        end do
        !( Sp ( 1 : row, 1 : row ) = 1 / S ( 1 : row ), row = 1, rank )
        myU = U ( 1 : m, 1 : m )
        myV = transpose ( Vt ( 1 : n, 1 : n ) )
        Ap = matmul ( myV, matmul ( Sp, transpose ( myU ) ) )

        call print_matrix ( A = Ap, myFormat = 'F11.9', spaces = 1, moniker = 'Pseudoinverse matrix Ap', my_io_unit = io_write )

        id_col = matmul ( Ap, myA )
        call print_matrix ( A = id_col, myFormat = 'F8.3', spaces = 1, moniker = 'Identity matrix Ap A', my_io_unit = io_write )

        id_row = matmul ( myA, Ap )
        call print_matrix ( A = id_row, myFormat = 'F8.3', spaces = 1, moniker = 'Identity matrix A Ap', my_io_unit = io_write )

        write ( * , '( /, "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '(    "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'successful completion for lapack_demo_svd ...'

  200   format ( /, ' Optimum workspace required = ', g0, /, &
                    ' Workspace provided         = ', g0 )

  300   format ( ' dgesvd info = ', g0, ': no errors' )
  310   format ( G10.3, " ( ", F4.2," epsilons)" )
  320   format ( 2( G10.3, " ( ", F4.2," epsilons)" ) )

end program lapack_demo_svd

C dantopa:lapack/svd % date                                                                                                                    (master)fortran-alpha
C Tue May 19 01:26:18 MDT 2020
C dantopa:lapack/svd % pwd                                                                                                                     (master)fortran-alpha
C /Users/dantopa/primary-repos/bitbucket/fortran-alpha/demos/lapack/svd
C dantopa:lapack/svd % make clean                                                                                                              (master)fortran-alpha
C rm -rf lapack_demo_svd.o mod_file_handling.o mod_matrix_reader.o mod_matrix_writer.o mod_set_precision.o mod_svd_parameters.o lapack_demo_svd mod_file_handling.mod mod_matrix_reader.mod mod_matrix_writer.mod mod_set_precision.mod mod_svd_parameters.mod
C rm -f *.mod *.smod *.o
C dantopa:lapack/svd % make debug                                                                                                              (master)fortran-alpha
C PROGRAM  = lapack_demo_svd
C PRG_OBJ  = lapack_demo_svd.o
C SRCS     = lapack_demo_svd.f08 mod_file_handling.f08 mod_matrix_reader.f08 mod_matrix_writer.f08 mod_set_precision.f08 mod_svd_parameters.f08
C OBJS     = lapack_demo_svd.o mod_file_handling.o mod_matrix_reader.o mod_matrix_writer.o mod_set_precision.o mod_svd_parameters.o
C MODS     = mod_file_handling.f08 mod_matrix_reader.f08 mod_matrix_writer.f08 mod_set_precision.f08 mod_svd_parameters.f08
C MOD_OBJS = mod_file_handling.o mod_matrix_reader.o mod_matrix_writer.o mod_set_precision.o mod_svd_parameters.o
C dantopa:lapack/svd % make                                                                                                                    (master)fortran-alpha
C gfortran -c -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o mod_file_handling.o mod_file_handling.f08
C gfortran -c -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o mod_set_precision.o mod_set_precision.f08
C gfortran -c -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o mod_svd_parameters.o mod_svd_parameters.f08
C gfortran -c -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o mod_matrix_reader.o mod_matrix_reader.f08
C gfortran -c -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o mod_matrix_writer.o mod_matrix_writer.f08
C gfortran -c -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o lapack_demo_svd.o lapack_demo_svd.f08
C gfortran -g -framework Accelerate -o lapack_demo_svd lapack_demo_svd.o mod_file_handling.o mod_matrix_reader.o mod_matrix_writer.o mod_set_precision.o mod_svd_parameters.o
Cdantopa:lapack/svd % ./lapack_demo_svd                                                                                                       (master)fortran-alpha
C
C Target matrix has 3 rows and 2 columns.
C 0.1000000000000E+01    0.1000000000000E+01
C -0.7071067811865E+00    0.7071067811865E+00
C 0.0000000000000E+00    0.0000000000000E+00
C
C Optimum workspace required = 138
C Workspace provided         = 1194
C dgesvd info = 0: no errors
C
C DGESVD Example Program Results
C
C Singular values, LAPACK:
C S =    1.4142135623730951        1.0000000000000000        0.0000000000000000        0.0000000000000000        0.0000000000000000        0.0000000000000000        0.0000000000000000        0.0000000000000000     
C Singular values, Mathematica:
C S =    1.4142135623730951        1.0000000000000000     
C Singular values, differenced: (0 is ideal)
C S =    0.0000000000000000        0.0000000000000000     
C
C
C codomain U has 6 rows and 6 columns.
C -1.000    -0.000     0.000     0.000     0.000     0.000
C -0.000     1.000     0.000     0.000     0.000     0.000
C  0.000     0.000     1.000     0.000     0.000     0.000
C  0.000     0.000     0.000     0.000     0.000     0.000
C  0.000     0.000     0.000     0.000     0.000     0.000
C  0.000     0.000     0.000     0.000     0.000     0.000
C
C domain V has 4 rows and 4 columns.
C -0.707    -0.707     0.000     0.000
C -0.707     0.707     0.000     0.000
C  0.000     0.000     0.000     0.000
C  0.000     0.000     0.000     0.000
C
C Machine epsilon at this precision = 0.22204460492503131E-015
C Errors <= epsilon are ideal
C Error estimate for the singular values:
C 0.314E-15 ( 1.41 epsilons)
C
C Error estimates for the left singular vectors:
C 0.758E-15 ( 3.41 epsilons) 0.758E-15 ( 3.41 epsilons)
C
C Error estimates for the right singular vectors:
C 0.758E-15 ( 3.41 epsilons) 0.758E-15 ( 3.41 epsilons)
C
C Pseudoinverse matrix Ap has 2 rows and 3 columns.
C 0.500000000 -.707106781 0.000000000
C 0.500000000 0.707106781 0.000000000
C
C Identity matrix Ap A has 2 rows and 2 columns.
C   1.000   -0.000
C  -0.000    1.000
C
C Identity matrix A Ap has 3 rows and 3 columns.
C   1.000   -0.000    0.000
C  -0.000    1.000    0.000
C   0.000    0.000    0.000
C
C compiler version: GCC version 9.3.0.
C compiler options: -fPIC -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip lapack_demo_svd.o -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
C
C STOP successful completion for lapack_demo_svd ...