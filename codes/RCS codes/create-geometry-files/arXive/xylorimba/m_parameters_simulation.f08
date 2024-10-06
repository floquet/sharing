! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mParametersSimulation

    use mPrecisionDefinitions, only : ip, rp

    implicit none

    ! define the spatial dimension (dim)
    integer ( ip ), parameter :: dim = 3_ip
    integer ( ip ), parameter :: zero_vector_i = 0_ip

    real ( rp ), parameter :: pi = acos ( -1.0_rp )
    real ( rp ), parameter :: deg = pi / 180.0_rp
    real ( rp ), parameter :: zero = 0.0_rp, one = 1.0_rp
    real ( rp ), parameter :: zero_vector_r ( 1 : dim ) = 0.0_rp

    ! rank 0: scalars
    real ( rp ), parameter :: myEpsilon = epsilon ( 1.0_rp )

end module mParametersSimulation
