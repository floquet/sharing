! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mFormatDescriptors

    implicit none

    character ( len = * ), parameter :: fmt_one   = '(  g0 )'
    character ( len = * ), parameter :: fmt_two   = '( 2g0 )'
    character ( len = * ), parameter :: fmt_three = '( 3g0 )'
    character ( len = * ), parameter :: fmt_four  = '( 4g0 )'
    character ( len = * ), parameter :: fmt_five  = '( 5g0 )'
    character ( len = * ), parameter :: fmt_six   = '( 6g0 )'
    character ( len = * ), parameter :: fmt_ten   = '( 9 ( g0, ", "), g0 )'
    character ( len = * ), parameter :: fmt_tenD  = '( /, "First ten elements of ", g0, ":" )'

    character ( len = * ), parameter :: fmt_twox  = '( g0, g0, / )'

    character ( len = * ), parameter :: fmt_shape1 = '( "shape ( ", g0, " ) = ", g0 )'
    character ( len = * ), parameter :: fmt_shape2 = '( "shape ( ", g0, " ) = ", g0, ", ", g0 )'
    character ( len = * ), parameter :: fmt_shape3 = '( "shape ( ", g0, " ) = ", g0, ", ", g0, ", ", g0 )'

    !character ( len = * ), parameter :: spacer = " - - - - - - - - -"
    ! date and time
    character ( len = * ), parameter :: fmt_datecom = '( /, " - - - - - - - - -", //, I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )'

    ! allocation errors
    character ( len = * ), parameter :: fmt_allocerror   = '( "Failure ", g0, " the array of ", g0, " elements" )'
    character ( len = * ), parameter :: fmt_allocstat    = '( "stat = ", g0 )'
    character ( len = * ), parameter :: fmt_allocmsg     = '( "errmsg  = ", g0, "." )'
    character ( len = * ), parameter :: fmt_allocsize    = '( "bits per element = ", g0, "; total memory request is ", g0, " GB" )'

    ! I/O errors
    character ( len = * ), parameter :: fmt_stat  = '( "iostat = ", g0 )'
    character ( len = * ), parameter :: fmt_iomsg = '( "iomsg  = ", g0 )'

end module mFormatDescriptors