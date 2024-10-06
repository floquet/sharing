! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! https://stackoverflow.com/questions/8508590/standard-input-and-output-units-in-fortran-90
module mRCSProfile
!   RCStable: table of mean total RCS ( nu, alpha )

    use, intrinsic :: iso_fortran_env,  only : iostat_end, stdout => output_unit
    use mAllocations,                   only : rank_one_integers_sub, rank_one_reals_sub, rank_two_reals_sub
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_two, fmt_iomsg, fmt_stat
    use mMatrixWriter,                  only : print_matrix
    use mParametersSimulation,          only : deg, zero
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ) :: io_stat = 0, output_unit = 6
    character ( len = 512 ) :: io_msg = ""

    type :: meanRCS
        ! rank 2: triangles
        real ( rp ), allocatable :: profile ( : , : )

        ! rank 1
        real ( rp ), allocatable :: nu_mesh  ( : )
        real ( rp ), allocatable :: yaw_mesh ( : )

        ! scalar
        integer ( ip ) :: nu_count = 0, yaw_count = 0
        character ( len =  64 ) :: quarry = ""
        character ( len = 512 ) :: file_name = ""
        character ( len =  22 ) :: about = "mean Total RCS in sq m"

    contains
        procedure, public :: read_data_file => read_data_file_sub
        procedure, public :: read_profile   => read_profile_sub
    end type meanRCS

    private :: read_profile_sub, read_data_file_sub

contains

    subroutine read_profile_sub ( me, file_name, quarry, numRows, numColumns )

        class ( meanRCS ), target :: me
        character ( len = * ), intent ( in ) :: file_name, quarry
        integer ( ip ),        intent ( in ) :: numRows, numColumns
        ! locals
        !integer ( ip ) :: k = 0, nu = 0, nu_index = 0

            me % file_name = trim ( file_name )
            me % quarry    = trim ( quarry )

            me % nu_count  = numRows
            me % yaw_count = numColumns

            ! allocation RCS data array from MoM
            call rank_two_reals_sub ( real_array = me % profile, numRows = me % nu_count, numColumns = me % yaw_count )
            ! read rcs data
            call read_data_file_sub ( me )
            ! sanity print
            call print_matrix ( A = me % profile, myFormat = "F8.2", spaces = 1, moniker = "MoM data", dims = [ 5, 8 ], &
                                my_io_unit = output_unit )
        return
    end subroutine read_profile_sub

    subroutine read_data_file_sub ( me )
        class ( meanRCS ), target :: me
        integer ( ip ) :: u_data = 0, row = 0, column = 0

            u_data = safeopen_readonly ( filename = me % file_name )

            ! read to numRows or EOF
            read_loop : do row = 1, me % nu_count
                read  ( u_data, *, iostat = io_stat ) ( me % profile ( row, column) , column= 1, me % yaw_count )
                if ( io_stat == iostat_end ) then
                    me % nu_count = row
                    exit read_loop
                endif
            end do read_loop

            close ( unit = u_data, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_two   ) "Failure on CLOSE for RCS file ", trim ( me % file_name )
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine 'read_data_file_sub'..."
            end if

        return
    end subroutine read_data_file_sub

end module mRCSProfile
