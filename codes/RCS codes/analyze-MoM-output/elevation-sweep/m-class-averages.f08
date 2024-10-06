! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassAverages

    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    type :: average
        real ( rp ) :: mean = 0.0_rp, mean2 = 0.0_rp, standardDeviation = 0.0_rp, &
                       maxValue = 0.0_rp, minValue = 0.0_rp
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: compute_mean_and_variance  => compute_mean_and_variance_sub
    end type average

    private :: compute_mean_and_variance_sub

    ! constructor
    type ( average ), parameter :: average0 = average ( mean = 0.0_rp, mean2 = 0.0_rp, standardDeviation = 0.0_rp, &
                                                        maxValue = 0.0_rp, minValue = 0.0_rp)
contains

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
                    stop "Program crashed in module 'mClassAverages', subroutine 'compute_mean_and_variance_sub'."
                end if
                x = abs ( x )
            end if
            me % standardDeviation = sqrt ( x )
        return
    end subroutine compute_mean_and_variance_sub

end module mClassAverages
