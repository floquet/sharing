! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mParameters

    use mPrecisionDefinitions, only : ip, rp

    implicit none

    ! mathematical constants
    real ( rp ), parameter :: pi = acos ( -1.0_rp ), pot = pi / 2.0_rp, tp = pi + pi
    real ( rp ), parameter :: rtwo = sqrt ( 2.0_rp ), rrtwo = 1.0_rp / rtwo
    real ( rp ), parameter :: radToDeg = 180.0_rp / pi, degToRad = 1.0_rp / radToDeg
    ! complex constants
    complex ( rp ), parameter :: cospof = ( rrtwo, rrtwo )
    complex ( rp ), parameter :: i      = cmplx ( 0.0_rp, 1.0_rp, rp )
    complex ( rp ), parameter :: czero  = cmplx ( 0.0_rp, 0.0_rp, rp )
    complex ( rp ), parameter :: cone   = cmplx ( 1.0_rp, 0.0_rp, rp )
    complex ( rp ), parameter :: ctwo   = cmplx ( 2.0_rp, 0.0_rp, rp )

    complex ( rp ), parameter :: sp     = ( 1.772453851_rp, 0.0_rp )
    complex ( rp ), parameter :: tosp   = cmplx ( 2.0_rp, kind = rp ) / sp

    ! physical constants
    real ( rp ), parameter :: c     = 299792458 ! m/s, exact
    real ( rp ), parameter :: cmotp = 60.0_rp

    ! machine constants
    real ( rp ), parameter :: myEpsilon = epsilon ( 1.0_rp )
    real ( rp ), parameter :: threshold = 3.0_rp

end module mParameters
