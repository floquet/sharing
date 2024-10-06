! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mAllocations
    ! consolidated memory allocations with error trapping
    ! strategy:
    !  1. check for existing allocation: deallocate if needed
    !  2. allocate by rank and data type
    !  3. populate array: force memory errors to happen in this module

    use mFormatDescriptors,             only : fmt_allocerror, fmt_allocstat, fmt_allocmsg, fmt_allocsize, fmt_one
    use mLibraryOfConstants,            only : fileNameLength, oneGB
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none

    integer ( kind = ip ), parameter :: fnl = fileNameLength

    type :: allocationToolKit
        real    ( kind = rp ) :: requestedGB = 0.0_rp
        integer ( kind = ip ) :: alloc_status = 0_ip, sizeElementBits = 0_ip, numElements = 0_ip
        character ( len = fnl ) :: alloc_message = "", myKind = ""
    contains
            ! rank 1
        procedure, public :: allocate_rank_one_characters => allocate_rank_one_characters_sub, &
                             allocate_rank_one_integers   => allocate_rank_one_integers_sub, &
                             allocate_rank_one_reals      => allocate_rank_one_reals_sub, &
                             clone_rank_one_reals         => clone_rank_one_reals_sub
            ! service routines
        procedure, public :: compute_requested_gb         => compute_requested_gb_sub, &
                             post_error_message_intrinsic => post_error_message_intrinsic_sub, &
                             post_error_message_composite => post_error_message_composite_sub, &
                             compute_number_of_elements   => compute_number_of_elements_sub, &
                             compute_number_of_elements2  => compute_number_of_elements2_sub
    end type allocationToolKit

    private :: allocate_rank_one_integers_sub, allocate_rank_one_characters_sub, allocate_rank_one_reals_sub, &
               clone_rank_one_reals_sub, &
               compute_requested_gb_sub, compute_number_of_elements_sub, compute_number_of_elements2_sub, &
               post_error_message_intrinsic_sub, post_error_message_composite_sub

    ! constructor
    type ( allocationToolKit ), parameter :: allocationToolKit0 = allocationToolKit ( requestedGB = 0.0_rp, alloc_status = 0, &
            sizeElementBits = 0, numElements = 0, alloc_message = "", myKind = "" )
