! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mGetCommandLineArguments

    use mFormatDescriptors,             only : fmt_one, fmt_iomsg, fmt_stat
    use mLibraryOfConstants,            only : fileNameLength, messageLength
    use mPrecisionDefinitions,          only : ip

    implicit none

    ! parameters
    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength

    integer :: io_stat = 0
    character ( len = msgl ) :: io_msg = ""
    character ( len = * ), parameter :: myModule = "Program crashed in module 'mGetCommandLineArguments', subroutine '"

contains

    subroutine get_single_command_line_argument ( index, theArgument )

        integer,                 intent ( in  ) :: index
        character ( len = fnl ), intent ( out ) :: theArgument
        ! locals
        integer :: nCommandLineArguments = 0, LenCommand = 0, gca_status = 0
        character ( len = fnl ) :: launch_command = ''
        character ( len = * ), parameter :: mySub = "get_single_command_line_argument'"

            ! harvest the launch command
            call get_command ( command = launch_command )
            nCommandLineArguments = command_argument_count ( )

            call get_command_argument ( number = index, value = theArgument, length = LenCommand, status = gca_status )
            if ( gca_status /= 0 ) then
                call error_get_command_argument ( gca_status = gca_status, myNumber = index, thisArgument = theArgument )
                stop myModule // mySub
            endif

        return
    end subroutine get_single_command_line_argument

    subroutine error_get_command_argument ( gca_status, myNumber, thisArgument )
        integer ( ip ),        intent ( in ) :: gca_status, myNumber
        character ( len = * ), intent ( in ) :: thisArgument

            write ( * , fmt = '( 3g0 )' ) "Error in 'get_command_argument' fetching argument ", myNumber, "."
            write ( * , fmt = '( 2g0 )' ) "get_command_argument status = ", gca_status
            if ( gca_status < 0 ) then
                write ( * , fmt = '( 3g0 )' ) "Receiver variable 'thisArgument' in call has a length ", &
                                                    len ( thisArgument )," which is shorter than command argument."
            else
                write ( * , fmt = '(  g0 )' ) "Command line argument cannot be retrieved."
            end if
            write ( * , * )
            write ( * , fmt = '( g0 )' ) "Modern Fortran Explained: Incorporating Fortran 2018, Metcalf, Reid, Cohen"
            write ( * , fmt = '( g0 )' ) "Section 9.12.2, p. 216"
        return
    end subroutine error_get_command_argument

    subroutine check_iostat ( action, whoami )
        character ( len = * ), intent ( in ) :: action, whoami
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Error while trying to ", action
                write ( * , fmt = fmt_stat )  io_stat
                write ( * , fmt = fmt_iomsg ) io_msg
                write ( * , fmt = '( 2g0 )' ) myModule // whoami
                ! recall: stop argument must be constant at compile time
                stop
            endif
    end subroutine check_iostat

end module mGetCommandLineArguments
