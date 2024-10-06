! example.f90
! https://cyber.dabamos.de/programming/modernfortran/lapack.html
program main
    ! Example program that solves the matrix equation A * x = B using LAPACK.
    implicit none
    external :: sgesv

    real    :: a(2, 2)  ! Matrix A.
    real    :: b(2)     ! Matrix B.
    real    :: pivot(2) ! Pivot indices (list of swap operations).
    integer :: rc       ! Return code.

    a = reshape([ 2., 3., 1., 1. ], [ 2, 2 ])
    b = [ 5., 6. ]

    call sgesv(2, 1, a, 2, pivot, b, 2, rc)

    if (rc == 0) then
        print '(a, 2(f0.4, ", "))', 'Solution (x, y): ', b
    else
        print '(a, i0)', 'Error: ', rc
    end if
end program main

! dantopa:demos/lapack % rm example
!
! dantopa:demos/lapack % date
! Sat Apr 25 17:00:05 MDT 2020
!
! dantopa:demos/lapack % pwd
! /Users/dantopa/primary-repos/bitbucket/fortran-alpha/demos/lapack
!
! dantopa:demos/lapack % gfortran -o example example.f90 -framework accelerate
!
! dantopa:demos/lapack % ./example
! Solution (x, y): 1.0000, 3.0000,