contains

    subroutine clone_rank_one_reals_sub ( me, target_array, mold_array )
        class ( allocationToolKit ), target :: me
        real ( kind = rp ), allocatable, intent ( out ) :: target_array ( : )
        real ( kind = rp ),              intent ( in  ) :: mold_array ( : )

            me % numElements = size ( target_array )
            ! how much memory is requested?
            me % sizeElementBits = storage_size ( 1.0_rp )
            call compute_requested_gb_sub ( me )
            write ( me % myKind, '( "data type is REAL (rp)" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( target_array ) ) then
                deallocate ( target_array, stat = me % alloc_status, errmsg = me % alloc_message )
                if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'deallocating' )
                end if
            end if
            ! clone
            allocate ( target_array, source = mold_array, stat = me % alloc_status, errmsg = me % alloc_message )
            if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'allocating' )
            end if

            ! verify the memory is truly available
            target_array ( : ) = 0
        return
    end subroutine clone_rank_one_reals_sub

    subroutine allocate_rank_one_characters_sub ( me, character_array, index_min, index_max )
        class ( allocationToolKit ), target :: me
        character ( kind = kindA, len = * ), allocatable, intent ( out ) :: character_array ( : )
        integer ( kind = ip ),                     intent ( in  ) :: index_min, index_max

            ! how much memory is requested?
            me % sizeElementBits = storage_size ( " " )
            write ( me % myKind, '( "data type is CHARACTER" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( character_array ) ) then
                deallocate ( character_array, stat = me % alloc_status, errmsg = me % alloc_message )
                if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'deallocating' )
                end if
            end if
            ! the compiler may allow allocations which are not possible
            allocate ( character_array ( index_min : index_max ), stat = me % alloc_status, errmsg = me % alloc_message )
            if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'allocating' )
            end if
            ! verify the memory is truly available
            character_array ( : ) = ""

        return
    end subroutine allocate_rank_one_characters_sub

    subroutine allocate_rank_one_integers_sub ( me, integer_array, index_min, index_max )
        class ( allocationToolKit ), target :: me
        integer ( kind = ip ), allocatable, intent ( out ) :: integer_array ( : )
        integer ( kind = ip ),              intent ( in  ) :: index_min, index_max

            call compute_number_of_elements_sub ( me, index_min = index_min, index_max = index_max )
            ! how much memory is requested?
            me % sizeElementBits = storage_size ( 1_ip )
            call compute_requested_gb_sub ( me )
            write ( me % myKind, '( "data type is INTEGER (ip)" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( integer_array ) ) then
                deallocate ( integer_array, stat = me % alloc_status, errmsg = me % alloc_message )
                if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'deallocating' )
                end if
            end if
            ! the compiler may allow allocations which are not possible
            allocate ( integer_array ( index_min : index_max ), stat = me % alloc_status, errmsg = me % alloc_message )
            if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'allocating' )
            end if

            ! verify the memory is truly available
            integer_array ( : ) = 0
        return
    end subroutine allocate_rank_one_integers_sub

    subroutine allocate_rank_one_reals_sub ( me, real_array, index_min, index_max )
        class ( allocationToolKit ), target :: me
        real ( kind = rp ), allocatable, intent ( out ) :: real_array ( : )
        integer ( kind = ip ),           intent ( in )  :: index_min, index_max

            call compute_number_of_elements_sub ( me, index_min = index_min, index_max = index_max )
            ! how much memory is requested?
            me % sizeElementBits = storage_size ( 1.0_rp )
            call compute_requested_gb_sub ( me )
            write ( me % myKind, '( "data type is REAL (rp)" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( real_array ) ) then
                deallocate ( real_array, stat = me % alloc_status, errmsg = me % alloc_message )
                if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'deallocating' )
                end if
            end if
            ! the compiler may allow allocations which are not possible
            allocate ( real_array ( index_min : index_max ), stat = me % alloc_status, errmsg = me % alloc_message )
            if ( me % alloc_status /= 0 ) then
                    call post_error_message_intrinsic_sub ( me, action = 'allocating' )
            end if

            ! verify the memory is truly available
            real_array ( : ) = 0
        return
    end subroutine allocate_rank_one_reals_sub

    subroutine post_error_message_intrinsic_sub ( me, action )
        class ( allocationToolKit ),  target :: me
        character ( kind = kindA, len = * ), intent ( in ) :: action

            write ( *, fmt = fmt_allocerror ) action, me % numElements
            write ( *, fmt = fmt_allocstat  ) me % alloc_status
            write ( *, fmt = fmt_allocmsg   ) trim ( me % alloc_message )
            write ( *, fmt = fmt_one        ) trim ( me % myKind )
            write ( *, fmt = fmt_allocsize  ) me % sizeElementBits, me % requestedGB

            stop "# # #  Failed memory allocation  # # #"

        return
    end subroutine post_error_message_intrinsic_sub

    subroutine post_error_message_composite_sub ( me, action )
        class ( allocationToolKit ),  target :: me
        character ( kind = kindA, len = * ), intent ( in ) :: action

            write ( *, fmt = fmt_allocerror ) action, me % numElements
            write ( *, fmt = fmt_allocstat  ) me % alloc_status
            write ( *, fmt = fmt_allocmsg   ) trim ( me % alloc_message )

            stop "# # #  Failed memory allocation  # # #"

        return
    end subroutine post_error_message_composite_sub

    subroutine compute_requested_gb_sub ( me )
        class ( allocationToolKit ), target :: me
            me % requestedGB  = real ( me % sizeElementBits * me % numElements, kind = rp ) / oneGB
        return
    end subroutine compute_requested_gb_sub

    subroutine compute_number_of_elements_sub ( me, index_min, index_max )
        class ( allocationToolKit ), target :: me
        integer ( kind = ip ), intent ( in ) :: index_min, index_max
            me % numElements = index_max - index_min + 1
        return
    end subroutine compute_number_of_elements_sub

    subroutine compute_number_of_elements2_sub ( me, dim1_index_min, dim1_index_max, dim2_index_min, dim2_index_max )
        class ( allocationToolKit ), target :: me
        integer ( kind = ip ), intent ( in ) :: dim1_index_min, dim1_index_max, dim2_index_min, dim2_index_max
            me % numElements = ( dim1_index_max - dim1_index_min + 1 ) * ( dim2_index_max - dim2_index_min + 1 )
        return
    end subroutine compute_number_of_elements2_sub

    subroutine compute_number_of_elements3_sub ( me, dim1_index_min, dim1_index_max, &
                                                     dim2_index_min, dim2_index_max, &
                                                     dim3_index_min, dim3_index_max )
        class ( allocationToolKit ), target :: me
        integer ( kind = ip ),       intent ( in ) :: dim1_index_min, dim1_index_max, &
                                               dim2_index_min, dim2_index_max, &
                                               dim3_index_min, dim3_index_max
            me % numElements = ( dim1_index_max - dim1_index_min + 1 ) * &
                               ( dim2_index_max - dim2_index_min + 1 ) * &
                               ( dim3_index_max - dim3_index_min + 1 )
        return
    end subroutine compute_number_of_elements3_sub

end module mAllocations
