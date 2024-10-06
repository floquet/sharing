! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mArrayBounds

    use mPrecisionDefinitions,          only : ip

    implicit none

    integer ( ip ), parameter :: nu_lo = 3, nu_hi = 30, &
                                azimuth_lo   = -179, azimuth_hi   = 180, &
                                elevation_lo = -179, elevation_hi = 180
    integer ( ip ), parameter :: numElements = &
                                ( nu_hi - nu_lo + 1 ) * ( azimuth_hi - azimuth_lo + 1 ) * ( elevation_hi - elevation_lo + 1 )

end module mArrayBounds
