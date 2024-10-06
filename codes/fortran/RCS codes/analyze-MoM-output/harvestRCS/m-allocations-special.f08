! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mAllocationsSpecial
    ! consolidated memory allocations with error trapping
    ! strategy:
    !  1. check for existing allocation: deallocate if needed
    !  2. allocate by rank and data type
    !  3. populate array: force memory errors to happen in this module

    use mClassAverages,                 only : average, average0
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

contains

    subroutine allocate_rank_two_averages_sub ( rank_2_average, dim1_index_min, dim1_index_max, dim2_index_min, dim2_index_max )
        type ( average ), allocatable, intent ( out ) :: rank_2_average ( : , : )
        integer ( ip ),                intent ( in  ) :: dim1_index_min, dim1_index_max, dim2_index_min, dim2_index_max
        type ( allocationToolKit ), target  :: myKit
        type ( allocationToolKit ), pointer :: p => null ( )

            p => myKit
                call p % compute_number_of_elements2 ( dim1_index_min = dim1_index_min, dim1_index_max = dim1_index_max, &
                                                       dim2_index_min = dim2_index_min, dim2_index_max = dim2_index_max )
                ! how much memory is requested?
                p % sizeElementBits = storage_size ( average0 )
                call p % compute_requested_gb ( )
                write ( p % myKind, '( "data is type ( average )" )' )

                ! hygiene check: is the array already allocated?
                if ( allocated ( rank_2_average ) ) then
                    deallocate ( rank_2_average, stat = p % alloc_status, errmsg = p % alloc_message )
                    if ( p % alloc_status /= 0 ) then
                        call p % post_error_message_intrinsic ( action = 'deallocating' )
                    end if
                end if
                ! the compiler may allow allocations which are not possible
                allocate ( rank_2_average ( dim1_index_min : dim1_index_max, dim2_index_min : dim2_index_max ), &
                            stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
            p => null ( )

            ! verify the memory is truly available
            rank_2_average ( : , : ) = average0

        return
    end subroutine allocate_rank_two_averages_sub

    subroutine allocate_rank_one_averages_sub ( rank_1_average, index_min, index_max )
        type ( average ), allocatable, intent ( out ) :: rank_1_average ( : )
        integer ( ip ),                intent ( in )  :: index_min, index_max
        type ( allocationToolKit ), target  :: myKit
        type ( allocationToolKit ), pointer :: p => null ( )

            p => myKit
                call p % compute_number_of_elements ( index_min = index_min, index_max = index_max )
                ! how much memory is requested?
                p % sizeElementBits = storage_size ( average0 )
                call p % compute_requested_gb ( )
                write ( p % myKind, '( "data type is type ( average )" )' )

                ! hygiene check: is the array already allocated?
                if ( allocated ( rank_1_average ) ) then
                    deallocate ( rank_1_average, stat = p % alloc_status, errmsg = p % alloc_message )
                    if ( p % alloc_status /= 0 ) then
                        call p % post_error_message_intrinsic ( action = 'deallocating' )
                    end if
                end if
                ! the compiler may allow allocations which are not possible
                allocate ( rank_1_average ( index_min : index_max ), stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
            p => null ( )

            ! verify the memory is truly available
            rank_1_average ( : ) = average0

        return
    end subroutine allocate_rank_one_averages_sub

end module mAllocationsSpecial
