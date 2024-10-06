! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mTextFileUtilities

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_one, fmt_stat, fmt_iomsg, &
                                                fmt_allocerror, fmt_allocstat, fmt_allocmsg, fmt_allocsize, fmt_one
    use mLibraryOfConstants,            only : MoMfmt, fileNameLength, messageLength, MoMlineLength
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength, mll = MoMlineLength

    integer :: io_stat = 0, kLines = 0
    character ( len = msgl ) :: io_msg = ""

contains

    ! parse a string like PTW-elev-0p090.4112.txt
    subroutine parse_name_sub ( fileName, angleValue )
        character ( len = * ), intent ( in  ) :: fileName
        integer ( ip ), intent ( out ) :: angleValue
        character ( len = 9 )          :: string = ""

            ! numeric value, e.g. 090
            write ( string, fmt = '( g0 )') fileName ( 12 : 14 )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) "Failure to WRITE fileName ( 12 : 14 ) = ", trim ( fileName ( 12 : 14 ) ) , "."
                write ( * , fmt = fmt_stat  ) io_stat
                write ( * , fmt = fmt_iomsg ) io_msg
                stop "Error occured in module 'mTextFileUtilities', subroutine 'parse_name_sub'."
            end if

            read  ( string, fmt = '( I3 )' ) angleValue
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) "Failure to READ angleValue from string = '", trim ( fileName ) , "'."
                write ( * , fmt = fmt_stat  ) io_stat
                write ( * , fmt = fmt_iomsg ) io_msg
                stop "Error occured in module 'mTextFileUtilities', subroutine 'parse_name_sub'."
            end if

            ! sign ( + or - )
            if ( fileName ( 11 : 11 ) == "n" ) then
                angleValue = - angleValue
            end if
        return
    end subroutine parse_name_sub

    ! read and store each data line in a single MoM *.4112.txt file
    subroutine read_text_lines_sub ( fileName, linesText )
        character ( len = fnl ), intent ( in  ) :: fileName
        character ( len = mll ), intent ( out ) :: linesText ( : )
        integer ( ip ) :: io_unit = 0

            io_unit = safeopen_readonly ( trim ( fileName ) )
            ! slurp up data
            do kLines = 1, size ( linesText )
                read ( unit = io_unit, fmt = MoMfmt ) linesText ( kLines )
                if ( io_stat /= 0 ) then
                    if ( io_stat == iostat_end ) then
                        write ( * , fmt = '( 3g0 )' ) "Premature end-of-file for ", trim ( fileName ), "."
                        write ( * , fmt = '( 3g0 )' ) "Expected", size ( linesText ), " lines."
                        write ( * , fmt = '( 3g0 )' ) "Reached EOF at ", kLines, " lines."
                        write ( * , fmt = '( 3g0 )' ) "Difference = ", size ( linesText ) - kLines +  1, " lines."
                        stop "Error occured in module 'mTextFileUtilities', subroutine 'read_text_lines_sub'."
                    end if
                write ( * , fmt = '( 3g0 )' ) "Failure on READ for file ", trim ( fileName ) , "."
                write ( * , fmt = fmt_stat  ) io_stat
                write ( * , fmt = fmt_iomsg ) io_msg
                stop "Error occured in module 'mTextFileUtilities', subroutine 'read_text_lines_sub'."
                end if
            end do
            ! close file
            close ( unit = io_unit, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on CLOSE for io_unit = ", io_unit
                write ( * , fmt = fmt_stat  ) io_stat
                write ( * , fmt = fmt_iomsg ) io_msg
                stop "Program crashed in module 'mTextFileUtilities', subroutine 'read_text_lines_sub'..."
            end if

        return
    end subroutine read_text_lines_sub

    subroutine count_lines_sub ( fullFileName, numLines )
        character ( len = fnl ), intent ( in  ) :: fullFileName
        integer ( ip ),          intent ( out ) :: numLines
        integer ( ip )          :: io_unit = 0
        character ( len = mll ) :: data_line = ""

            io_unit = safeopen_readonly ( trim ( fullFileName ) )
            numLines = 0
            counting_lines: do
                read ( unit = io_unit, fmt = MoMfmt, iostat = io_stat,  iomsg = io_msg ) data_line
                if ( io_stat /= 0 ) then
                    ! check EOF
                    if ( io_stat == iostat_end ) then
                        exit counting_lines
                    end if
                    write ( * , fmt_one   ) "Error while sweeping data file"
                    write ( * , fmt_stat  ) io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop "Program crashed in module 'mTextFileUtilities', subroutine 'count_lines'..."
                endif
                numLines = numLines + 1
            end do counting_lines

            close ( unit = io_unit, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on CLOSE for io_unit = ", io_unit
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in module 'mTextFileUtilities', subroutine 'count_lines_sub'..."
            end if

        return
    end subroutine count_lines_sub

    subroutine mark_frequencies_sub ( lines4112Text, numLines4112Text, tempFrequencyValues, tempLineNumsFrequency, numfrequencies )
        character ( len = mll ), intent ( in  ) :: lines4112Text ( : )
        integer ( ip ),          intent ( in  ) :: numLines4112Text
        real    ( ip ),          intent ( out ) :: tempFrequencyValues   ( 1 : 500 )
        integer ( ip ),          intent ( out ) :: tempLineNumsFrequency ( 1 : 500 )
        integer ( ip ),          intent ( out ) :: numfrequencies

        real    ( rp ) :: maxFrequency = - huge( 1.0_rp ), minFrequency = huge( 1.0_rp )
        real    ( rp ) :: f = 0.0_rp
        integer ( ip ) :: locationOfString = 0, kLines = 0
        character ( len = mll ) :: myLine = ""

            sweep_lines: do kLines = 1, numLines4112Text
                myLine = lines4112Text ( kLines )
                locationOfString = index ( myLine, "  Freq ", kind = ip )
                if ( locationOfString > 0 ) then
                    ! data line found
                    numfrequencies = numfrequencies + 1
                    ! write ( * , fmt = '( 2g0 )' ) "numfrequencies = ", numfrequencies
                    tempLineNumsFrequency ( numfrequencies ) = kLines
                    ! string -> real
                    read ( myLine ( 13 : 23 ), fmt = *, iostat = io_stat,  iomsg = io_msg ) f
                    if ( io_stat /= 0 ) then
                        write ( * , fmt = '( 3g0 )' ) "Error while trying to read frequency ", kLines, "."
                        write ( * , fmt = '( 5g0 )' ) "READ failure to read 'myline ( 13 : 23 )' (", &
                                                    trim ( myLine ( 13 : 23 ) ), ") with file descriptor '( E10.2 )'."
                        write ( * , fmt_stat )  io_stat
                        write ( * , fmt_iomsg ) io_msg
                        stop "Program crashed in module 'mClassDataFile', subroutine 'mark_frequencies_sub'."
                    endif
                    ! check for extremal values
                    tempFrequencyValues ( numfrequencies ) = f
                    if ( f > maxFrequency ) then
                        maxFrequency = f
                    endif
                    if ( f < minFrequency ) then
                        minFrequency = f
                    endif
                endif
            end do sweep_lines
        return
    end subroutine mark_frequencies_sub

end module mTextFileUtilities
