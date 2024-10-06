! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mMatrixReader

    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg
    use mLibraryConstants,              only : messageLength
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none

    ! parameters
    integer   ( kind = ip ),             parameter :: msgl = messageLength
    character ( kind = kindA, len = * ), parameter :: crash = "Program crash in module 'mMatrixReader',"

    integer   ( kind = ip ) :: io_stat = 0
    character ( kind = kindA, len = msgl ) :: io_msg = ""

    ! file format:
    ! header
    ! m n
    ! a_11 a_12 ... a_1n
    !  .    .    .   .
    ! a_m1 a_m2 ... a_mn

contains

    subroutine read_matrix_file ( myFile, A, rows, cols, header )
        real    ( kind = rp ), allocatable,    intent ( out ) :: A ( : , : )
        integer ( kind = ip ),                 intent ( out ) :: rows, cols
        character ( kind = kindA, len = 128 ), intent ( out ) :: header
        character ( kind = kindA, len = * ),   intent ( in  ) :: myFile
        character ( kind = kindA, len = * ), parameter :: myCrash = trim ( crash ) // " subroutine 'read_matrix_file'."
        integer ( kind = ip ) :: m = 0, n = 0, &    ! matrix dimensions
                                row = 0, col = 0, & ! counters
                                io_read = 0         ! io_handle
        ! allocation tools
        type ( allocationToolKit ) :: myKit = allocationToolKit0

            io_read = safeopen_readonly ( myFile )

            ! read header
            read ( io_read, *, iostat = io_stat, iomsg = io_msg ) header
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) 'Can''t read file header (first line) in ', trim ( myFile ), '.'
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop trim ( myCrash )
            end if

            ! read matrix dimensions: m rows, n columns
            read  ( io_read, *, iostat = io_stat, iomsg = io_msg ) m, n
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) 'Can''t read matrix dimensions (second line) in ', trim ( myFile ), '.'
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop trim ( myCrash )
            end if
            rows = m
            cols = n

            ! allocate memory for matrix A
            call myKit % allocate_rank_two_reals ( real_array = A, numRows = m, numColumns = n )

            ! read matrix entries (data file is row major)
            read  ( io_read, *, iostat = io_stat, iomsg = io_msg ) ( ( A ( row, col ), col = 1, n ), row = 1, m )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) 'Can''t read matrix data in ', trim ( myFile ), '.'
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop trim ( myCrash )
            end if

            ! close
            close ( io_read, iostat = io_stat, iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) 'Failure to close matrix data file ', trim ( myFile ), '.'
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop trim ( myCrash )
            end if

        return
    end subroutine read_matrix_file

end module mMatrixReader
