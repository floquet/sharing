! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mTextFileUtilities

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg, &
    use mLibraryOfConstants,            only : MoMfmt, fileNameLength, messageLength, MoMlineLength
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength, mll = MoMlineLength

    integer :: io_stat = 0, kLines = 0
    character ( len = msgl ) :: io_msg = ""
    character ( len = *    ), parameter :: moduleCrash = "Program crashed in module 'mTextFileUtilities', "

contains

    subroutine iostat_check_sub ( action, fileName, iostat, iomsg, crashChain, optionalMessage )
        integer ( ip ),                     intent ( in ) :: iostat
        character ( len = * ),              intent ( in ) :: action
        character ( len = fnl ),            intent ( in ) :: fileName
        character ( len = msgl ),           intent ( in ) :: iomsg
        character ( len = msgl ),           intent ( in ) :: crashChain
        character ( len = msgl ), optional, intent ( in ) :: optionalMessage
        character ( len = msgl ) :: subroutineCrash

            subroutineCrash = trim ( crashChain ) // " " // trim ( "subroutine 'iostat_check_sub'." )
            if ( io_stat /= 0 ) then
                write ( * , fmt = 100 ) action, trim ( fileName )
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt = fmt_stat  ) iostat
                write ( * , fmt = fmt_iomsg ) trim ( iomsg )
                write ( * , fmt = '( g0 )' )  trim ( subroutineCrash )
                stop
            end if

        return
        100 format ( "I/O failure to ", g0, " in file '", g0, "'" )
    end subroutine iostat_check_sub

    subroutine file_closer_sub ( io_unit, fileName, crashChain, optionalMessage )
        integer ( ip ),                     intent ( in ) :: io_unit
        character ( len = fnl ),            intent ( in ) :: fileName
        character ( len = msgl ),           intent ( in ) :: crashChain
        character ( len = msgl ), optional, intent ( in ) :: optionalMessage
        character ( len = msgl ) :: subroutineCrash

            subroutineCrash = trim ( crashChain ) // " " // trim ( "subroutine 'file_closer_sub'." )
            close ( unit = io_unit, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure to CLOSE for me % io_unit = ", io_unit
                write ( * , fmt = '( 2g0 )' ) "File name = '", trim ( fileName ), "'"
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg )      trim ( io_msg )
                write ( * , fmt = '( g0 )' ) trim ( subroutineCrash )
                stop
            end if

        return
    end subroutine file_closer_sub

    ! parse a string like PTW-elev-0p090.4112.txt
    ! angleValue = 90
    subroutine parse_name_sub ( fileName, angleValue )
        character ( len = * ), intent ( in  ) :: fileName
        integer ( ip ),        intent ( out ) :: angleValue
        character ( len = 9 )    :: string = ""
        character ( len = msgl ) :: charString = "", optionalMessage = ""
        character ( len = msgl ) :: crashChain

            crashChain = moduleCrash // "subroutine 'parse_name_sub',"
            charString = "character variable 'string'"

            ! numeric value, e.g. 090
            write ( string, fmt = '( g0 )', iostat = io_stat,  iomsg = io_msg ) fileName ( 12 : 14 )
            optionalMessage = "Trying to WRITE fileName ( 12 : 14 ) = " // trim ( fileName ( 12 : 14 ) ) // "."
            call iostat_check_sub ( action = "WRITE", fileName = charString, crashChain = crashChain, &
                        iostat = io_stat, iomsg = io_msg, &
                        optionalMessage = optionalMessage )

            read  ( string, fmt = '( I3 )', iostat = io_stat,  iomsg = io_msg ) angleValue
            call iostat_check_sub ( action = "READ", fileName = charString, crashChain = crashChain, &
                        iostat = io_stat, iomsg = io_msg )
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
        integer ( ip )           :: io_unit = 0
        character ( len = msgl ) :: crashChain

            crashChain = moduleCrash // "subroutine 'read_text_lines_sub'"
            io_unit = safeopen_readonly ( trim ( fileName ) )
            ! slurp up data
            sweep_text_lines: do kLines = 1, size ( linesText )
                read ( unit = io_unit, fmt = MoMfmt, iostat = io_stat,  iomsg = io_msg ) linesText ( kLines )
                if ( io_stat /= 0 ) then
                    if ( io_stat == iostat_end ) then
                        write ( * , fmt = '( 3g0 )' ) "Premature end-of-file for ", trim ( fileName ), "."
                        write ( * , fmt = '( 3g0 )' ) "Expected", size ( linesText ), " lines."
                        write ( * , fmt = '( 3g0 )' ) "Reached EOF at ", kLines, " lines."
                        write ( * , fmt = '( 3g0 )' ) "Difference = ", size ( linesText ) - kLines +  1, " lines."
                        write ( * , fmt = '(  g0 )' )  moduleCrash // trim ( "subroutine 'read_text_lines_sub'." )
                        stop
                    end if
                    call iostat_check_sub ( action =  "READ", fileName = fileName, iostat = io_stat, iomsg = io_msg, &
                                            crashChain = crashChain )
                end if
            end do sweep_text_lines
            ! close file
            call file_closer_sub ( io_unit = io_unit, fileName = fileName, crashChain = crashChain )

        return
    end subroutine read_text_lines_sub

    subroutine count_lines_sub ( fullFileName, numLines )
        character ( len = fnl ), intent ( in  ) :: fullFileName
        integer ( ip ),          intent ( out ) :: numLines
        integer ( ip )            :: io_unit = 0
        character ( len = mll )   :: data_line = ""
        character ( len = msgl ) :: crashChain

            crashChain = trim ( moduleCrash ) // "subroutine 'iostat_check_sub'"
            io_unit = safeopen_readonly ( trim ( fullFileName ) )
            numLines = 0
            counting_lines: do
                read ( unit = io_unit, fmt = MoMfmt, iostat = io_stat,  iomsg = io_msg ) data_line
                if ( io_stat /= 0 ) then
                    ! check EOF
                    if ( io_stat == iostat_end ) then
                        exit counting_lines
                    end if
                    call iostat_check_sub ( action = "READ", fileName = fullFileName, iostat = io_stat, iomsg = io_msg, &
                            crashChain = crashChain )
                endif
                numLines = numLines + 1
            end do counting_lines

            call file_closer_sub ( io_unit = io_unit, fileName = fullFileName, crashChain = crashChain )

        return
    end subroutine count_lines_sub

    subroutine mark_frequencies_sub ( lines4112Text, numLines4112Text, tempFrequencyValues, tempLineNumsFrequency, numfrequencies )
        character ( len = mll ), intent ( in  ) :: lines4112Text ( : )
        integer ( ip ),          intent ( in  ) :: numLines4112Text
        real    ( ip ),          intent ( out ) :: tempFrequencyValues   ( 1 : 500 )
        integer ( ip ),          intent ( out ) :: tempLineNumsFrequency ( 1 : 500 )
        integer ( ip ),          intent ( out ) :: numfrequencies

        real    ( rp ) :: f = 0.0_rp
        integer ( ip ) :: locationOfString = 0, kLines = 0
        character ( len = mll )  :: myLine = ""
        character ( len = msgl ) :: charString = "", optionalMessage = ""
        character ( len = msgl ) :: crashChain

            crashChain = moduleCrash // "subroutine 'iostat_check_sub',"
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
                    optionalMessage = "Trying to WRITE myLine ( 13 : 23 ): myLine  = " // trim ( myLine ) // "."
                    call iostat_check_sub ( action = "READ", fileName = charString, crashChain = crashChain, &
                        iostat = io_stat, iomsg = io_msg, &
                        optionalMessage = optionalMessage )
                    tempFrequencyValues ( numfrequencies ) = f
                endif
            end do sweep_lines

        return
    end subroutine mark_frequencies_sub

end module mTextFileUtilities
