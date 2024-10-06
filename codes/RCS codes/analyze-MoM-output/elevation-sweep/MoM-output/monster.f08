! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program monster
    implicit none
    integer :: myunit = 0, k = 0, fd = 0, lineNumber = 0
    integer, parameter :: numLines = 14843
    character ( len = 161 ) :: line ( 1 : numLines )
    character ( len = * ), parameter :: file = "PTW-elev-0n001.4112.txt", file161 = "PTW-elev-0n001.4112.161.txt"

        OPEN( newunit = myunit, file = file )
        OPEN(NEWUNIT=fd, FILE=file161, ACTION='READWRITE')


        close ( unit = myunit )
        close ( unit = fd )

        OPEN(NEWUNIT=fd, FILE=file, ACTION='READ' )
        do k = 1, numLines
                READ( unit = fd, fmt = '( A161 )' ) line ( k )
        end do

        write ( * , fmt = '( 3g0 )') "line 499 = ", line ( 499 ), "!"
        write ( * , fmt = '( 3g0 )') "line 500 = ", line ( 500 ), "!"

    stop
end program monster
