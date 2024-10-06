! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mAllocations
    ! consolidated memory allocations with error trapping
    ! strategy:
    !  1. check for existing allocation: deallocate if needed
    !  2. allocate by rank and data type
    !  3. populate array: force memory errors to happen in this module

    use mClassVertex,          only : vertex, vertex0
    use mClassFace,            only : face, face0
    use mFormatDescriptors,    only : fmt_allocerror, fmt_allocstat, fmt_allocmsg, fmt_allocsize, fmt_one
    use mPrecisionDefinitions, only : ip, rp

    implicit none

    integer ( ip ) :: k = 0_ip
    integer ( ip ) :: sizeElementBits = 0_ip

    real    ( rp ) :: requestedGB = 0.0_rp, oneGB = 8.0_rp * 1024.0_rp * 1024.0_rp * 1024.0_rp

    character ( len = 512 ) :: myKind = ""

    ! system status
    integer   ( ip )        :: alloc_status  = 0_ip
    character ( len = 512 ) :: alloc_message = ""

    private :: post_error_message_sub
    ! procedure, public  :: rank_one_integers => rank_one_integers_sub

contains

    subroutine rank_one_faces_sub ( face_array, nElements )

        type ( face ), allocatable, intent ( out ) :: face_array ( : )
        integer ( ip ),               intent ( in )  :: nElements

            ! how much memory is requested?
            sizeElementBits = storage_size ( face0 )
            requestedGB     = real ( sizeElementBits * nElements, rp ) / oneGB
            write ( myKind, '( "data type is FACE" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( face_array ) ) then
                deallocate ( face_array, stat = alloc_status, errmsg = alloc_message )
                if ( alloc_status /= 0 ) then
                    call post_error_message_sub ( 'deallocating', nElements )
                end if
            end if

            ! the compiler may allow allocations which are not possible
            allocate ( face_array ( 1 : nElements ), stat = alloc_status, errmsg = alloc_message )
            if ( alloc_status /= 0 ) then
                call post_error_message_sub ( 'allocating', nElements )
            end if

            ! verify the memory is truly available
            face_array ( : ) = face0

    end subroutine rank_one_faces_sub

    subroutine rank_one_vertices_sub ( vertex_array, nElements )

        type ( vertex ), allocatable, intent ( out ) :: vertex_array ( : )
        integer ( ip ),               intent ( in )  :: nElements

            ! how much memory is requested?
            sizeElementBits = storage_size ( vertex0 )
            requestedGB     = real ( sizeElementBits * nElements, rp ) / oneGB
            write ( myKind, '( "data type is VERTEX" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( vertex_array ) ) then
                deallocate ( vertex_array, stat = alloc_status, errmsg = alloc_message )
                if ( alloc_status /= 0 ) then
                    call post_error_message_sub ( 'deallocating', nElements )
                end if
            end if

            ! the compiler may allow allocations which are not possible
            allocate ( vertex_array ( 1 : nElements ), stat = alloc_status, errmsg = alloc_message )
            if ( alloc_status /= 0 ) then
                call post_error_message_sub ( 'allocating', nElements )
            end if

            ! verify the memory is truly available
            vertex_array ( : ) = vertex0

    end subroutine rank_one_vertices_sub

    subroutine post_error_message_sub ( action, nElements )
        integer ( ip ),        intent ( in )  :: nElements
        character ( len = * ), intent ( in )  :: action

            write ( *, fmt = fmt_allocerror ) action, nElements
            write ( *, fmt = fmt_allocstat  ) alloc_status
            write ( *, fmt = fmt_allocmsg   ) trim ( alloc_message )
            write ( *, fmt = fmt_one        ) trim ( myKind )
            write ( *, fmt = fmt_allocsize  ) sizeElementBits, requestedGB

            stop "# # #  Failed memory allocation  # # #"

        return
    end subroutine post_error_message_sub

end module mAllocations
