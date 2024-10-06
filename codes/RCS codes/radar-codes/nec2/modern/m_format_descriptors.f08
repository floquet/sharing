! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mFormatDescriptors

    implicit none

    character ( len = * ), parameter :: fmt_one   = '( g0 )'
    character ( len = * ), parameter :: fmt_two   = '( g0, g0 )'
    character ( len = * ), parameter :: fmt_three = '( g0, g0, g0 )'
    character ( len = * ), parameter :: fmt_four  = '( g0, g0, g0, g0 )'
    character ( len = * ), parameter :: fmt_five  = '( g0, g0, g0, g0, g0 )'
    character ( len = * ), parameter :: fmt_six   = '( g0, g0, g0, g0, g0, g0 )'

    character ( len = * ), parameter :: fmt_twos  = '( g0, g0, / )'
    character ( len = * ), parameter :: fmt_onec  = '( g0, " ( ", g0, ", ", g0, " )" )'
    character ( len = * ), parameter :: fmt_dandt = '( /, "completed at", I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )'

    character ( len = * ), parameter :: fmt_alpha = '(4X, "CHECK DATA, PARAMETER SPECIFYING SEGMENT POSITION IN &
                                                           & A GROUP OF EQUAL TAGS MUST NOT BE ZERO" )'
    character ( len = * ), parameter :: fmt_bravo = '( ///, 10X, "NO SEGMENT HAS AN ITAG OF ", g0 )'



end module mFormatDescriptors
