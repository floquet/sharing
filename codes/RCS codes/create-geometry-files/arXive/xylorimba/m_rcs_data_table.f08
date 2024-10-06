! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mRCSdataTable

    use mArrayBounds,                   only : nu_lo, nu_hi, azimuth_lo, azimuth_hi, elevation_lo, elevation_hi, numElements
    use mPrecisionDefinitions,          only : ip, sp, rp

    implicit none

    real    ( rp ), parameter :: oneGB = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp

    type :: RCSdataTable
        real ( sp ) :: sigma ( azimuth_lo : azimuth_hi, elevation_lo : elevation_hi, nu_lo : nu_hi )
        real ( sp ) :: rcs_max  = - huge ( 1.0 ), rcs_min = huge ( 1.0 )
        real ( sp ) :: rcs_mean =  0.0, rcs_sd =  0.0
        real ( sp ) :: sum_sigma = 0.0, sum_sigma_squared = 0.0
        real ( rp ) :: sizeArrayGB = 0.0
        integer ( ip ) :: counter = 0, sizeElementBits = 0
        integer ( ip ) :: loc_max ( 1 : 3 ), loc_min ( 1 : 3 )
        character ( len = 128 ) :: quarry
    contains
        procedure, public :: check_table_size           => check_table_size_sub
        procedure, public :: close_table                => close_table_sub
        procedure, public :: load_table_elevation_fixed => load_table_elevation_fixed_sub
    end type RCSdataTable

    private :: check_table_size_sub, close_table_sub, load_table_elevation_fixed_sub
contains

    subroutine load_table_elevation_fixed_sub ( me, nu, elevationAngle, meanTotalRCS )
        class ( RCSdataTable ),  target :: me
        integer ( ip ), intent ( in ) :: nu, elevationAngle
        real    ( sp ), intent ( in ) :: meanTotalRCS ( : )
        real ( sp ) :: loc_max, loc_min
            ! load RCS data
            me % sigma ( azimuth_lo : azimuth_hi, elevationAngle, nu ) = meanTotalRCS ( : )
            ! update macro variables
            me % sum_sigma = me % sum_sigma + sum ( meanTotalRCS ( : ) )
            me % sum_sigma_squared = me % sum_sigma_squared + dot_product ( meanTotalRCS ( : ), meanTotalRCS ( : ) )
            me % counter = me % counter + size ( meanTotalRCS ( : ) )
            loc_min = minval ( meanTotalRCS ( : ) )
            loc_max = maxval ( meanTotalRCS ( : ) )
            if ( loc_max > me % rcs_max ) then
                me % rcs_max = loc_max
                me % loc_max = [ nu, maxloc ( meanTotalRCS ( : ) ), elevationAngle ]
                return
            end if
            if ( loc_min < me % rcs_min ) then
                me % rcs_min = loc_min
                me % loc_min = [ nu, minloc ( meanTotalRCS ( : ) ), elevationAngle ]
            end if
        return
    end subroutine load_table_elevation_fixed_sub

    subroutine check_table_size_sub ( me )
        class ( RCSdataTable ), target :: me
        integer ( ip ) :: size_measured
            size_measured = product ( shape ( me % sigma ))
            if ( size_measured == numElements ) then
                me % sizeElementBits = storage_size ( 1.0_sp )
                me % sizeArrayGB  = real ( me % sizeElementBits * numElements, rp ) / oneGB
                write ( * , fmt = '( 5g0 )' ) "Array size verified: number of elements = ", numElements, &
                                                " totalling ", me % sizeArrayGB, " GB."
                return
            end if
            write ( * , fmt = '( )' ) "There is a discrepancy with the array size."
            write ( * , fmt = '( )' ) "Expected array size = ", numElements, "."
            write ( * , fmt = '( )' ) "Measured array size = ", size_measured, "."
            write ( * , fmt = '( )' ) "Difference = numElements - size_measured = ", numElements - size_measured, "."
            stop "Problem loading data table"
        return
    end subroutine check_table_size_sub

    subroutine close_table_sub ( me )
        class ( RCSdataTable ),  target :: me
        real ( sp ) :: rcs_mean_squared = 0

            call check_table_size_sub ( me )
            if ( me % counter == numElements ) then
                write ( * , fmt = '( )' ) "There is a discrepancy with the array size."
                write ( * , fmt = '( )' ) "Expected array size = ", numElements, "."
                write ( * , fmt = '( )' ) "But the counter shows ", me % counter, " elements."
                write ( * , fmt = '( )' ) "Difference = numElements - counter = ", numElements - me % counter, "."
                write ( * , fmt = '( )' ) "Statistical measures - mean, standard deviation - are incorrect."
                write ( * , fmt = '( )' ) "Extremal values - max, min - are incorrect."
            end if
            me % rcs_mean = me % sum_sigma / real ( me % counter, sp )
            rcs_mean_squared = me % sum_sigma_squared / real ( me % counter, sp )
            me % rcs_mean = sqrt ( rcs_mean_squared - ( me % rcs_mean )** 2 )
        return
    end subroutine close_table_sub

end module mRCSdataTable
