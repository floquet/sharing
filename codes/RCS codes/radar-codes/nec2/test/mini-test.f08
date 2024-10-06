program miniTest

    use, intrinsic :: iso_fortran_env,       only : compiler_options, compiler_version

    implicit none

    real :: x, y
    ! machine constants
    real, parameter :: myEpsilon = epsilon ( 1.0 )

    integer :: dt_values ( 1 : 8 ) = 0

            x = 0.0
            y = 1.0

            write ( * , * ) "x = ", x, "; y = ", y
            write ( * , * ) "atan ( y, x ) = ", atan ( y, x )
            write ( * , * ) "log ( myEpsilon ) =  log ( ", myEpsilon, " ) = ", log ( myEpsilon )
            x = 1.0E-20
            write ( * , * ) "log ( x ) =  log ( ", x, " ) = ", log ( x )
            x = tiny ( 1.0 )
            write ( * , * ) "log  ( x ) =  log ( ", x, " ) = ", log ( x )


            ! execution complete - tag output
            call date_and_time ( VALUES = dt_values )
            write ( * , 100 ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

            write ( * , 110 ) "compiler version: ", compiler_version ( )
            write ( * , 110 ) "compiler options: ", compiler_options ( )

        100 format ( /, "completed at", I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )
        110 format ( g0, g0 )
        stop 'Successful run for "miniTest.f08"'

end program miniTest

! dantopa@dtopa-latitude-5491:test $ pwd
! /home/dantopa/repos/bitbucket/fortran-alpha/projects/nec2/test

! dantopa@dtopa-latitude-5491:test $ date
! Tue 11 Feb 2020 11:48:16 AM MST

! dantopa@dtopa-latitude-5491:test $ gfortran -g -o mini-test mini-test.f08 $gflags

! dantopa@dtopa-latitude-5491:test $ ./mini-test
!  x =    0.00000000     ; y =    1.00000000
!  atan ( y, x ) =    1.57079637
!
! completed at 2020-02-11 11:48:28
!
! compiler version: GCC version 9.2.1 20200123
! compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -g -g -Og -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h
! STOP Successful run for "miniTest.f08"
