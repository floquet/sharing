! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! Parses alphanumeric line from MoM *.4112.txt and extracts electric field values
module mClassElectricFields

    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg
    use mLibraryOfConstants,            only : cZero, MoMlineLength, messageLength
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ) :: left = 0, right = 0
    integer :: io_stat = 0
    character ( len = messageLength ) :: io_msg = ""
    character ( len = 15 )            :: number = ""

    ! theta = azimuth
    ! phi = elevation (North Pole = 0, equator = 90)
    type :: electricFields
        real     ( rp ) :: meanTotalRCS = 0.0_rp
        real     ( rp ) :: dBsm  = 0.0_rp
        real     ( rp ) :: theta = 0.0_rp, phi = 0.0_rp
        complex  ( rp ) :: thetaTheta = cZero, thetaPhi = cZero, phiTheta = cZero, phiPhi = cZero
    contains
        procedure, public :: gather_mean_total_rcs => gather_mean_total_rcs_sub
    end type electricFields

    private :: gather_mean_total_rcs_sub
    private :: compute_mean_total_rcs_sub, compute_dbsm_sub, extract_electric_fields_sub
    private :: gather_complex_field_sub, gather_real_field_sub

    ! parameters
    integer ( ip ), parameter :: mll = MomlineLength
    ! finger print of data line: start and stop positions for each numerical field
    ! load matrix as columns
    ! sample data line:
    !      90.0000,      0.0000,( -0.4572920E+05,  0.8350829E+05),(  0.2034567E+06, -0.9493007E+05),(  0.2034813E+06, -0.9492184E+05),( -0.1727375E+06,  0.3787291E+05)
    integer, parameter :: endpoints ( 1 : 10, 1 : 2 ) = reshape ( [ [  1, 14, 28, 44, 62, 78,  96, 112, 130, 146 ], &
                                                                    [ 12, 25, 42, 58, 76, 92, 110, 126, 144, 160 ] ], [ 10, 2 ] )
    ! constructor
    type ( electricFields ), parameter :: electricFields0 = electricFields ( meanTotalRCS = 0.0, theta = 0.0, phi = 0.0, &
                                          thetaTheta = cZero, thetaPhi = cZero, phiTheta = cZero, phiPhi = cZero )
contains

    ! master routine: only exposed procedure
    subroutine gather_mean_total_rcs_sub ( me, textLine )
        class ( electricFields ),       target :: me
        character ( len = mll ), intent ( in ) :: textLine
            call extract_electric_fields_sub ( me, textLine )
            call compute_mean_total_rcs_sub  ( me )
            call compute_dbsm_sub            ( me )
        return
    end subroutine gather_mean_total_rcs_sub

    ! Sciacca prescription
    subroutine compute_dbsm_sub ( me )
        class ( electricFields ), target :: me
            me % dBsm = 10.0_rp * log10 ( me % meanTotalRCS )
        return
    end subroutine compute_dbsm_sub

    ! Sciacca prescription
    subroutine compute_mean_total_rcs_sub ( me )
        class ( electricFields ), target :: me
            me % meanTotalRCS = abs ( me % thetaTheta ) + abs ( me % thetaPhi ) + abs ( me % phiTheta ) + abs ( me % phiPhi )
            me % meanTotalRCS = me % meanTotalRCS / real ( 2, kind = rp )
        return
    end subroutine compute_mean_total_rcs_sub

    subroutine extract_electric_fields_sub ( me, textLine )
        class ( electricFields ),       target :: me
        character ( len = mll ), intent ( in ) :: textLine
        integer ( ip ) :: position = 0
            ! move across text line gathering numeric values
            position = 1
            call gather_real_field_sub    ( position = position, real_value = me % theta, textLine = textLine, fmt = "( f12.4 )" )
            call gather_real_field_sub    ( position = position, real_value = me % phi,   textLine = textLine, fmt = "( f12.4 )" )
            call gather_complex_field_sub ( position = position, complex_value = me % thetaTheta, textLine = textLine )
            call gather_complex_field_sub ( position = position, complex_value = me % thetaPhi,   textLine = textLine )
            call gather_complex_field_sub ( position = position, complex_value = me % phiTheta,   textLine = textLine )
            call gather_complex_field_sub ( position = position, complex_value = me % phiPhi,     textLine = textLine )
        return
    end subroutine extract_electric_fields_sub

    subroutine gather_real_field_sub ( position, real_value, textLine, fmt )
        real ( rp ),             intent ( out )   :: real_value
        integer ( ip ),          intent ( inout ) :: position
        character ( len = mll ), intent ( in )    :: textLine
        character ( len =   9 ), intent ( in )    :: fmt
            left  = endpoints ( position, 1 )
            right = endpoints ( position, 2 )
            write ( number, fmt = 100 ) textLine ( left : right )
                if ( io_stat /= 0 ) then
                    write ( * , fmt = '( 3g0 )' ) "Failure to WRITE string value '", trim ( textLine ( left : right ) ) , "'."
                    write ( * , fmt = fmt_stat  ) io_stat
                    write ( * , fmt = fmt_iomsg ) trim ( io_msg )
                    stop "Error occured in module 'mClassElectricFields', subroutine 'gather_real_field_sub'."
                end if
            read  ( number, fmt = fmt ) real_value
                if ( io_stat /= 0 ) then
                    write ( * , fmt = '( 5g0 )' ) "Failure to READ string value '", trim ( textLine ( left : right ) ) , &
                        "' as a REAL number using format descriptor ", fmt, "."
                    write ( * , fmt = fmt_stat  ) io_stat
                    write ( * , fmt = fmt_iomsg ) trim ( io_msg )
                    stop "Error occured in module 'mClassElectricFields', subroutine 'gather_real_field_sub'."
                end if
            position = position + 1
        return
        100 format ( g0 )
    end subroutine gather_real_field_sub

    subroutine gather_complex_field_sub ( position, complex_value, textLine )
        complex ( rp ),          intent ( out )   :: complex_value
        integer ( ip ),          intent ( inout ) :: position
        character ( len = mll ), intent ( in )    :: textLine
        real ( rp ) :: x = 0.0_rp, y = 0.0_rp
            call gather_real_field_sub ( position = position, real_value = x, textLine = textLine, fmt = "( e15.7 )" )
            call gather_real_field_sub ( position = position, real_value = y, textLine = textLine, fmt = "( e15.7 )" )
            complex_value = cmplx ( x, y )
        return
    end subroutine gather_complex_field_sub

end module mClassElectricFields
