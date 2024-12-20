! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program revised_reader

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version, stdout => output_unit
    use mFormatDescriptors,             only : fmt_datecom
    !use mIOutilities,                   only : count_lines, rewinder, read_first_line, read_data_line, harvest_fields
    use mMoMoutput,                     only : output
    use mPrecisionDefinitions,          only : ip, rp

    implicit none
    type ( output ) :: MoMoutput
    !character ( len = 512 ) :: line = "", number = ""
    real ( rp ) :: t0, t1
    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0

        call cpu_time ( t0 )

        call MoMoutput % sweep_data_file ( fileNameStem = "PTW" )

        call cpu_time ( t1 )

        ! execution complete - tag output
        write ( * , fmt = '( "CPU time = ", g0, "s" )' ) t1 - t0
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "revised_reader.f08."'

end program revised_reader

! dantopa:readers/cleat % make -k                                                                                     (master)fortran-alpha
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_output.o m_mom_output.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o revised-reader.o revised-reader.f08
! gfortran -g -framework accelerate -o revised-reader m_allocations.o m_file_handling.o m_format_descriptors.o m_io_utilities.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o revised-reader.o
! dantopa:readers/cleat % ./revised-reader                                                                            (master)fortran-alpha
! B-20A.4112.txt has 14843 lines
! B-20A.4112.txt has 28 frequencies.
! 3.00000000
! '...Finished' found at line 854
! 4.00000000
! '...Finished' found at line 1368
! 5.00000000
! '...Finished' found at line 1882
! 6.00000000
! '...Finished' found at line 2396
! 7.00000000
! '...Finished' found at line 2910
! 8.00000000
! '...Finished' found at line 3424
! 9.00000000
! '...Finished' found at line 3938
! 10.0000000
! '...Finished' found at line 4452
! 11.0000000
! '...Finished' found at line 4966
! 12.0000000
! '...Finished' found at line 5480
! 13.0000000
! '...Finished' found at line 5994
! 14.0000000
! '...Finished' found at line 6508
! 15.0000000
! '...Finished' found at line 7022
! 16.0000000
! '...Finished' found at line 7536
! 17.0000000
! '...Finished' found at line 8050
! 18.0000000
! '...Finished' found at line 8564
! 19.0000000
! '...Finished' found at line 9078
! 20.0000000
! '...Finished' found at line 9592
! 21.0000000
! '...Finished' found at line 10106
! 22.0000000
! '...Finished' found at line 10620
! 23.0000000
! '...Finished' found at line 11134
! 24.0000000
! '...Finished' found at line 11648
! 25.0000000
! '...Finished' found at line 12162
! 26.0000000
! '...Finished' found at line 12676
! 27.0000000
! '...Finished' found at line 13190
! 28.0000000
! '...Finished' found at line 13704
! 29.0000000
! '...Finished' found at line 14218
! 30.0000000
! '...Finished' found at line 14732
! 1. nu = 3.00000000, start = 494, stop = 853, terms = 360
! 2. nu = 4.00000000, start = 1008, stop = 1367, terms = 360
! 3. nu = 5.00000000, start = 1522, stop = 1881, terms = 360
! 4. nu = 6.00000000, start = 2036, stop = 2395, terms = 360
! 5. nu = 7.00000000, start = 2550, stop = 2909, terms = 360
! 6. nu = 8.00000000, start = 3064, stop = 3423, terms = 360
! 7. nu = 9.00000000, start = 3578, stop = 3937, terms = 360
! 8. nu = 10.0000000, start = 4092, stop = 4451, terms = 360
! 9. nu = 11.0000000, start = 4606, stop = 4965, terms = 360
! 10. nu = 12.0000000, start = 5120, stop = 5479, terms = 360
! 11. nu = 13.0000000, start = 5634, stop = 5993, terms = 360
! 12. nu = 14.0000000, start = 6148, stop = 6507, terms = 360
! 13. nu = 15.0000000, start = 6662, stop = 7021, terms = 360
! 14. nu = 16.0000000, start = 7176, stop = 7535, terms = 360
! 15. nu = 17.0000000, start = 7690, stop = 8049, terms = 360
! 16. nu = 18.0000000, start = 8204, stop = 8563, terms = 360
! 17. nu = 19.0000000, start = 8718, stop = 9077, terms = 360
! 18. nu = 20.0000000, start = 9232, stop = 9591, terms = 360
! 19. nu = 21.0000000, start = 9746, stop = 10105, terms = 360
! 20. nu = 22.0000000, start = 10260, stop = 10619, terms = 360
! 21. nu = 23.0000000, start = 10774, stop = 11133, terms = 360
! 22. nu = 24.0000000, start = 11288, stop = 11647, terms = 360
! 23. nu = 25.0000000, start = 11802, stop = 12161, terms = 360
! 24. nu = 26.0000000, start = 12316, stop = 12675, terms = 360
! 25. nu = 27.0000000, start = 12830, stop = 13189, terms = 360
! 26. nu = 28.0000000, start = 13344, stop = 13703, terms = 360
! 27. nu = 29.0000000, start = 13858, stop = 14217, terms = 360
! 28. nu = 30.0000000, start = 14372, stop = 14731, terms = 360
!
! completed at 2020-05-09 15:30:20
!
! compiler version: GCC version 9.3.0.
! compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip revised-reader.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
!
! STOP Successful run for "revised_reader.f08."
! dantopa:readers/cleat % date                                                                                        (master)fortran-alpha
! Sat May  9 15:30:40 MDT 2020
! dantopa:readers/cleat % pwd                                                                                         (master)fortran-alpha
! /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/readers/cleat
