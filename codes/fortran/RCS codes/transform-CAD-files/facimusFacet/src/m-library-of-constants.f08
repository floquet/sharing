! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLibraryOfConstants

    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    ! rank 0
    integer ( ip ), parameter :: dim = 3
    integer ( ip ), parameter :: messageLength  = 1024
    integer ( ip ), parameter :: objLineLength  =  132
    integer ( ip ), parameter :: fileNameLength =  256
    ! rank 1
    integer ( ip ), parameter :: zero_vector_i ( 1 : dim ) = 0

    real ( rp ), parameter :: pi = acos ( -1.0_rp )
    real ( rp ), parameter :: zero = 0.0_rp
    real ( rp ), parameter :: oneGB = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp
    real ( rp ), parameter :: myEpsilon = epsilon ( 1.0_rp )
    ! rank 1
    real ( rp ), parameter :: zero_vector_r ( 1 : dim ) = zero

    complex ( rp ), parameter :: cZero       = ( 0.0_rp, 0.0_rp )
    complex ( rp ), parameter :: unitModulus = ( 0.0_rp, 1.0_rp )

    ! Allow strings with length 132 characters
    character ( len = * ), parameter :: objFmt = '( A132 )'

end module mLibraryOfConstants
