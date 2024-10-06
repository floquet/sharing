! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program fourier
! compute Fourier-Bessel amplitudes from
! Mercury MoM mean total RCS

    use, intrinsic :: iso_fortran_env,          only : compiler_options, compiler_version
    use               mPrecisionDefinitions,    only : ip
    use               mGetCommandLineArguments, only : get_single_command_line_argument
    use               use mProcessControl,      only : main_process_sub

    implicit none

    real ( rp ) :: start = 0.0_rp, finish = 0.0_rp
    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

        call cpu_time ( start )

            call main_process_sub

        ! execution complete - tag output
        call cpu_time ( finish )
        write ( * , fmt = fmt_cpu_time ) finish - start

        call date_and_time ( VALUES = dt_values )
        write ( * , fmt = fmt_cmplt ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , fmt = fmt_two ) "compiler version: ", compiler_version ( )
        write ( * , fmt = fmt_two ) "compiler options: ", compiler_options ( )

        stop 'Successful run for "fourier.f08"' // '.'

end program fourier

! dantopa@dtopa-latitude-5491:fourier $ pwd
! /home/dantopa/repos/bitbucket/fortran-alpha/projects/fourier

! dantopa@dtopa-latitude-5491:fourier $ date
! Mon 09 Mar 2020 02:18:46 PM MDT

! dantopa@dtopa-latitude-5491:fourier $ make debug
! SRCS = m_format_descriptors.f08 m_precision_definitions.f08 fourier.f08
! OBJS = m_format_descriptors.o m_precision_definitions.o fourier.o
! MODS = m_format_descriptors.f08 m_precision_definitions.f08
! m_OBJS = m_format_descriptors.o m_precision_definitions.o
! PROGRAM = fourier
! PRG_OBJ = fourier.o

! dantopa@dtopa-latitude-5491:fourier $ make
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o fourier.o fourier.f08
! gfortran -g -o fourier m_format_descriptors.o m_precision_definitions.o fourier.o

! dantopa@dtopa-latitude-5491:fourier $ ./fourier
!
! completed at 2020-03-09 14:18:56
!
! compiler version: GCC version 9.2.1 20200304
! compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -auxbase-strip fourier.o -g -Og -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h
! STOP Successful run for "fourier.f08".
