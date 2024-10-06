! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLibraryConstants

    use mPrecisionDefinitions, only : ip, rp

    implicit none

    ! define the spatial dimension (dim)
    integer ( kind = ip ), parameter :: dim = 3_ip
    integer ( kind = ip ), parameter :: zero_vector_i = 0_ip
    ! standard length for strings
    integer ( kind = ip ), parameter :: messageLength  = 1024
    integer ( kind = ip ), parameter :: objLineLength  =  132
    integer ( kind = ip ), parameter :: fileNameLength =  256

    ! pi
    real ( kind = rp ), parameter :: pi = acos ( -1.0_rp )
    real ( kind = rp ), parameter :: deg = pi / 180.0_rp
    ! machine parameters
    real ( kind = rp ), parameter :: oneGB = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp
    real ( kind = rp ), parameter :: myEpsilon = epsilon ( 1.0_rp )
    ! constants
    real ( kind = rp ), parameter :: zero = 0.0_rp, one = 1.0_rp
    real ( kind = rp ), parameter :: zero_vector_r ( 1 : dim ) = 0.0_rp

    complex ( kind = rp ), parameter :: cZero        = ( 0.0_rp, 0.0_rp )
    complex ( kind = rp ), parameter :: cUnitModulus = ( 0.0_rp, 1.0_rp )

end module mLibraryConstants
