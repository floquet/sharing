! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLibraryOfConstants

    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    real ( rp ), parameter :: pi = acos ( -1.0_rp )
    real ( rp ), parameter :: rZero = 0.0_rp
    real ( rp ), parameter :: machineEpsilon = epsilon ( 1.0_rp )

    complex ( rp ), parameter :: cZero       = ( 0.0_rp, 0.0_rp )
    complex ( rp ), parameter :: cReOne      = ( 1.0_rp, 0.0_rp )
    complex ( rp ), parameter :: cImOne      = ( 0.0_rp, 1.0_rp )
    complex ( rp ), parameter :: unitModulus = ( 0.0_rp, 1.0_rp )

end module mLibraryOfConstants
