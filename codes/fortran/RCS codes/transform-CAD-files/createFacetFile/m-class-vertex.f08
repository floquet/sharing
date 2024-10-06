! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassVertex

    use mPrecisionDefinitions, only : ip, rp
    use mParametersSimulation, only : dim, zero_vector_r, zero_vector_i

    implicit none

    type :: vertex
        ! rank 1: vectors
        real    ( rp ) :: position ( 1 : dim ) = zero_vector_r
        integer ( ip ) :: colors   ( 1 : dim ) = zero_vector_i
    end type vertex

    ! vertex constructor
    type ( vertex ), parameter :: vertex0 = vertex ( position = zero_vector_r, colors = zero_vector_i )

end module mClassVertex
