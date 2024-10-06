! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLibraryOfConstants

    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    ! rank 0
    integer ( ip ), parameter :: fileNameLength = 256, rl = 128, msgl = 1024

    real ( rp ), parameter :: pi        = acos ( -1.0_rp ), &
                              zero      = 0.0_rp, &
                              oneGB     = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp, &
                              myEpsilon = epsilon ( 1.0_rp )

    complex ( rp ), parameter :: cZero        = ( 0.0_rp, 0.0_rp ), &
                                 cUnitModulus = ( 0.0_rp, 1.0_rp )

    character ( len = 4 ), parameter :: tab = "    "

end module mLibraryOfConstants
