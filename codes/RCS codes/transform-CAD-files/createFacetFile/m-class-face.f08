! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassFace

    use mPrecisionDefinitions, only : ip, rp
    use mParametersSimulation, only : zero, zero_vector_i

    implicit none

    type :: face
        ! rank 1: triangles
        integer ( ip ) :: indexVertex ( 1 : 3 ) = [ 0, 0, 0 ]
        real    ( rp ) :: area = zero
    end type face

    ! vertex constructor
    type ( face ), parameter :: face0 = face ( indexVertex = zero_vector_i, area = zero )

end module mClassFace
