! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mAllocations
    ! consolidated memory allocations with error trapping
    ! strategy:
    !  1. check for existing allocation: deallocate if needed
    !  2. allocate by rank and data type
    !  3. populate array: force memory errors to happen in this module

    use mFormatDescriptors,    only : fmt_allocerror, fmt_allocstat, fmt_allocmsg, fmt_allocsize, fmt_one
    use mParametersSimulation, only : zero
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

contains

    subroutine rank_one_integers_sub ( integer_array, numRows )

        integer ( ip ), allocatable, intent ( out ) :: integer_array ( : )
        integer ( ip ),              intent ( in )  :: numRows
        ! locals
        integer ( ip ) :: numElements

            numElements = numRows

            ! how much memory is requested?
            sizeElementBits = storage_size ( 1_ip )
            requestedGB     = real ( sizeElementBits * numElements, rp ) / oneGB
            write ( myKind, '( "data type is INTEGER (ip)" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( integer_array ) ) then
                deallocate ( integer_array, stat = alloc_status, errmsg = alloc_message )
                if ( alloc_status /= 0 ) then
                    call post_error_message_sub ( 'deallocating', numElements )
                end if
            end if

            ! the compiler may allow allocations which are not possible
            allocate ( integer_array ( 1 : numElements ), stat = alloc_status, errmsg = alloc_message )
            if ( alloc_status /= 0 ) then
                call post_error_message_sub ( 'allocating', numElements )
            end if

            ! verify the memory is truly available
            integer_array ( : ) = 0

    end subroutine rank_one_integers_sub

    subroutine rank_one_reals_sub ( real_array, numRows )

        real ( rp ), allocatable, intent ( out ) :: real_array ( : )
        integer ( ip ),           intent ( in )  :: numRows
        ! locals
        integer ( ip ) :: numElements

            numElements = numRows

            ! how much memory is requested?
            sizeElementBits = storage_size ( 1_rp )
            requestedGB     = real ( sizeElementBits * numElements, rp ) / oneGB
            write ( myKind, '( "data type is REAL (rp)" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( real_array ) ) then
                deallocate ( real_array, stat = alloc_status, errmsg = alloc_message )
                if ( alloc_status /= 0 ) then
                    call post_error_message_sub ( 'deallocating', numElements )
                end if
            end if

            ! the compiler may allow allocations which are not possible
            allocate ( real_array ( 1 : numElements ), stat = alloc_status, errmsg = alloc_message )
            if ( alloc_status /= 0 ) then
                call post_error_message_sub ( 'allocating', numElements )
            end if

            ! verify the memory is truly available
            real_array ( : ) = 0

    end subroutine rank_one_reals_sub

    subroutine rank_two_reals_sub ( real_array, numRows, numColumns )
        ! tourists
        real ( rp ), allocatable, intent ( out ) :: real_array ( : , : )
        integer ( ip ),           intent ( in )  :: numRows, numColumns
        ! locals
        integer ( ip ) :: numElements

            numElements = numRows * numColumns

            ! how much memory is requested?
            sizeElementBits = storage_size ( 1.0_rp )
            requestedGB     = real ( sizeElementBits * numElements, rp ) / oneGB
            write ( myKind, '( "data type is REAL (rp)" )' )

            ! hygiene check: is the array already allocated?
            if ( allocated ( real_array ) ) then
                deallocate ( real_array, stat = alloc_status, errmsg = alloc_message )
                if ( alloc_status /= 0 ) then
                    call post_error_message_sub ( 'deallocating', numElements )
                end if
            end if

            ! the compiler may allow allocations which are not possible
            allocate ( real_array ( 1 : numRows, 1 : numColumns ), stat = alloc_status, errmsg = alloc_message )
            if ( alloc_status /= 0 ) then
                call post_error_message_sub ( 'allocating', numElements )
            end if

            ! verify the memory is truly available
            real_array ( : , : ) = zero

    end subroutine rank_two_reals_sub

    subroutine post_error_message_sub ( action, numElements )
        integer ( ip ),        intent ( in )  :: numElements
        character ( len = * ), intent ( in )  :: action

            write ( *, fmt = fmt_allocerror ) action, numElements
            write ( *, fmt = fmt_allocstat  ) alloc_status
            write ( *, fmt = fmt_allocmsg   ) trim ( alloc_message )
            write ( *, fmt = fmt_one        ) trim ( myKind )
            write ( *, fmt = fmt_allocsize  ) sizeElementBits, requestedGB

            stop "# # #  Failed memory allocation  # # #"

        return
    end subroutine post_error_message_sub

end module mAllocations
