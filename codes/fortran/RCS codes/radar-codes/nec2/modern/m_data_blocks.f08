! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mDataBlocks

    use mPrecisionDefinitions, only : ip, rp

    implicit none

    ! array sizes
    integer ( ip ), parameter :: nm = 600_ip, n2m = 800_ip, n3m = 1000_ip

    type :: b_data
        ! rank 0: scalars
        real    ( ip ) :: wlam
        integer ( ip ) :: ld, m1, m2, m, mp, n1, n2, n, np, ipsym
        ! rank 1: lists of length nm
        real    ( rp ) :: x    ( 1 : nm ), y  ( 1 : nm ), z   ( 1 : nm )
        real    ( rp ) :: si   ( 1 : nm ), bi ( 1 : nm ), alp ( 1 : nm ), bet ( 1 : nm )
        integer ( rp ) :: icon ( 1 : nm )
        ! rank 1: lists of length n2m
        integer ( ip ) :: icon1 ( 1 : n2m ), icon2 ( 1 : n2m ), itag ( 1 : n2m )
    end type b_data

end module mDataBlocks
