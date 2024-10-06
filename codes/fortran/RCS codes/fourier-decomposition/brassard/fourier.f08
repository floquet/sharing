! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! nb: /Users/dantopa/Mathematica_files/nb/ert/mercury/snake/fortran-01.nb
program fourier

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
    use mTestRoutines,                  only : test_svd_sub

    implicit none

    ! containers for date and time
    integer ( kind = ip ) :: dt_values ( 1 : 8 ) = 0_ip

        call test_svd_sub ( )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( /, "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "fourier.f08."'

end program fourier

! root@76a532f26f73:bosun $ ./fourier

! First ten elements of yaw_mesh:
! -3.1415926535897931, -3.1241393610698500, -3.1066860685499065, -3.0892327760299634, -3.0717794835100198, -3.0543261909900767, -3.0368728984701332, -3.0194196059501901, -3.0019663134302470, -2.9845130209103035
! build_A_Fourier_sub rows =          361 , cols =            8
! shape( A ) = 3618

! MoM data has 5 rows and 8 columns.
!   37.84    37.82    37.79    37.73    37.65    37.54    37.42    37.27
!   30.43    30.40    30.29    30.12    29.87    29.56    29.18    28.74
!   22.04    22.02    21.95    21.82    21.65    21.43    21.15    20.84
!   17.81    17.78    17.68    17.53    17.31    17.03    16.70    16.31
!   21.49    21.46    21.34    21.14    20.86    20.50    20.08    19.60

! First ten elements of data vector:
! 22.044641407289497, 22.021585444386169, 21.947561533693616, 21.822935479718829, 21.648422398049579, 21.425048418225487, 21.154200410945680, 20.837501396002700, 20.476890177459286, 20.074563289810804
! mySystem % rows =          361
! mySystem % cols =            8
! me % len_solution =            8

! W matrix has 8 rows and 8 columns.
!  361.00    -1.00     1.00    -1.00     1.00    -1.00     1.00    -1.00
!   -1.00   181.00    -1.00     1.00    -1.00     1.00    -1.00     1.00
!    1.00    -1.00   181.00    -1.00     1.00    -1.00     1.00    -1.00
!   -1.00     1.00    -1.00   181.00    -1.00     1.00    -1.00     1.00
!    1.00    -1.00     1.00    -1.00   181.00    -1.00     1.00    -1.00
!   -1.00     1.00    -1.00     1.00    -1.00   181.00    -1.00     1.00
!    1.00    -1.00     1.00    -1.00     1.00    -1.00   181.00    -1.00
!   -1.00     1.00    -1.00     1.00    -1.00     1.00    -1.00   181.00
! into dgetrf: rows =            8 , cols =            8

! Program received signal SIGFPE: Floating-point exception - erroneous arithmetic operation.

! Backtrace for this error:
! #0  0x7f462b2f43ff in ???
! #1  0x7f462c54c609 in ???
! #2  0x7f462c32e55c in ???
! #3  0x410d91 in __msolutionnormal_MOD_normal_equations_solve_sub
!        at /home/dantopa/repos/bitbucket/ftn/rcs/fourier/bosun/m-solution-normal.f08:143
! #4  0x40fe08 in __mtestroutines_MOD_sciacca_fourier
!         at /home/dantopa/repos/bitbucket/ftn/rcs/fourier/bosun/m-test-routines.f08:51
! #5  0x402f64 in fourier
!         at /home/dantopa/repos/bitbucket/ftn/rcs/fourier/bosun/fourier.f08:34
! #6  0x403221 in main
!         at /home/dantopa/repos/bitbucket/ftn/rcs/fourier/bosun/fourier.f08:25
! Floating point exception
