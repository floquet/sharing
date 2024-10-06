! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program subsection

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    use mFileHandling,                  only : safeopen_readwrite, safeopen_readonly

    implicit none
    integer :: elev = 0, nu = 0, ssec = 0, d = 50, mrkr = 0
    integer :: a = 0, c = 0, e = 0, left = 0, right = 0
    character ( len = 128 ) :: fname = "", line = "", numbers = "", graphicsFile = ""
    ! truncation criteria: identifies order of fit d for each elevation and frequency
    character ( len = * ), parameter :: locker = "./markers-naked/"
    ! LaTeX will query this folder for the equations
    ! move the folder and use a global address
    character ( len = * ), parameter :: eqns = "/Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/" &
                            // "writers/subsection/amplitudes/"
    character ( len = * ), parameter :: graphicsStem = "\includegraphics[ scale = 0.45 ]{./graphics/"
    ! containers for date and time
    integer :: dt_values ( 1 : 8 ) = 0

        elevation: do elev = 90, 45, -5
            write ( unit = fname, fmt = '( 2g0, I3.3, g0 )' ) locker, "markers-log-0p", elev, ".txt"
            mrkr = safeopen_readonly ( fname )
            write ( graphicsFile, fmt = '( 2g0, I3.3, g0 ) ' ) graphicsStem, "0p", elev, "-nu="
            frequency: do nu = 3, 30
                ! harvest markers
                read ( mrkr, fmt = '( A )' ) line
                left  = index ( line, "{")
                right = index ( line, "}")
                write ( numbers, fmt = "( g0 )" ) line ( left + 1 : right - 1)
                read ( numbers, * ) a, d, c, e

                ! open subsection file
                write ( unit = fname, fmt = '( g0, I3.3, g0, I2.2, g0 )' ) "./latex/ssec-elev=", elev, "-nu=", nu,".tex"
                ssec = safeopen_readwrite ( fname )
                write ( ssec, fmt = '( g0 )' ) &
                            "% /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/writers/section/subsection.f08"
                write ( ssec, * )
                call date_and_time ( VALUES = dt_values )
                write ( ssec, fmt = '( g0, I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ) )' ) "%", dt_values ( 1 : 3 ), &
                            dt_values ( 5 : 7 )
                write ( ssec, * )
                write ( ssec, fmt = '( 5g0 )' ) '% \input{./sections/ssec elev=', elev,'-nu=', nu,'}'
                write ( ssec, * )
                write ( ssec, fmt = '( g0 )' ) "% keep the images on common page"
                write ( ssec, fmt = '( g0 )' ) "\clearpage{}"
                write ( ssec, fmt = '( g0 )' ) "\break{}"
                write ( ssec, * )
                write ( ssec, fmt = '( 5g0 )' ) "\subsection{$\nu = ", nu, "$ MHz, degree of fit $d = ", d, "$}"
                write ( ssec, * )
                ! table: indentations mirror LaTeX indentations
                write ( ssec, fmt = '( g0 )' ) "\begin{table}[h]"
                    write ( ssec, fmt = '( 4x, g0 )' ) "\begin{center}"
                        write ( ssec, fmt = '( 8x, g0 )' ) "\begin{tabular}{ccc}"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                            write ( ssec, fmt = '( 12x, g0 )' ) "Data and solution & \quad & Residual errors \\\hline"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                            write ( ssec, fmt = '( 12x, g0, I2.2, g0, I2.2, g0 )' ) &
                                trim ( graphicsFile ), nu, "-d=", d, "-A} &&"
                            write ( ssec, fmt = '( 12x, g0, I2.2, g0, I2.2, g0 )' ) &
                                trim ( graphicsFile ), nu, "-d=", d, "-B} \\[15pt]"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                            write ( ssec, fmt = '( 12x, g0 )' ) "Amplitudes with error bars && Amplitude signal--to--noise \\\hline"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                            write ( ssec, fmt = '( 12x, g0, I2.2, g0, I2.2, g0 )' ) &
                                trim ( graphicsFile ), nu, "-d=", d, "-C} &&"
                            write ( ssec, fmt = '( 12x, g0, I2.2, g0, I2.2, g0 )' ) &
                                trim ( graphicsFile ), nu, "-d=", d, "-D} \\[15pt]"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                            write ( ssec, fmt = '( 12x, g0 )' ) "Error spectrum $2-$norm && Error spectrum $\infty-$norm \\\hline"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                            write ( ssec, fmt = '( 12x, g0, I2.2, g0, I2.2, g0 )' ) &
                                trim ( graphicsFile ), nu, "-d=", d, "-E} &&"
                            write ( ssec, fmt = '( 12x, g0, I2.2, g0, I2.2, g0 )' ) &
                                trim ( graphicsFile ), nu, "-d=", d, "-F} \\[15pt]"
                            write ( ssec, fmt = '( 16x, g0 )' ) "%"
                        write ( ssec, fmt = '( 8x, g0 )' ) "\end{tabular}"
                    write ( ssec, fmt = '( 4x, g0 )' ) "\end{center}"
                write ( ssec, fmt = '( 5g0 )' ) "\label{fig:elev=", elev, ", nu=", nu, "}"
                write ( ssec, fmt = '(  g0 )' ) "\end{table}"
                ! end table
                write ( ssec, * )
                write ( ssec, fmt = '(  g0 )' ) "% grab equation with amplitudes respecting significant digits"
                write ( ssec, fmt = '( 3g0, 3( I2.2, g0 ) )' ) '\input{', eqns, 'elev=', elev,'-nu=', nu,'-d=', d, '-clean.txt}'
                write ( ssec, * )
                write ( ssec, fmt = '(  g0 )' ) "\endinput"
                close ( ssec )
            end do frequency
        end do elevation

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt = '( "completed at", I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ), / )' ) &
                            dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( /, "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "section.f08."'

end program subsection

! root@3438027289fd:subsection $ ./subsection
! completed at 2020-05-17  6:31:56

! compiler version: GCC version 10.1.0.

! compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -auxbase-strip subsection.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h.

! STOP Successful run for "section.f08."

