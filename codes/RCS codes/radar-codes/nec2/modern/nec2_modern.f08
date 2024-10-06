! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program nec2_modern

    use               mSubroutines,          only : stringToUpperCase
    use               mFunctions,            only : impedanceWire, phaseAngle, db10

    use, intrinsic :: iso_fortran_env,       only : compiler_options, compiler_version
    use               mFormatDescriptors,    only : fmt_onec, fmt_two, fmt_twos, fmt_dandt
    use               mParameters,           only : i
    use               mPrecisionDefinitions, only : ip, rp

    implicit none

    ! containers for date and time
    complex ( rp ) :: z = i
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip
    character ( len = 9 ) :: stringIn = "My String", stringOut = "123456789"

        call stringToUpperCase ( stringIn, stringOut )
        write ( * , fmt_two ) "stringIn:  ", stringIn
        write ( * , fmt_two ) "stringOut: ", stringOut

        z = impedanceWire ( i, i )
        write ( * , *        ) "impedanceWire ( i, i ) = ", z
        write ( * , fmt_onec ) "impedanceWire ( i, i ) = ", z % re, z % im
        write ( * , *        ) "z = ", z, ": phaseAngle ( z ) ", phaseAngle ( z )

        write ( * , * ) "db ( 10 ) ", db10 ( 10.0_rp )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_dandt ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , fmt_twos ) "compiler version: ", compiler_version ( )
        write ( * , fmt_twos ) "compiler options: ", compiler_options ( )

        stop 'Successful run for "nec2_modern.f08"' // '.'

end program nec2_modern

!     NUMERICAL ELECTROMAGNETICS CODE (NEC2)  DEVELOPED AT LAWRENCE
!     LIVERMORE LAB., LIVERMORE, CA.  (CONTACT G. BURKE AT 415-422-8414
!     FOR PROBLEMS WITH THE NEC CODE.  FOR PROBLEMS WITH THE VAX IMPLEM-
!     ENTATION, CONTACT J. BREAKALL AT 415-422-8196 OR E. DOMNING AT 415
!     422-5936)
!     FILE CREATED 4/11/80.
!     NUMERICAL ELECTROMAGNETICS CODE (NEC2)  DEVELOPED AT LAWRENCE
!     LIVERMORE LAB., LIVERMORE, CA.  (CONTACT G. BURKE AT 415-422-8414
!     FOR PROBLEMS WITH THE NEC CODE.  FOR PROBLEMS WITH THE VAX IMPLEM-
!     ENTATION, CONTACT J. BREAKALL AT 415-422-8196 OR E. DOMNING AT 415
!     422-5936)
!     FILE CREATED 4/11/80.

! dantopa@dtopa-latitude-5491:modern $ pwd
! /home/dantopa/repos/bitbucket/fortran-alpha/projects/nec2/modern

! dantopa@dtopa-latitude-5491:modern $ date
! Tue 11 Feb 2020 11:04:15 AM MST

! dantopa@dtopa-latitude-5491:modern $ make clean; make debug
! rm -rf m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o nec2_modern.o
! rm -f *.o *.mod *.smod *.dSYM # Cray and Mac boogers
! SRCS     = m_format_descriptors.f08 m_subroutines.f08 m_parameters.f08 m_functions.f08 m_precision_definitions.f08 nec2_modern.f08
! OBJS     = m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o nec2_modern.o
! MODS     = m_format_descriptors.f08 m_subroutines.f08 m_parameters.f08 m_functions.f08 m_precision_definitions.f08
! MOD_OBJS = m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o
! PROGRAM  = nec2_modern
! PRG_OBJ  = nec2_modern.o

! dantopa@dtopa-latitude-5491:modern $ make
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_subroutines.o m_subroutines.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_parameters.o m_parameters.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_functions.o m_functions.f08
! gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o nec2_modern.o nec2_modern.f08
! gfortran -g -o nec2_modern m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o nec2_modern.o

! dantopa@dtopa-latitude-5491:modern $ ./nec2_modern
! stringIn:  My String
! stringOut: MY STRING
!  impedanceWire ( i, i ) =               (0.0000000000000000,-7.7459666924148332)
!  z % re =    0.0000000000000000
!  z % im =   -7.7459666924148332
! impedanceWire ( i, i ) =  ( 0.0000000000000000, -7.7459666924148332 )
! impedanceWire ( i, i ) =  ( 0.0000000000000000, -7.7459666924148332 )
!
! completed at 2020-02-11 11:04:29
!
! compiler version: GCC version 9.2.1 20200123
!
! compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -auxbase-strip nec2_modern.o -g -Og -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h
!
! STOP Successful run for "nec2_modern.f08".
