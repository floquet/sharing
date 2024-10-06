! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mFormatDescriptors

    implicit none

    character ( len = * ), parameter :: fmt_one   = '( g0 )'
    character ( len = * ), parameter :: fmt_two   = '( g0, g0 )'
    character ( len = * ), parameter :: fmt_three = '( g0, g0, g0 )'
    character ( len = * ), parameter :: fmt_four  = '( g0, g0, g0, g0 )'
    character ( len = * ), parameter :: fmt_five  = '( g0, g0, g0, g0, g0 )'
    character ( len = * ), parameter :: fmt_six   = '( g0, g0, g0, g0, g0, g0 )'

    character ( len = * ), parameter :: fmt_cmplt = '( /, "completed at", I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )'
    character ( len = * ), parameter :: fmt_cpu_time = '( /, "CPU time used = ", g0, "seconds." )'

end module mFormatDescriptors
