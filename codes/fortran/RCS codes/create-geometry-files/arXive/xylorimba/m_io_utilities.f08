! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mIOutilities

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_one, fmt_iomsg, fmt_stat
    use mMoMresults,                    only : MoM

    implicit none

    character ( len = 512 ) :: io_msg = ""
    integer :: io_stat = 0

contains

    subroutine read_data_line ( io_handle, data_line )
        integer, intent ( in ) :: io_handle
        character ( len = 256 ), intent ( out ) :: data_line

            read ( unit = io_handle, fmt = '( A256 )', iostat = io_stat,  iomsg = io_msg ) data_line
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Error while reading second line"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in module 'mIOutilities', subroutine 'read_data_line'..."
            endif
            write ( * , fmt = '( 3g0 )' ) "second line = ", trim ( data_line ), "."
        return
    end subroutine read_data_line


    subroutine read_first_line ( io_handle )
        integer, intent ( in ) :: io_handle
        character ( len = 132 ) :: line = ""

            read ( unit = io_handle, fmt = '( A132 )', iostat = io_stat,  iomsg = io_msg ) line
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Error while reading first line"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in module 'mIOutilities', subroutine 'read_first_line'..."
            endif
            write ( * , fmt = '( 3g0 )' ) "first line = ", trim ( line ), "."

        return
    end subroutine read_first_line

    subroutine rewinder_sub ( io_handle  )
        integer, intent ( in ) :: io_handle

        rewind ( unit = io_handle, iostat = io_stat, iomsg = io_msg )
        if ( io_stat /= 0 ) then
            write ( * , fmt_one   ) "Error rewinding data file."
            write ( * , fmt_stat  ) io_stat
            write ( * , fmt_iomsg ) io_msg
            stop "Program crashed in module 'mMoMoutput', subroutine 'rewinder'..."
        endif

        return
    end subroutine rewinder_sub

end module mIOutilities
