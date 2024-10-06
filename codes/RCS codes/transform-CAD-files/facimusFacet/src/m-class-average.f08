! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassAverage

    use mPrecisionDefinitions,             only : ip, rp

    implicit none

    type :: extremal
        ! extremal values and locations
        real    ( rp ) :: maxValue = - huge( 1.0_rp ), minValue = huge( 1.0_rp ), variation = 0.0_rp
        integer ( ip ) :: maxLoc = 0, minLoc = 0
    end type extremal

    ! constructor
    type ( extremal ), parameter :: extremal0 = extremal ( maxValue = - huge( 1.0_rp ), minValue = huge( 1.0_rp ), &
                                                           maxLoc = 0, minLoc = 0 )
    type :: average
        ! first and second moment
        real ( rp )       :: mean = 0.0_rp, mean2 = 0.0_rp, standardDeviation = 0.0_rp
        type ( extremal ) :: extrema = extremal0
    contains
        procedure, public :: compute_mean_and_variance  => compute_mean_and_variance_sub, &
                             find_max_and_min           => find_max_and_min_sub, &
                             write_statistics           => write_statistics_sub
    end type average

    ! constructor
    type ( average ), parameter :: average0 = average ( mean = 0.0_rp, mean2 = 0.0_rp, standardDeviation = 0.0_rp, &
                                                        extrema = extremal0 )

    private :: compute_mean_and_variance_sub, find_max_and_min_sub, write_statistics_sub

contains

    subroutine write_statistics_sub ( me, io_unit, propertyName, census )
        class ( average ), target     :: me
        integer ( ip ), intent ( in ) :: io_unit, census
        character ( len = * ), intent ( in ) :: propertyName
            write ( io_unit , fmt = '( 2g0 )' ) "Statistics for ", census, " ", propertyName
            write ( io_unit , fmt = '( 4g0 )' ) "mean      = ", me % mean, " +/- ", me % standardDeviation
            write ( io_unit , fmt = '( 4g0 )' ) "minimum   = ", me % extrema % minValue, ", position = ", me % extrema % minLoc
            write ( io_unit , fmt = '( 4g0 )' ) "maximum   = ", me % extrema % maxValue, ", position = ", me % extrema % maxLoc
            write ( io_unit , fmt = '( 2g0 )' ) "variation = ", me % extrema % variation
            write ( io_unit , * )
        return
    end subroutine write_statistics_sub

    subroutine compute_mean_and_variance_sub ( me, vector, one )
        class ( average ),  target :: me
        real ( rp ), intent ( in ) :: vector ( : ), one ( : )
        real ( rp ) :: clicks = 0.0_rp, threshold = 0.0_rp, x = 0.0_rp
            clicks    = 10.0_rp
            threshold = clicks * epsilon ( 1.0_rp )
            ! compute inner products
            me % mean  = dot_product ( one,    vector ) / dot_product ( one, one )
            me % mean2 = dot_product ( vector, vector ) / dot_product ( one, one )
            ! standard deviation
            x = me % mean2 - me % mean ** 2
            ! x may represent the difference of two very large numbers
            ! (for a large set of uniform numbers)
            if ( x < 0.0_rp ) then
                if ( abs ( x ) > threshold ) then
                    write ( * , fmt = '( 2g0 )' ) "Program trying to compute the square root of a negative number x = ", x
                    write ( * , fmt = '( 5g0 )' ) "Tolerance for x is ", clicks, " x machine epsilon = ", threshold, "."
                    write ( * , fmt = '(  g0 )' ) "This error may have occured when taking the difference of two large numbers."
                    write ( * , fmt = '( 6g0 )' ) "Mean of the squares = ", me % mean2, "; square of the mean = ", me % mean ** 2, &
                                                    ": difference = ", x
                    stop "Program crashed in module 'mClassAverage', subroutine 'compute_mean_and_variance_sub'."
                end if
                x = abs ( x )
            end if
            me % standardDeviation = sqrt ( x )
        return
    end subroutine compute_mean_and_variance_sub

    subroutine find_max_and_min_sub ( me, vector )
        class ( average ),  target :: me
        real ( rp ), intent ( in ) :: vector ( : )
        type ( extremal ), pointer :: p => null ( )

            p => me % extrema
                p % maxValue = maxval ( vector )
                p % minValue = minval ( vector )

                p % maxLoc = maxloc ( vector, dim = 1, kind = ip )
                p % minLoc = minloc ( vector, dim = 1, kind = ip )

                p % variation = p % maxValue - p % minValue
            p => null ( )

        return
    end subroutine find_max_and_min_sub

end module mClassAverage
