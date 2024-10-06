program mat_inv
    use, intrinsic :: iso_fortran_env,  only : REAL64
    use inverse,                        only : inv
    implicit none
    integer, parameter :: dp    = selected_real_kind ( REAL64 )
    real(dp) :: inv ( : , : )
    real(dp) :: A ( 2, 2 ), Ainv ( 2, 2 )

        A = reshape ( [ [ 1.0, -1.0 ], [ 2.0, -1.0 ] ], [ 2, 2 ] )
        write ( * , * ) "first  column of A = ", ( A ( 1 , k ), k = 1, 2 )
        write ( * , * ) "second column of A = ", ( A ( 2 , k ), k = 1, 2 )

        Ainv = inv ( A )
        write ( * , * ) "first  column of Ainv = ", ( Ainv ( 1 , k ), k = 1, 2 )
        write ( * , * ) "second column of Ainv = ", ( Ainv ( 2 , k ), k = 1, 2 )
end program mat_inv

! http://fortranwiki.org/fortran/show/Matrix+inversion
! Returns the inverse of a matrix calculated by finding the LU
! decomposition.  Depends on LAPACK.

module inverse
    use, intrinsic :: iso_fortran_env, only : REAL64
    integer, parameter :: dp    = selected_real_kind ( REAL64 )
    implicit none
contains

function inv(A) result(Ainv)
    real(dp), dimension(:,:), intent(in) :: A
    real(dp), dimension(size(A,1),size(A,2)) :: Ainv

    real(dp), dimension(size(A,1)) :: work  ! work array for LAPACK
    integer, dimension(size(A,1)) :: ipiv   ! pivot indices
    integer :: n, info

    ! External procedures defined in LAPACK
    external DGETRF
    external DGETRI

  ! Store A in Ainv to prevent it from being overwritten by LAPACK
  Ainv = A
  n = size(A,1)

  ! DGETRF computes an LU factorization of a general M-by-N matrix A
  ! using partial pivoting with row interchanges.
  call DGETRF(n, n, Ainv, n, ipiv, info)

  if (info /= 0) then
     stop 'Matrix is numerically singular!'
  end if

  ! DGETRI computes the inverse of a matrix using the LU factorization
  ! computed by DGETRF.
  call DGETRI(n, Ainv, n, ipiv, work, n, info)

  if (info /= 0) then
     stop 'Matrix inversion failed!'
  end if
end function inv

end module inverse
