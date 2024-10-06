module mMatrixWriter

    use mFileHandling,         only : safeopen_writereplace
    use mPrecisionDefinitions, only : ip, rp, kindA

    implicit none

contains

    !   +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +

    subroutine print_matrix ( A, myFormat, spaces, moniker, dims, my_io_unit )

        real ( kind = rp ),                         intent ( in )           :: A ( : , : )
        integer ( kind = ip ),                      intent ( in )           :: spaces, my_io_unit
        integer ( kind = ip ),                      intent ( in ), optional :: dims ( 2 )
        character ( kind = kindA, len = * ), intent ( in ), optional :: moniker
        character ( kind = kindA, len = * ), intent ( in )           :: myFormat

        integer ( kind = ip ) :: myShape ( 2 ) = 0
        integer ( kind = ip ) :: row = 0, col = 0, rows = 0, cols = 0

        character ( kind = kindA, len = 25 ) :: fmt_str = '' ! format descriptor, e.g. E8.3

            ! has user specified a submatrix?
            if ( .not. present ( dims ) ) then
                ! measure size of input matrix
                myShape = shape ( A )
                rows = myShape ( 1 )
                cols = myShape ( 2 )
            else
                rows = dims ( 1 )
                cols = dims ( 2 )
            end if

            if ( present ( moniker ) ) then  ! e.g. 'codomain matrix U'
                write ( my_io_unit , 200 ) moniker, rows, cols
            else
                write ( my_io_unit , 210 ) rows, cols
            end if

            write ( fmt_str, 100 ) cols, myFormat, spaces
            ! write each row of the matrix
            do row = 1, rows
                write ( my_io_unit , fmt = fmt_str )  ( A ( row, col ), col = 1, cols )
            end do

        return

        100   format ( "( ", g0, "( ", g0, ", ", g0,"X ) )" )

        200   format ( /, g0,' has ', g0, ' rows and ', g0, ' columns.' )
        210   format ( /, 'Target matrix has ', g0, ' rows and ', g0, ' columns.' )

    end subroutine print_matrix

    !   +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +

    subroutine open_file_print_matrix ( A, myFormat, spaces, moniker, dims, myFile )

        real ( kind = rp ),                         intent ( in )            :: A ( : , : )

        integer ( kind = ip ),                      intent ( in ), optional  :: dims ( 2 )
        integer ( kind = ip ),                      intent ( in )            :: spaces

        character ( kind = kindA, len = * ), intent ( in ), optional  :: moniker
        character ( kind = kindA, len = * ), intent ( in )            :: myFormat, myFile

        integer ( kind = ip ) :: my_io_unit = 0

            my_io_unit = safeopen_writereplace ( myFile )

            call print_matrix ( A = A, myFormat = myFormat, spaces = spaces, moniker = moniker, dims = dims, &
                                my_io_unit = my_io_unit )

            close ( unit = my_io_unit )

    end subroutine open_file_print_matrix

end module mMatrixWriter
