! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program direct
    implicit none
    integer :: myunit = 0, k = 0, fd = 0, lineNumber = 0
    character ( len = 161 ) :: line
    character ( len = * ), parameter :: file = "PTW-elev-0n001.4112.txt", file161 = "PTW-elev-0n001.4112.161.txt"
        ! https://stackoverflow.com/questions/16586585/starting-reading-from-specific-line-numbers-in-fortran/16604885
        !OPEN( newunit = myunit, file = file, ACCESS='DIRECT', RECL=161, FORM='FORMATTED' )
        OPEN( newunit = myunit, file = file )
        OPEN(NEWUNIT=fd, FILE=file161, ACTION='READWRITE')
        ! lineNumber = 492
        ! READ( unit = myunit, fmt = '( A256 )', REC=lineNumber ) line
        ! write ( * , fmt = '( 5g0 )' ) "line ", lineNumber, " = ", line, "."
        !
        ! lineNumber = 853
        ! READ( unit = myunit, fmt = '( A100 )', REC=lineNumber ) line
        ! write ( * , fmt = '( 5g0 )' ) "line ", lineNumber, " = ", trim ( line ), "."
        ! do k = 1, 14834
        !     READ( unit = myunit, fmt = '( A161 )' ) line
        !     write ( * , fmt = '( 5g0 )' ) "line ", k, " = ", line, " (len = ", len( line ),")."
        !     write ( fd , fmt = '( A161 )' ) line
        ! end do

        close ( unit = myunit )
        close ( unit = fd )

        OPEN(NEWUNIT=fd, FILE=file161, ACTION='READWRITE', ACCESS='DIRECT', RECL=161, FORM='FORMATTED')
        do k = 492, 499
                READ( unit = fd, fmt = '( A161 )', REC=k ) line
            write ( * , fmt = '( 5g0 )' ) "line ", k, " = ", line, "."
        end do
end program direct
