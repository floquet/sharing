! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! Daniel Topa
! ERT Corp.
program esjufjoll
! Esjufjöll volcano
! Stratovolcano 1760 m (5,774 ft)
! Iceland, 64.27°N / -16.65°W
! Current status: normal or dormant (1 out of 5)

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    use mScenarios,                     only : scenario_A
    use mFormatDescriptors,             only : fmt_datecom
    use mPrecisionDefinitions,          only : ip

    implicit none

    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip
    character ( len = * ), parameter :: directory4112   = "../MoM-input/"
    character ( len = * ), parameter :: directoryRCSdat = "../MoM-output/"
    character ( len = * ), parameter :: fileListOfNames = "list-of-files.txt"

        ! specify problem
        call scenario_A ( filePathRCSoutput = directoryRCSdat, filePathListOfNames = directory4112, &
                                                               fileNameListOfNames = fileListOfNames )
        ! output results

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "esjufjoll.f08."'

end program esjufjoll

! dantopa:hot/eriksjokull % pwd                                                                                      (master)fortran-alpha
! /Users/dantopa/primary-repos/bitbucket/fortran-alpha/hot/eriksjokull

! dantopa:hot/eriksjokull % make clean                                                                               (master)fortran-alpha
! rm -rf eriksjokull.o m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o eriksjokull m-allocations-special.mod m-allocations.mod m-class-averages.mod m-class-data-collection.mod m-class-data-file.mod m-class-electric-fields.mod m-class-mesh.mod m-file-handling.mod m-format-descriptors.mod m-library-of-constants.mod m-list-of-mom-files.mod m-precision-definitions.mod m-scenarios.mod m-text-file-utilities.mod
! rm -f *.mod *.smod *.o *.dSYM # Cray and Mac boogers

! dantopa:hot/eriksjokull % make debug                                                                               (master)fortran-alpha
! PROGRAM  = eriksjokull
! PRG_OBJ  = eriksjokull.o
! SRCS     = eriksjokull.f08 m-allocations-special.f08 m-allocations.f08 m-class-averages.f08 m-class-data-collection.f08 m-class-data-file.f08 m-class-electric-fields.f08 m-class-mesh.f08 m-file-handling.f08 m-format-descriptors.f08 m-library-of-constants.f08 m-list-of-mom-files.f08 m-precision-definitions.f08 m-scenarios.f08 m-text-file-utilities.f08
! OBJS     = eriksjokull.o m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o
! MODS     = m-allocations-special.f08 m-allocations.f08 m-class-averages.f08 m-class-data-collection.f08 m-class-data-file.f08 m-class-electric-fields.f08 m-class-mesh.f08 m-file-handling.f08 m-format-descriptors.f08 m-library-of-constants.f08 m-list-of-mom-files.f08 m-precision-definitions.f08 m-scenarios.f08 m-text-file-utilities.f08
! MOD_OBJS = m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o

! dantopa:hot/eriksjokull % make 
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-format-descriptors.o m-format-descriptors.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-precision-definitions.o m-precision-definitions.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-library-of-constants.o m-library-of-constants.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations.o m-allocations.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-averages.o m-class-averages.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations-special.o m-allocations-special.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-electric-fields.o m-class-electric-fields.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-mesh.o m-class-mesh.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-file-handling.o m-file-handling.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-text-file-utilities.o m-text-file-utilities.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-data-file.o m-class-data-file.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-data-collection.o m-class-data-collection.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-list-of-mom-files.o m-list-of-mom-files.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-scenarios.o m-scenarios.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o eriksjokull.o eriksjokull.f08
! gfortran -g -o eriksjokull eriksjokull.o m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o

! dantopa:hot/eriksjokull % ./eriksjokull
! List of 10 input files in ../elevations/list-of-files.txt:
!  1. PTW-elev-0p045.4112.txt.
!  2. PTW-elev-0p050.4112.txt.
!  3. PTW-elev-0p055.4112.txt.
!  4. PTW-elev-0p060.4112.txt.
!  5. PTW-elev-0p065.4112.txt.
!  6. PTW-elev-0p070.4112.txt.
!  7. PTW-elev-0p075.4112.txt.
!  8. PTW-elev-0p080.4112.txt.
!  9. PTW-elev-0p085.4112.txt.
! 10. PTW-elev-0p090.4112.txt.
!
! * Properties of azimuth   mesh:
! * minimum value = -180.000000, maximum value = 179.000000, length = 359.000000
! * number of samples = 360, interval size = 1.00000000
!
! #  #  Dimensions for RCS data containers  #  #
!
! # Expected dimensions:
! # Number of radar frequencies scanned by MoM:   28
! # Number of azimuth   angles scanned by MoM:  360
! # Number of elevation angles scanned manually: 10
!
! # Container for each MoM 4112.txt file: rcs_table_rank_2
! # Free angle dimension = 360 indices run from 1 to 360
! # Frequency dimension  = 28 indices run from 1 to 28
!
! # Container for all MoM 4112.txt files: rcs_table_rank_3
! # Free angle dimension  = 360 indices run from 1 to 360
! # Frequency dimension   = 28 indices run from 1 to 28
! # Fixed angle dimension = 10 indices run from 1 to 10
!
! Analyzing file 001/010: 'PTW-elev-0p045.4112.txt', elevation = 45.
! Analyzing file 002/010: 'PTW-elev-0p050.4112.txt', elevation = 40.
! Analyzing file 003/010: 'PTW-elev-0p055.4112.txt', elevation = 35.
! Analyzing file 004/010: 'PTW-elev-0p060.4112.txt', elevation = 30.
! Analyzing file 005/010: 'PTW-elev-0p065.4112.txt', elevation = 25.
! Analyzing file 006/010: 'PTW-elev-0p070.4112.txt', elevation = 20.
! Analyzing file 007/010: 'PTW-elev-0p075.4112.txt', elevation = 15.
! Analyzing file 008/010: 'PTW-elev-0p080.4112.txt', elevation = 10.
! Analyzing file 009/010: 'PTW-elev-0p085.4112.txt', elevation = 5.
! Analyzing file 010/010: 'PTW-elev-0p090.4112.txt', elevation = 0.
!
!  - - - - - - - - -
!
!  2020-05-28  0:08:55
!
! compiler version: GCC version 9.3.0.
! compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip eriksjokull.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
!
! STOP Successful run for "eriksjokull.f08."
