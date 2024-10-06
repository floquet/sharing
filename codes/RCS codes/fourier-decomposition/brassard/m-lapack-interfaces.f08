! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! https://stackoverflow.com/questions/8508590/standard-input-and-output-units-in-fortran-90
module mLapackInterfaces

    implicit none

    ! Modern Fortran Explained
    !   Michael Metcalf, John Reid, Malcolm Cohen
    ! 5.11 Explicit and implicit interfaces, p. 84
    ! Benefits of the explicit interface
    !   Even when not strictly required, it gives the compiler an opportunity to examine data dependencies
    !   and thereby improve optimization. Explicit interfaces are also  desirable because of the additional
    !   security that they provide. It is straightforward to ensure  that all interfaces are explicit, and
    !   we recommend the practice.

    interface lapack
        ! Compute the singular values and left and right singular vectors of A (A = U S (V'), m >= n )
        ! Overwrite A by U
        ! DGESVD computes the singular value decomposition (SVD) of a real
        ! m-by-n matrix A, optionally computing the left and/or right singular
        ! vectors. The SVD for a matrix A is

        ! A = U ! SIGMA ! transpose(V)
        ! where SIGMA is an m-by-n matrix which is zero except for its
        ! min(m,n) diagonal elements, U is an m-by-m orthogonal matrix, and
        ! V is an n-by-n orthogonal matrix.  The diagonal elements of SIGMA
        ! are the singular values of A; they are real and non-negative, and
        ! are returned in descending order.  The first min(m,n) columns of
        ! U and V are the left and right singular vectors of A.

        ! Note that the routine returns the transpose matrix V^T, not V.

        ! JOBU = 'A':  all M columns of U are returned in array U
        ! JOBVT = 'A':  all N rows of V**T are returned in the array VT
        ! A     (input/output) DOUBLE PRECISION array, dimension ( LDA, N )
        !       On entry, the M-by-N matrix A
        !       if JOBU .ne. 'O' and JOBVT .ne. 'O', the contents of A are destroyed.
        ! LDA = leading dimension of the array A.  LDA >= max( 1, M )
        ! U     (output) DOUBLE PRECISION array, dimension (LDU, UCOL)
        !       (LDU,M) if JOBU = 'A'
        !       For JOBU = 'A', U contains the M-by-M orthogonal matrix U;
        ! LDU = leading dimension of the array U
        !       For JOBU = 'A', LDU >= M
        ! VT    (output) DOUBLE PRECISION array, dimension (LDVT, N)
        !       For JOBU = 'A', VT contains the N-by-N orthogonal matrix V**T
        ! WORK  (workspace/output) DOUBLE PRECISION array, dimension (MAX(1, LWORK))
        !       On exit, if INFO = 0, WORK(1) returns the optimal LWORK
        !       if INFO > 0, WORK(2:MIN(M,N)) contains the unconverged
        !       superdiagonal elements of an upper bidiagonal matrix B
        !       whose diagonal is in S (not necessarily sorted). B
        !       satisfies A = U * B * VT, so it has the same singular values
        !       as A, and singular vectors related by U and VT.
        !  LWORK (input) INTEGER
        !       The dimension of the array WORK.
        !       LWORK >= MAX(1, 3*MIN(M,N) + MAX(M,N), 5*MIN(M,N) ).
        !       For good performance, LWORK should generally be larger.
        subroutine DGESVD ( JOBU, JOBVT, M, N, A, LDA, S, U, LDU, VT, LDVT, WORK, LWORK, INFO )
            use mPrecisionDefinitions, only : ip, rp, kindA
            character ( kind = kindA, len = 1 ), intent ( in )    :: JOBU, JOBVT
            integer ( kind = ip ),               intent ( in )    :: M, N, LDA, LDU, LDVT, LWORK
            integer ( kind = ip ),               intent ( out )   :: INFO
            real ( kind = rp ),                  intent ( out )   :: S ( : ), U ( : , : ), VT ( : , : ), WORK ( : )
            real ( kind = rp ),                  intent ( inout ) :: A ( : , : )
        end subroutine DGESVD
    end interface lapack

end module mLapackInterfaces
