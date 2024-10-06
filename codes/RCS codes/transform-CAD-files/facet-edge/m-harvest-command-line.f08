! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mHarvestCommandLine

    use mPrecisionDefinitions,          only : ip, kindA

    implicit none

    character ( len = 512 ) :: io_msg = ""
    integer :: io_stat = 0
    character ( kind = kindA, len = * ), parameter :: myModule = "Program crashed in module 'mHarvestCommandLine', "

contains

    subroutine harvest_single_command_line_argument_sub ( index, theArgument )

        integer,                 intent ( in  ) :: index
        character ( len = 128 ), intent ( out ) :: theArgument
        ! locals
        integer :: nCommandLineArguments = 0, LenCommand = 0, gca_status = 0
        character ( len = 128 ) :: launch_command = ""
        character ( kind = kindA, len = * ), parameter :: mySub = "subroutine 'harvest_single_command_line_argument'."

            ! harvest the launch command
            call get_command ( command = launch_command )
            nCommandLineArguments = command_argument_count ( )

            call get_command_argument ( number = index, value = theArgument, length = LenCommand, status = gca_status )
            if ( gca_status /= 0 ) then
                call error_get_command_argument_sub ( gca_status = gca_status, myNumber = index, thisArgument = theArgument, &
                                                       launch_command = launch_command )
                stop myModule // mySub
            endif

        return
    end subroutine harvest_single_command_line_argument_sub

    subroutine error_get_command_argument_sub ( gca_status, myNumber, thisArgument, launch_command )
        integer ( kind = ip ),        intent ( in ) :: gca_status, myNumber
        character ( kind = kindA, len = * ), intent ( in ) :: thisArgument, launch_command

            write ( * , fmt = '( 3g0 )' ) "Error occured while fetching command line argument ", myNumber, "."
            write ( * , fmt = '( 3g0 )' ) "Launch command line = ", trim ( launch_command ), "."
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
    end subroutine error_get_command_argument_sub

end module mHarvestCommandLine
