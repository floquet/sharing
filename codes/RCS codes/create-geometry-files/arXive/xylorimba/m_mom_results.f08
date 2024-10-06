! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mMoMresults

    implicit none

    type :: MoM
        real :: theta, phi
        real :: mean_total_rcs
        complex :: theta_theta, theta_phi, phi_theta, phi_phi
    contains
        procedure, public :: compute_mean_total_rcs => compute_mean_total_rcs_sub
        procedure, public :: print_mean_total_rcs   => print_mean_total_rcs_sub
    end type MoM

    private :: compute_mean_total_rcs_sub, print_mean_total_rcs_sub

    type ( MoM ), parameter :: MoM0 = MoM ( theta = 0.0, phi = 0.0, mean_total_rcs = 0.0, &
                            theta_theta = ( 0.0, 0.0 ), theta_phi = ( 0.0, 0.0 ), phi_theta = ( 0.0, 0.0 ), phi_phi = ( 0.0, 0.0 ) )
contains

    subroutine compute_mean_total_rcs_sub ( me )
        class ( MoM ), target :: me
            me % mean_total_rcs = abs ( me % theta_theta ) + abs ( me % theta_phi ) + abs ( me % phi_theta ) + abs ( me % phi_phi )
            me % mean_total_rcs = me % mean_total_rcs / real ( 2 )
        return
    end subroutine compute_mean_total_rcs_sub

    subroutine print_mean_total_rcs_sub ( me, io_handle )
        class ( MoM ),  target :: me
        integer, intent ( in ) :: io_handle
            write ( io_handle, fmt = '( 2g0 )' ) "Mean total Radar Cross Section = ", me % mean_total_rcs
        return
    end subroutine print_mean_total_rcs_sub

end module mMoMresults
