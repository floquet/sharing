! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mAllocationsSpecial
    ! consolidated memory allocations with error trapping
    ! strategy:
    !  1. check for existing allocation: deallocate if needed
    !  2. allocate by rank and data type
    !  3. populate array: force memory errors to happen in this module

    use mClassEdge,                     only : edge, edge0
    use mClassFace,                     only : face, face0
    use mClassVertex,                   only : vertex, vertex0
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

contains

    subroutine allocate_rank_one_edges_sub ( rank_1_edge, index_min, index_max )
        type ( edge ), allocatable, intent ( out ) :: rank_1_edge ( : )
        integer ( kind = ip ),      intent ( in  ) :: index_min, index_max
        type ( allocationToolKit ), target  :: myKit
        type ( allocationToolKit ), pointer :: p => null ( )

            p => myKit
                call p % compute_number_of_elements ( index_min = index_min, index_max = index_max )
                ! how much memory is requested?
                p % sizeElementBits = storage_size ( edge0 )
                call p % compute_requested_gb ( )
                write ( p % myKind, '( "data type is type ( edge )" )' )
                ! hygiene check: is the array already allocated?
                if ( allocated ( rank_1_edge ) ) then
                    deallocate ( rank_1_edge, stat = p % alloc_status, errmsg = p % alloc_message )
                    if ( p % alloc_status /= 0 ) then
                        call p % post_error_message_intrinsic ( action = 'deallocating' )
                    end if
                end if
                ! the compiler may allow allocations which are not possible
                allocate ( rank_1_edge ( index_min : index_max ), stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
            p => null ( )

            ! verify the memory is truly available
            rank_1_edge ( : ) = edge0

        return
    end subroutine allocate_rank_one_edges_sub

    subroutine allocate_rank_one_vertices_sub ( rank_1_vertex, index_min, index_max )
        type ( vertex ), allocatable, intent ( out ) :: rank_1_vertex ( : )
        integer ( kind = ip ),               intent ( in  ) :: index_min, index_max
        type ( allocationToolKit ), target  :: myKit
        type ( allocationToolKit ), pointer :: p => null ( )

            p => myKit
                call p % compute_number_of_elements ( index_min = index_min, index_max = index_max )
                ! how much memory is requested?
                p % sizeElementBits = storage_size ( face0 )
                call p % compute_requested_gb ( )
                write ( p % myKind, '( "data type is type ( vertex )" )' )
                ! hygiene check: is the array already allocated?
                if ( allocated ( rank_1_vertex ) ) then
                    deallocate ( rank_1_vertex, stat = p % alloc_status, errmsg = p % alloc_message )
                    if ( p % alloc_status /= 0 ) then
                        call p % post_error_message_intrinsic ( action = 'deallocating' )
                    end if
                end if
                ! the compiler may allow allocations which are not possible
                allocate ( rank_1_vertex ( index_min : index_max ), stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
            p => null ( )

            ! verify the memory is truly available
            rank_1_vertex ( : ) = vertex0

        return
    end subroutine allocate_rank_one_vertices_sub

    subroutine allocate_rank_one_faces_sub ( rank_1_face, index_min, index_max )
        type ( face ), allocatable, intent ( out ) :: rank_1_face ( : )
        integer ( kind = ip ),             intent ( in  ) :: index_min, index_max
        type ( allocationToolKit ), target  :: myKit
        type ( allocationToolKit ), pointer :: p => null ( )

            p => myKit
                call p % compute_number_of_elements ( index_min = index_min, index_max = index_max )
                ! how much memory is requested?
                p % sizeElementBits = storage_size ( face0 )
                call p % compute_requested_gb ( )
                write ( p % myKind, '( "data type is type ( face )" )' )
                ! hygiene check: is the array already allocated?
                if ( allocated ( rank_1_face ) ) then
                    deallocate ( rank_1_face, stat = p % alloc_status, errmsg = p % alloc_message )
                    if ( p % alloc_status /= 0 ) then
                        call p % post_error_message_intrinsic ( action = 'deallocating' )
                    end if
                end if
                ! the compiler may allow allocations which are not possible
                allocate ( rank_1_face ( index_min : index_max ), stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
            p => null ( )

            ! verify the memory is truly available
            rank_1_face ( : ) = face0

        return
    end subroutine allocate_rank_one_faces_sub

end module mAllocationsSpecial
