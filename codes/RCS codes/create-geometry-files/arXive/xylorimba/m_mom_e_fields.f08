! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mMoMeFields

    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    type :: eFields
        real     ( rp ) :: theta, phi
        real     ( rp ) :: mean_total_rcs
        complex  ( rp ) :: theta_theta, theta_phi, phi_theta, phi_phi
    contains
        procedure, public :: harvest_e_fields       => harvest_e_fields_sub
        procedure, public :: compute_mean_total_rcs => compute_mean_total_rcs_sub
        procedure, public :: print_mean_total_rcs   => print_mean_total_rcs_sub
    end type eFields

    private :: harvest_e_fields_sub, compute_mean_total_rcs_sub, print_mean_total_rcs_sub

    type ( eFields ), parameter :: eFields0 = eFields ( theta = 0.0, phi = 0.0, mean_total_rcs = 0.0, &
                            theta_theta = ( 0.0, 0.0 ), theta_phi = ( 0.0, 0.0 ), phi_theta = ( 0.0, 0.0 ), phi_phi = ( 0.0, 0.0 ) )
contains

    subroutine compute_mean_total_rcs_sub ( me )
        class ( eFields ), target :: me
            me % mean_total_rcs = abs ( me % theta_theta ) + abs ( me % theta_phi ) + abs ( me % phi_theta ) + abs ( me % phi_phi )
            me % mean_total_rcs = me % mean_total_rcs / real ( 2 )
        return
    end subroutine compute_mean_total_rcs_sub

    subroutine print_mean_total_rcs_sub ( me, io_handle )
        class ( eFields ),  target :: me
        integer, intent ( in ) :: io_handle
            write ( io_handle, fmt = '( 2g0 )' ) "Mean total Radar Cross Section = ", me % mean_total_rcs
        return
    end subroutine print_mean_total_rcs_sub

    subroutine harvest_e_fields_sub ( me, data_line )
        class ( eFields ), target :: me
        character ( len = 161 ), intent ( in ) :: data_line
        ! locals
        real    ( rp ) :: x = 0.0, y = 0.0
        integer ( ip ) :: k = 1, alpha = 0, omega = 0
        ! sample data line:
        !      90.0000,      0.0000,( -0.4572920E+05,  0.8350829E+05),(  0.2034567E+06, -0.9493007E+05),(  0.2034813E+06, -0.9492184E+05),( -0.1727375E+06,  0.3787291E+05)
        integer, parameter :: endpoints ( 1 : 10, 1 : 2 ) = reshape ( [ [ 1, 14, 28, 44, 62, 78, 96, 112, 130, 146 ], &
                                                                    [ 12, 25, 42, 58, 76, 92, 110, 126, 144, 160 ] ], [ 10, 2 ] )
        character ( len = 256 ) :: number = ""

            k = 1
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            !write ( * , fmt = '( 8g0 )' ) " k = ", k, "; alpha = ", alpha, "; omega = ", omega, "; data line = ", data_line
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( f12.4 )' ) me % theta
            !write ( * , fmt = '( 3g0 )' ) "character string: ", trim ( number ), "-"
            !write ( * , fmt = '( 3g0 )' ) "eFields % theta = ", me % theta, "-"

            k = k + 1
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( f12.4 )' ) me % phi
            !write ( * , fmt = '( 3g0 )' ) "eFields % phi = ", me % phi, "-"

            k = k + 1
            ! theta - theta
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) x

            k = k + 1
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) y
            me % theta_theta = cmplx ( x, y )
            !write ( * , fmt = '( 5g0 )' ) "eFields % theta_theta = ", me % theta_theta % re, " + i ", me % theta_theta % im, "*"

            k = k + 1
            ! theta - phi
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) x

            k = k + 1
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) y
            me % theta_phi = cmplx ( x, y )
            !write ( * , fmt = '( 5g0 )' ) "eFields % theta_phi = ", me % theta_phi % re, " + i ", me % theta_phi % im, "*"

            k = k + 1
            ! phi - theta
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) x

            k = k + 1
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) y
            me % phi_theta = cmplx ( x, y )
            !write ( * , fmt = '( 5g0 )' ) "eFields % phi_theta = ", me % phi_theta % re, " + i ", me % phi_theta % im, "*"

            k = k + 1
            ! phi - phi
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) x

            k = k + 1
            alpha = endpoints ( k, 1 )
            omega = endpoints ( k, 2 )
            write ( number, fmt = '( g0 )' ) data_line ( alpha : omega )
            read  ( number, fmt = '( e15.7 )' ) y
            me % phi_phi = cmplx ( x, y )
            !write ( * , fmt = '( 5g0 )' ) "eFields % phi_phi = ", me % phi_phi % re, " + i ", me % phi_phi % im, "*"

            call me % compute_mean_total_rcs ( )
            !write ( * , fmt = '( 2g0 )' ) "mean_total_rcs = ", me % mean_total_rcs

        return
    end subroutine harvest_e_fields_sub

end module mMoMeFields
