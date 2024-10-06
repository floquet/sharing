! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! nb: /Users/dantopa/Mathematica_files/nb/ert/mercury/snake/fortran-01.nb
program sigma

! Read the Mercury Methods of Moments processed into a table of mean total RCS values
! Use the method of least squares to find
!   RCS ( yaw angle )           radar frequency fixed
!   RCS ( radar frequency )     yaw angle fixed

! Daniel Topa, ERT Corp
! COVID-19 Prisoner

! Class structure
!   RCStable: table of mean total RCS ( nu, alpha )
!   LinearSystem: Sytem Matrix A, data vector b
!        flavors: Fourier, monomial
!        tied to RCStable
!   LeastSquaresResults:
!        amplitudes
!        errors
!        residual error vector
!        tied to linear system

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    use mFormatDescriptors,             only : fmt_datecom
    use mPrecisionDefinitions,          only : ip
    use mTestRoutines,                  only : sciacca_fourier

    implicit none

    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

        call sciacca_fourier ( )
        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( /, "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "sigma.f08."'

end program sigma
