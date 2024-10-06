! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program section

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    use mFileHandling,                  only : safeopen_writereplace

    implicit none
    integer :: j = 0, k = 0, sec = 0
    character ( len = 128 ) :: fname = ""
    ! containers for date and time
    integer :: dt_values ( 1 : 8 ) = 0

        do k = 45, 90, 5
            write ( fname, fmt = '( g0, I2.2, g0 )' ) "./latex/section-elev=", 90-k, ".tex"
            sec = safeopen_writereplace ( fname )
            write ( sec, fmt = '( g0 )' ) "% /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/writers/section/section.f08"
            write ( sec, * )
            call date_and_time ( VALUES = dt_values )
            write ( sec, fmt = '( g0, I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ) )' ) "%", dt_values ( 1 : 3 ), dt_values ( 5 : 7 )
            write ( sec, * )
            write ( sec, fmt = '( g0 )' ) "% keep the images on common page"
            write ( sec, fmt = '( g0 )' ) "\clearpage{}"
            write ( sec, fmt = '( g0 )' ) "\break{}"
            write ( sec, * )
            write ( sec, fmt = '( 3g0 )' ) "\section{Elevation $", k, "^{\circ}$}"
            write ( sec, * )
            write ( sec, fmt = '( g0 )' ) "\begin{figure}[h]"
            write ( sec, fmt = '( 4x, g0 )' ) "\begin{center}"
            write ( sec, fmt = '( 8x, g0, I3.3, g0 )' ) "\includegraphics[ scale = 1 ]{./graphics/panel-plot-0p", k, "}"
            write ( sec, fmt = '( 4x, g0 )' ) "\end{center}"
            write ( sec, fmt = '( 3g0 )' ) "\caption{Mean Total RCS in square meters for an elevation angle of $", 90-k, &
                                            "^{\circ}$.}"
            write ( sec, fmt = '( 3g0 )' ) "\label{fig:elev ", k, "}"
            write ( sec, fmt = '(  g0 )' ) "\end{figure}"
            write ( sec, * )
            write ( sec, fmt = '( g0 )' ) "\begin{figure}[h]"
            write ( sec, fmt = '( 4x, g0 )' ) "\begin{center}"
            write ( sec, fmt = '( 8x, g0, I2.2, g0 )' ) "\includegraphics[ scale = 0.25 ]{./graphics/disk-", 90-k, "}"
            write ( sec, fmt = '( 4x, g0 )' ) "\end{center}"
            write ( sec, fmt = '( 3g0 )' ) "\caption{A representation for the elevation angle of $", 90-k, "^{\circ}$.}"
            write ( sec, fmt = '( 3g0 )' ) "\label{fig:disk elev ", 90-k, "}"
            write ( sec, fmt = '(  g0 )' ) "\end{figure}"
            write ( sec, * )
            do j = 3, 30
                write ( sec, fmt = '( g0, I3.3, g0, I2.2, g0 )' ) '\input{./sections/"ssec-elev=', k, '-nu=', j, '"}'
            end do
            write ( sec, * )
            write ( sec, fmt = '(  g0 )' ) "\endinput"
        end do

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt = '( "completed at", I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )' ) &
                            dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( /, "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "section.f08."'

end program section

! output
! files in ../latex

! execution:

! root@3438027289fd:section $ ./section 
! completed at 2020-05-17  6:34:50

! compiler version: GCC version 10.1.0.

! compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -auxbase-strip section.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h.

! STOP Successful run for "section.f08."

