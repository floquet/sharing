! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassVertex

    use mIOtools,               only : iostat_check_sub
    use mLibraryOfConstants,    only : dim, messageLength, objLineLength, zero, zero_vector_r, zero_vector_i
    use mPrecisionDefinitions,  only : ip, rp, kindA

    implicit none

    character ( kind = kindA, len = * ), parameter :: moduleCrash = "Program crashed in module 'mClassVertex', "
    integer ( kind = ip ) :: io_stat = 0
    character ( len = messageLength ) :: io_msg = ""

    type :: vertex
        ! rank 1: vectors
        real    ( kind = rp ) :: position ( 1 : dim ) = zero_vector_r
        integer ( kind = ip ) :: colors   ( 1 : dim ) = zero_vector_i
        ! rank 0
        real ( kind = rp ) :: length = zero
        integer ( kind = ip ) :: index = 0
        ! structures
    contains
        procedure, public :: getVertices => getVertices_sub
    end type vertex

    private :: getVertices_sub

    ! vertex constructor
    type ( vertex ), parameter :: vertex0 = vertex ( position = zero_vector_r, length = zero, colors = zero_vector_i, &
                                    index = 0 )
contains

    subroutine getVertices_sub ( me, textLine )
        class ( vertex ), target :: me
        character ( kind = kindA, len = * ), intent ( in ) :: textLine
        integer ( kind = ip ) :: j = 0
        character ( len = 2 ) :: trash = ""
        character ( len = messageLength ) :: crashChain = moduleCrash // trim ( "subroutine 'getVertices_sub'." )

            read ( unit = textLine, fmt = *, iostat = io_stat, iomsg = io_msg ) trash, ( me % position ( j ), j = 1, dim )
            call iostat_check_sub ( action = "unformatted READ", fileName = "string variable 'textLine'", &
                                    iostat = io_stat, iomsg = io_msg, crashChain = crashChain )
            me % length = norm2 ( me % position )

        return
    end subroutine getVertices_sub

end module mClassVertex
