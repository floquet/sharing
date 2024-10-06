! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLibraryOfConstants

    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: messageLength  = 1024
    integer ( ip ), parameter :: MoMlineLength  =  161
    integer ( ip ), parameter :: fileNameLength =  256

    real ( rp ), parameter :: pi = acos ( -1.0_rp )
    real ( rp ), parameter :: oneGB = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp

    complex ( rp ), parameter :: cZero       = ( 0.0_rp, 0.0_rp )
    complex ( rp ), parameter :: unitModulus = ( 0.0_rp, 1.0_rp )

    ! MoM *.4112.txt lines are strings with length 161 characters
    character ( len = * ), parameter :: MoMfmt = '( A161 )'

end module mLibraryOfConstants
