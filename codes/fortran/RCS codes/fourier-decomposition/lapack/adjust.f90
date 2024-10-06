! adjust.f90
! https://cyber.dabamos.de/programming/modernfortran/lapack.html
program main
    use, intrinsic :: iso_fortran_env, only : wp => REAL64
    !use :: la_precision, only: wp => dp
    !use :: f95_lapack
    implicit none
    real(kind=wp), parameter :: PI = acos(-1.0_wp)  ! Pi.
    integer,       parameter :: n  = 3              ! Number of common points.

    real(kind=wp) :: a(n * 2, 4)
    real(kind=wp) :: c(n * 2)
    real(kind=wp) :: l(n * 2)
    real(kind=wp) :: m(8), t(8)
    real(kind=wp) :: s, w
    integer       :: i, j

    print '(/, a)', repeat('-', 64)
    print '(a)',    '-- Two-Dimensional Conformal Coordinate Transformation'
    print '(a)',    '-- (Four-Parameter Helmert Transformation)'
    print '(a)',    repeat('-', 64)

    ! Common points (E, N) in the target system.
    l = [ 1049422.40_wp, 51089.20_wp, &
          1049413.95_wp, 49659.30_wp, &
          1049244.95_wp, 49884.95_wp ]

    ! Common points (x, y) in the source system.
    c = [ 121.622_wp, -128.066_wp, &
          141.228_wp,  187.718_wp, &
          175.802_wp,  135.728_wp ]

    ! Print L vector.
    print '(/, a)', 'L Vector'
    print '(a)',    repeat('-', 64)

    do i = 1, size(l)
        write (*, '(f12.3)') l(i)
    end do

    ! Fill coefficient matrix A.
    print '(/, a)', 'A Matrix'
    print '(a)',    repeat('-', 64)

    do i = 1, (n * 2) - 1, 2
        a(    i, :) = [     c(i), -c(i + 1), 1.0_wp, 0.0_wp ]
        a(i + 1, :) = [ c(i + 1),      c(i), 0.0_wp, 1.0_wp ]
    end do

    ! Print A matrix.
    do i = 1, size(a(:, 1))
        do j = 1, size(a(1, :))
            write (*, '(f12.3, " ")', advance='no') a(i, j)
        end do

        write (*, '(a)')
    end do

    ! Compute minimum-norm least squares solution to the linear system
    ! A * X = L using LAPACK95. The vector `l` contains the solution
    ! afterwards.
    call la_gels(a, l)

    ! Print solution.
    print '(/, a)', 'Transformation Parameters'
    print '(a)',    repeat('-', 64)

    print '(a, f12.4)', ' a = ', l(1)
    print '(a, f12.4)', ' b = ', l(2)
    print '(a, f12.4)', 'TX = ', l(3)
    print '(a, f12.4)', 'TY = ', l(4)

    ! Compute rotation angle `w`.
    w = atan2(l(2), l(1))

    ! Add 360° if angle is negative.
    if (w < 0) w = w + (2 * PI)

    ! Compute scale factor `s`.
    s = l(1) / cos(w)

    print '(a, f12.4, a)', ' w = ', w * (180_wp / PI), ' deg'
    print '(a, f12.4)',    ' s = ', s

    ! Transform coordinates from source to target system.
    m = [ 174.148_wp, -120.262_wp, &
          513.520_wp, -192.130_wp, &
          754.444_wp,  -67.706_wp, &
          972.788_wp,  120.994_wp ]

    do i = 1, size(m), 2
        t(i)     = (s * cos(w)) * m(i) - (s * sin(w)) * m(i + 1) + l(3)
        t(i + 1) = (s * sin(w)) * m(i) + (s * cos(w)) * m(i + 1) + l(4)
    end do

    ! Print transformed coordinates.
    print '(/, a)', 'Transformed Coordinates'
    print '(a)',    repeat('-', 64)

    do i = 1, size(t), 2
        write (*, '(2(f12.3, " "))') t(i), t(i + 1)
    end do
end program main

! gfortran -o adjust adjust.f90 -framework accelerate
! Undefined symbols for architecture x86_64:
!   "_la_gels_", referenced from:
!       _MAIN__ in cc0uruhm.o
! ld: symbol(s) not found for architecture x86_64
! collect2: error: ld returned 1 exit status
