! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mHarvestCommandLine

    use mFormatDescriptors,             only : fmt_one, fmt_iomsg, fmt_stat
    use mPrecisionDefinitions,          only : ip

    implicit none
    character ( len = 512 ) :: io_msg = ""
    integer :: io_stat = 0

contains

    subroutine harvest_all_command_line_arguments ( MoMoutputFile, elevationAngle )
        character ( len = 512 ), intent ( out ) :: MoMoutputFile
        integer ( ip ),          intent ( out ) :: elevationAngle

        ! locals
        integer :: LenCommand = 0, gca_status = 0, nCommandLineArguments = 0, myNumber = 0
        character ( len = 128 ) :: thisArgument = "", stream = ""

            ! harvest the launch command
            call get_command ( command = thisArgument )
            nCommandLineArguments = command_argument_count ( )

            myNumber = 1
            call get_command_argument ( number = myNumber, value = thisArgument, length = LenCommand, status = gca_status )
            if ( gca_status /= 0 ) then
                call error_get_command_argument ( gca_status = gca_status, myNumber = myNumber, thisArgument = thisArgument )
                stop "Program crashed in module 'mHarvestCommandLine', subroutine 'harvest_all_command_line_arguments'..."
            endif

            MoMoutputFile = trim ( thisArgument )

            myNumber = 2
            call get_command_argument ( number = myNumber, value = thisArgument, length = LenCommand, status = gca_status )
            if ( gca_status /= 0 ) then
                call error_get_command_argument ( gca_status = gca_status, myNumber = myNumber, thisArgument = thisArgument )
                stop "Program crashed in module 'mHarvestCommandLine', subroutine 'harvest_all_command_line_arguments'..."
            endif
            write ( stream, fmt = '( g0 )', iostat = io_stat,  iomsg = io_msg ) thisArgument
            read ( stream, fmt = '( I10 )', iostat = io_stat,  iomsg = io_msg ) elevationAngle
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Error while trying to read 'elevationAngle' from stream."
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in module 'mHarvestCommandLine', subroutine 'harvest_all_command_line_arguments'..."
            endif

        return
    end subroutine harvest_all_command_line_arguments

    subroutine harvest_single_command_line_argument ( index, theArgument )

        integer,                 intent ( in  ) :: index
        character ( len = 128 ), intent ( out ) :: theArgument
        ! locals
        integer :: nCommandLineArguments = 0, LenCommand = 0, gca_status = 0
        character ( len = 128 ) :: launch_command = ''

            ! harvest the launch command
            call get_command ( command = launch_command )
            nCommandLineArguments = command_argument_count ( )

            call get_command_argument ( number = index, value = theArgument, length = LenCommand, status = gca_status )

        return
    end subroutine harvest_single_command_line_argument

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

    end subroutine error_get_command_argument


end module mHarvestCommandLine
