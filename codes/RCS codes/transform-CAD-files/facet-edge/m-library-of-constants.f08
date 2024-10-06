! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLibraryOfConstants

    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none

    ! rank 0
    integer ( kind = ip ), parameter :: dim = 3
    integer ( kind = ip ), parameter :: messageLength  = 1024
    integer ( kind = ip ), parameter :: objLineLength  =  132
    integer ( kind = ip ), parameter :: fileNameLength =  256
    ! rank 1
    integer ( kind = ip ), parameter :: zero_vector_i ( 1 : dim ) = 0

    real ( kind = rp ), parameter :: pi = acos ( -1.0_rp )
    real ( kind = rp ), parameter :: zero = 0.0_rp
    real ( kind = rp ), parameter :: oneGB = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp
    real ( kind = rp ), parameter :: myEpsilon = epsilon ( 1.0_rp )
    ! rank 1
    real ( kind = rp ), parameter :: zero_vector_r ( 1 : dim ) = zero

    complex ( kind = rp ), parameter :: cZero       = ( 0.0_rp, 0.0_rp )
    complex ( kind = rp ), parameter :: unitModulus = ( 0.0_rp, 1.0_rp )

    ! Allow strings with length 132 characters
    character ( kind = kindA, len = * ), parameter :: objFmt = '( A132 )'
    character ( kind = kindA, len = * ), parameter :: dimFmt = '( 2( g0, ", " ), g0 )'

end module mLibraryOfConstants
