! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mSubroutines

    use mPrecisionDefinitions, only : ip

    implicit none

contains

    subroutine stringToUpperCase ( stringIn, stringOut )
        ! My String  ==>  MY STRING
        character ( len = * ), intent ( in  ) :: stringIn
        character ( len = * ), intent ( out ) :: stringOut

        integer ( ip ) :: k, ic, is_pc

        ! force strings to be same length and have same tail of blanks
        stringOut = stringIn

        ! how the hell does this variable change?
        is_pc = 1

        if ( is_pc /= 0 ) then
            ! convert lowercase to upper case
            do k = 1, len_trim ( stringIn )
                ic = ichar ( stringIn ( k : k ) )
                if ( ic >= 97 .and. ic <= 122 ) then
                    ! convert lower case character to upper case
                    ic = ic - 32
                endif
                stringOut ( k : k ) = char ( ic )
            end do
        endif ! is_pc /= 0

    end subroutine stringToUpperCase

end module mSubroutines

! nec2-1.2.1.2.f  lines   9,086 - 9,104

!    ASCII    ASCII
! a    97   A   65
! b    98   B   66
! c    99   C   67
! d   100   D   68
! e   101   E   69
! f   102   F   70
! g   103   G   71
! h   104   H   72
! i   105   I   73
! j   106   J   74
! k   107   K   75
! l   108   L   76
! m   109   M   77
! n   110   N   78
! o   111   O   79
! p   112   P   80
! q   113   Q   81
! r   114   R   82
! s   115   S   83
! t   116   T   84
! u   117   U   85
! v   118   V   86
! w   119   W   87
! x   120   X   88
! y   121   Y   89
! z   122   Z   90


! dantopa@dtopa-latitude-5491:modern $ date
! Mon 10 Feb 2020 04:34:48 PM MST

! dantopa@dtopa-latitude-5491:modern $ pwd
! /home/dantopa/repos/bitbucket/fortran-alpha/projects/nec2/modern

! dantopa@dtopa-latitude-5491:modern $ gfortran -c -g mod_routines.f08  $gflags
