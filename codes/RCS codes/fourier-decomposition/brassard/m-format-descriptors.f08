! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mFormatDescriptors

    use mPrecisionDefinitions,          only : kindA

    implicit none

    character ( kind = kindA, len = * ), parameter :: &
                    fmt_one   = '( g0 )', &
                    fmt_two   = '( g0, g0 )', &
                    fmt_three = '( g0, g0, g0 )', &
                    fmt_four  = '( g0, g0, g0, g0 )', &
                    fmt_five  = '( g0, g0, g0, g0, g0 )', &
                    fmt_six   = '( g0, g0, g0, g0, g0, g0 )', &
                    fmt_ten   = '( 9 ( g0, ", "), g0 )', &
                    fmt_tenD  = '( /, "First ten elements of ", g0, ":" )', &
                    fmt_twox  = '( g0, g0, / )'
    ! date and time
    character ( kind = kindA, len = * ), parameter :: &
                    fmt_datecom = '( /, "completed at", I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )'

    ! allocation errors
    character ( kind = kindA, len = * ), parameter :: &
                    fmt_allocstat    = '( "stat = ", g0 )', &
                    fmt_allocmsg     = '( "errmsg  = ", g0, "." )', &
                    fmt_allocerror   = '( "Failure to ", g0, " the array of ", g0, " elements" )', &
                    fmt_allocsize    = '( "bits per element = ", g0, "; total memory request is ", g0, " GB" )'

    ! I/O errors
    character ( kind = kindA, len = * ), parameter :: &
                    fmt_stat  = '( "iostat = ", g0 )', &
                    fmt_iomsg = '( "iomsg  = ", g0 )'

end module mFormatDescriptors
