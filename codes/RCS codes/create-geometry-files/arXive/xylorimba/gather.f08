! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program gather

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version

    use mArrayBounds,                   only : nu_lo, nu_hi, azimuth_lo, azimuth_hi, elevation_lo, elevation_hi
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_datecom, fmt_iomsg, fmt_stat
    use mHarvestCommandLine,            only : harvest_all_command_line_arguments
    use mMoMoutput,                     only : output
    use mPrecisionDefinitions,          only : ip
    use mRCSdataTable,                  only : RCSdataTable

    implicit none

    type ( output ) :: MoMoutput
    type ( RCSdataTable ) :: rcs

    !real ( sp ) :: cheat ( 1 : 360 )

    integer ( ip ) :: io_PTWlist = 0, j = 0, k = 0, nu = 0
    integer ( ip ) :: io_stat = 0
    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0
    character ( len = 512 ) :: io_msg = ""
    character ( len = 512 ) :: PTWlistFile = "", tlaloc = "/Volumes/Tlaloc/Mercury-MoM/ubuntu/outputs/", fname = ""

    type :: ids
        character ( len = 512 ) :: MoMoutputFiles  ( azimuth_lo : azimuth_hi )
        integer ( ip ) ::          elevationAngles ( azimuth_lo : azimuth_hi )
    end type

    type ( ids ) :: myList

        PTWlistFile = "/Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/readers/3d/data/PTW-list.txt"
        io_PTWlist = safeopen_readonly ( trim ( PTWlistFile ) )

        readListPTWfiles: do k = azimuth_lo, azimuth_hi
            read ( io_PTWlist, * ) myList % MoMoutputFiles ( k ), myList % elevationAngles ( k )
            !read ( unit = io_PTWlist, fmt = '( A, I10 )', iostat = io_stat,  iomsg = io_msg ) myList % MoMoutputFiles ( k ), &
            !                                                                                  myList % elevationAngles ( k )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 5g0 )' ) "Error while reading line ", k, " in ", PTWlistFile, "."
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Fix list reader..."
            endif
            !write ( * , fmt = '( 6g0 )' ) k, ". file = ", trim ( myList % MoMoutputFiles ( k ) ), &
            !                                 ", elevation angle = ", myList % elevationAngles ( k ), "."
        end do readListPTWfiles

        call rcs % check_table_size ( )

        sweep_elevation_angles: do k = azimuth_lo, azimuth_lo + 1
            fname = trim ( tlaloc ) // trim ( myList % MoMoutputFiles ( k ) )
            call MoMoutput % sweep_data_file ( fullFileName = trim ( fname ) )
            !write ( * , fmt = '( 2g0 )' ) "MoMoutput % eFieldTable ( 1, 1 ) % theta_theta = ", &
            !                           MoMoutput % eFieldTable ( 1, 1 ) % theta_theta
            !write ( * , fmt = '( 2g0 )' ) "MoMoutput % eFieldTable ( 1, 1 ) % mean_total_rcs = ", &
            !                           MoMoutput % eFieldTable ( 1, 1 ) % mean_total_rcs
            write ( * , fmt = '( 2g0 )' ) "Elevation angle = ", myList % elevationAngles ( k )
            sweep_frequencies: do nu = nu_lo, nu_hi
                write ( * , fmt = '( 2g0 )' ) "nu = ", nu
                call rcs % load_table_elevation_fixed ( nu = nu, elevationAngle = myList % elevationAngles ( k ), &
                    meanTotalRCS = [ ( MoMoutput % eFieldTable ( j, nu ) % mean_total_rcs, j = azimuth_lo, azimuth_hi ) ] )
                end do sweep_frequencies
            end do sweep_elevation_angles
        !call rcs % load_table_elevation_fixed ( nu = 3, elevationAngle = elevationAngle, meanTotalRCS = meanTotalRCS ( : ) )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt = fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , fmt = '( "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , fmt = '( "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "gather.f08."'

end program gather

!     subroutine load_table_elevation_fixed_sub ( me, nu, elevationAngle, meanTotalRCS )

! dantopa:3d/xylorimba % mmm                                                                                                                                  (master)fortran-alpha
! make clean; make -k; make -k
! rm -rf gather.o m_allocations.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_io_utilities.o m_mom_e_fields.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o m_rcs_data_table.o gather m_allocations.mod m_file_handling.mod m_format_descriptors.mod m_harvest_command_line.mod m_io_utilities.mod m_mom_e_fields.mod m_mom_output.mod m_mom_results.mod m_parameters_simulation.mod m_precision_definitions.mod m_rcs_data_table.mod
! rm -f *.mod *.smod *.o
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_parameters_simulation.o m_parameters_simulation.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_e_fields.o m_mom_e_fields.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_allocations.o m_allocations.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_file_handling.o m_file_handling.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_harvest_command_line.o m_harvest_command_line.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_io_utilities.o m_io_utilities.f08
! m_io_utilities.f08:7:8:
!
!     7 |     use mMoMresults,                    only : MoM
!       |        1
! Fatal Error: Cannot open module file 'mmomresults.mod' for reading at (1): No such file or directory
! compilation terminated.
! make: *** [m_io_utilities.o] Error 1
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_results.o m_mom_results.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_rcs_data_table.o m_rcs_data_table.f08
! m_rcs_data_table.f08:47:31:
!
!    47 |                 me % loc_max = [ nu, maxloc ( meanTotalRCS ( : ) ), elevationAngle ]
!       |                               1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! m_rcs_data_table.f08:47:36:
!
!    47 |                 me % loc_max = [ nu, maxloc ( meanTotalRCS ( : ) ), elevationAngle ]
!       |                                    1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! m_rcs_data_table.f08:52:31:
!
!    52 |                 me % loc_min = [ nu, minloc ( meanTotalRCS ( : ) ), elevationAngle ]
!       |                               1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! m_rcs_data_table.f08:52:36:
!
!    52 |                 me % loc_min = [ nu, minloc ( meanTotalRCS ( : ) ), elevationAngle ]
!       |                                    1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! make: Target `default' not remade because of errors.
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_io_utilities.o m_io_utilities.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_output.o m_mom_output.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o gather.o gather.f08
! gather.f08:19:36:
!
!    19 |     integer ( ip ) :: elevationAngle = 0, io_PTWlist = 0, k = 0
!       |                                    1
! Warning: Unused variable 'elevationangle' declared at (1) [-Wunused-variable]
! gather.f08:17:43:
!
!    17 |     real ( sp ) :: meanTotalRCS ( 1 : 360 )
!       |                                           1
! Warning: Unused variable 'meantotalrcs' declared at (1) [-Wunused-variable]
! gather.f08:14:32:
!
!    14 |     type ( output ) :: MoMoutput
!       |                                1
! Warning: Unused variable 'momoutput' declared at (1) [-Wunused-variable]
! gather.f08:15:32:
!
!    15 |     type ( RCSdataTable ) :: rcs
!       |                                1
! Warning: Unused variable 'rcs' declared at (1) [-Wunused-variable]
! gfortran -g -framework accelerate -o gather gather.o m_allocations.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_io_utilities.o m_mom_e_fields.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o m_rcs_data_table.o
! dantopa:3d/xylorimba % ./gather                                                                                                                             (master)fortran-alpha
! 1. file = PTW-elev-0n179.4112.txt, -179, elevation angle = 0.
! 2. file = PTW-elev-0n178.4112.txt, -178, elevation angle = 0.
! 3. file = PTW-elev-0n177.4112.txt, -177, elevation angle = 0.
! 4. file = PTW-elev-0n176.4112.txt, -176, elevation angle = 0.
! 5. file = PTW-elev-0n175.4112.txt, -175, elevation angle = 0.
! 6. file = PTW-elev-0n174.4112.txt, -174, elevation angle = 0.
! 7. file = PTW-elev-0n173.4112.txt, -173, elevation angle = 0.
! 8. file = PTW-elev-0n172.4112.txt, -172, elevation angle = 0.
! 9. file = PTW-elev-0n171.4112.txt, -171, elevation angle = 0.
! 10. file = PTW-elev-0n170.4112.txt, -170, elevation angle = 0.
! 11. file = PTW-elev-0n169.4112.txt, -169, elevation angle = 0.
! 12. file = PTW-elev-0n168.4112.txt, -168, elevation angle = 0.
! 13. file = PTW-elev-0n167.4112.txt, -167, elevation angle = 0.
! 14. file = PTW-elev-0n166.4112.txt, -166, elevation angle = 0.
! 15. file = PTW-elev-0n165.4112.txt, -165, elevation angle = 0.
! 16. file = PTW-elev-0n164.4112.txt, -164, elevation angle = 0.
! 17. file = PTW-elev-0n163.4112.txt, -163, elevation angle = 0.
! 18. file = PTW-elev-0n162.4112.txt, -162, elevation angle = 0.
! 19. file = PTW-elev-0n161.4112.txt, -161, elevation angle = 0.
! 20. file = PTW-elev-0n160.4112.txt, -160, elevation angle = 0.
! 21. file = PTW-elev-0n159.4112.txt, -159, elevation angle = 0.
! 22. file = PTW-elev-0n158.4112.txt, -158, elevation angle = 0.
! 23. file = PTW-elev-0n157.4112.txt, -157, elevation angle = 0.
! 24. file = PTW-elev-0n156.4112.txt, -156, elevation angle = 0.
! 25. file = PTW-elev-0n155.4112.txt, -155, elevation angle = 0.
! 26. file = PTW-elev-0n154.4112.txt, -154, elevation angle = 0.
! 27. file = PTW-elev-0n153.4112.txt, -153, elevation angle = 0.
! 28. file = PTW-elev-0n152.4112.txt, -152, elevation angle = 0.
! 29. file = PTW-elev-0n151.4112.txt, -151, elevation angle = 0.
! 30. file = PTW-elev-0n150.4112.txt, -150, elevation angle = 0.
! 31. file = PTW-elev-0n149.4112.txt, -149, elevation angle = 0.
! 32. file = PTW-elev-0n148.4112.txt, -148, elevation angle = 0.
! 33. file = PTW-elev-0n147.4112.txt, -147, elevation angle = 0.
! 34. file = PTW-elev-0n146.4112.txt, -146, elevation angle = 0.
! 35. file = PTW-elev-0n145.4112.txt, -145, elevation angle = 0.
! 36. file = PTW-elev-0n144.4112.txt, -144, elevation angle = 0.
! 37. file = PTW-elev-0n143.4112.txt, -143, elevation angle = 0.
! 38. file = PTW-elev-0n142.4112.txt, -142, elevation angle = 0.
! 39. file = PTW-elev-0n141.4112.txt, -141, elevation angle = 0.
! 40. file = PTW-elev-0n140.4112.txt, -140, elevation angle = 0.
! 41. file = PTW-elev-0n139.4112.txt, -139, elevation angle = 0.
! 42. file = PTW-elev-0n138.4112.txt, -138, elevation angle = 0.
! 43. file = PTW-elev-0n137.4112.txt, -137, elevation angle = 0.
! 44. file = PTW-elev-0n136.4112.txt, -136, elevation angle = 0.
! 45. file = PTW-elev-0n135.4112.txt, -135, elevation angle = 0.
! 46. file = PTW-elev-0n134.4112.txt, -134, elevation angle = 0.
! 47. file = PTW-elev-0n133.4112.txt, -133, elevation angle = 0.
! 48. file = PTW-elev-0n132.4112.txt, -132, elevation angle = 0.
! 49. file = PTW-elev-0n131.4112.txt, -131, elevation angle = 0.
! 50. file = PTW-elev-0n130.4112.txt, -130, elevation angle = 0.
! 51. file = PTW-elev-0n129.4112.txt, -129, elevation angle = 0.
! 52. file = PTW-elev-0n128.4112.txt, -128, elevation angle = 0.
! 53. file = PTW-elev-0n127.4112.txt, -127, elevation angle = 0.
! 54. file = PTW-elev-0n126.4112.txt, -126, elevation angle = 0.
! 55. file = PTW-elev-0n125.4112.txt, -125, elevation angle = 0.
! 56. file = PTW-elev-0n124.4112.txt, -124, elevation angle = 0.
! 57. file = PTW-elev-0n123.4112.txt, -123, elevation angle = 0.
! 58. file = PTW-elev-0n122.4112.txt, -122, elevation angle = 0.
! 59. file = PTW-elev-0n121.4112.txt, -121, elevation angle = 0.
! 60. file = PTW-elev-0n120.4112.txt, -120, elevation angle = 0.
! 61. file = PTW-elev-0n119.4112.txt, -119, elevation angle = 0.
! 62. file = PTW-elev-0n118.4112.txt, -118, elevation angle = 0.
! 63. file = PTW-elev-0n117.4112.txt, -117, elevation angle = 0.
! 64. file = PTW-elev-0n116.4112.txt, -116, elevation angle = 0.
! 65. file = PTW-elev-0n115.4112.txt, -115, elevation angle = 0.
! 66. file = PTW-elev-0n114.4112.txt, -114, elevation angle = 0.
! 67. file = PTW-elev-0n113.4112.txt, -113, elevation angle = 0.
! 68. file = PTW-elev-0n112.4112.txt, -112, elevation angle = 0.
! 69. file = PTW-elev-0n111.4112.txt, -111, elevation angle = 0.
! 70. file = PTW-elev-0n110.4112.txt, -110, elevation angle = 0.
! 71. file = PTW-elev-0n109.4112.txt, -109, elevation angle = 0.
! 72. file = PTW-elev-0n108.4112.txt, -108, elevation angle = 0.
! 73. file = PTW-elev-0n107.4112.txt, -107, elevation angle = 0.
! 74. file = PTW-elev-0n106.4112.txt, -106, elevation angle = 0.
! 75. file = PTW-elev-0n105.4112.txt, -105, elevation angle = 0.
! 76. file = PTW-elev-0n104.4112.txt, -104, elevation angle = 0.
! 77. file = PTW-elev-0n103.4112.txt, -103, elevation angle = 0.
! 78. file = PTW-elev-0n102.4112.txt, -102, elevation angle = 0.
! 79. file = PTW-elev-0n101.4112.txt, -101, elevation angle = 0.
! 80. file = PTW-elev-0n100.4112.txt, -100, elevation angle = 0.
! 81. file = PTW-elev-0n099.4112.txt, -99, elevation angle = 0.
! 82. file = PTW-elev-0n098.4112.txt, -98, elevation angle = 0.
! 83. file = PTW-elev-0n097.4112.txt, -97, elevation angle = 0.
! 84. file = PTW-elev-0n096.4112.txt, -96, elevation angle = 0.
! 85. file = PTW-elev-0n095.4112.txt, -95, elevation angle = 0.
! 86. file = PTW-elev-0n094.4112.txt, -94, elevation angle = 0.
! 87. file = PTW-elev-0n093.4112.txt, -93, elevation angle = 0.
! 88. file = PTW-elev-0n092.4112.txt, -92, elevation angle = 0.
! 89. file = PTW-elev-0n091.4112.txt, -91, elevation angle = 0.
! 90. file = PTW-elev-0n090.4112.txt, -90, elevation angle = 0.
! 91. file = PTW-elev-0n089.4112.txt, -89, elevation angle = 0.
! 92. file = PTW-elev-0n088.4112.txt, -88, elevation angle = 0.
! 93. file = PTW-elev-0n087.4112.txt, -87, elevation angle = 0.
! 94. file = PTW-elev-0n086.4112.txt, -86, elevation angle = 0.
! 95. file = PTW-elev-0n085.4112.txt, -85, elevation angle = 0.
! 96. file = PTW-elev-0n084.4112.txt, -84, elevation angle = 0.
! 97. file = PTW-elev-0n083.4112.txt, -83, elevation angle = 0.
! 98. file = PTW-elev-0n082.4112.txt, -82, elevation angle = 0.
! 99. file = PTW-elev-0n081.4112.txt, -81, elevation angle = 0.
! 100. file = PTW-elev-0n080.4112.txt, -80, elevation angle = 0.
! 101. file = PTW-elev-0n079.4112.txt, -79, elevation angle = 0.
! 102. file = PTW-elev-0n078.4112.txt, -78, elevation angle = 0.
! 103. file = PTW-elev-0n077.4112.txt, -77, elevation angle = 0.
! 104. file = PTW-elev-0n076.4112.txt, -76, elevation angle = 0.
! 105. file = PTW-elev-0n075.4112.txt, -75, elevation angle = 0.
! 106. file = PTW-elev-0n074.4112.txt, -74, elevation angle = 0.
! 107. file = PTW-elev-0n073.4112.txt, -73, elevation angle = 0.
! 108. file = PTW-elev-0n072.4112.txt, -72, elevation angle = 0.
! 109. file = PTW-elev-0n071.4112.txt, -71, elevation angle = 0.
! 110. file = PTW-elev-0n070.4112.txt, -70, elevation angle = 0.
! 111. file = PTW-elev-0n069.4112.txt, -69, elevation angle = 0.
! 112. file = PTW-elev-0n068.4112.txt, -68, elevation angle = 0.
! 113. file = PTW-elev-0n067.4112.txt, -67, elevation angle = 0.
! 114. file = PTW-elev-0n066.4112.txt, -66, elevation angle = 0.
! 115. file = PTW-elev-0n065.4112.txt, -65, elevation angle = 0.
! 116. file = PTW-elev-0n064.4112.txt, -64, elevation angle = 0.
! 117. file = PTW-elev-0n063.4112.txt, -63, elevation angle = 0.
! 118. file = PTW-elev-0n062.4112.txt, -62, elevation angle = 0.
! 119. file = PTW-elev-0n061.4112.txt, -61, elevation angle = 0.
! 120. file = PTW-elev-0n060.4112.txt, -60, elevation angle = 0.
! 121. file = PTW-elev-0n059.4112.txt, -59, elevation angle = 0.
! 122. file = PTW-elev-0n058.4112.txt, -58, elevation angle = 0.
! 123. file = PTW-elev-0n057.4112.txt, -57, elevation angle = 0.
! 124. file = PTW-elev-0n056.4112.txt, -56, elevation angle = 0.
! 125. file = PTW-elev-0n055.4112.txt, -55, elevation angle = 0.
! 126. file = PTW-elev-0n054.4112.txt, -54, elevation angle = 0.
! 127. file = PTW-elev-0n053.4112.txt, -53, elevation angle = 0.
! 128. file = PTW-elev-0n052.4112.txt, -52, elevation angle = 0.
! 129. file = PTW-elev-0n051.4112.txt, -51, elevation angle = 0.
! 130. file = PTW-elev-0n050.4112.txt, -50, elevation angle = 0.
! 131. file = PTW-elev-0n049.4112.txt, -49, elevation angle = 0.
! 132. file = PTW-elev-0n048.4112.txt, -48, elevation angle = 0.
! 133. file = PTW-elev-0n047.4112.txt, -47, elevation angle = 0.
! 134. file = PTW-elev-0n046.4112.txt, -46, elevation angle = 0.
! 135. file = PTW-elev-0n045.4112.txt, -45, elevation angle = 0.
! 136. file = PTW-elev-0n044.4112.txt, -44, elevation angle = 0.
! 137. file = PTW-elev-0n043.4112.txt, -43, elevation angle = 0.
! 138. file = PTW-elev-0n042.4112.txt, -42, elevation angle = 0.
! 139. file = PTW-elev-0n041.4112.txt, -41, elevation angle = 0.
! 140. file = PTW-elev-0n040.4112.txt, -40, elevation angle = 0.
! 141. file = PTW-elev-0n039.4112.txt, -39, elevation angle = 0.
! 142. file = PTW-elev-0n038.4112.txt, -38, elevation angle = 0.
! 143. file = PTW-elev-0n037.4112.txt, -37, elevation angle = 0.
! 144. file = PTW-elev-0n036.4112.txt, -36, elevation angle = 0.
! 145. file = PTW-elev-0n035.4112.txt, -35, elevation angle = 0.
! 146. file = PTW-elev-0n034.4112.txt, -34, elevation angle = 0.
! 147. file = PTW-elev-0n033.4112.txt, -33, elevation angle = 0.
! 148. file = PTW-elev-0n032.4112.txt, -32, elevation angle = 0.
! 149. file = PTW-elev-0n031.4112.txt, -31, elevation angle = 0.
! 150. file = PTW-elev-0n030.4112.txt, -30, elevation angle = 0.
! 151. file = PTW-elev-0n029.4112.txt, -29, elevation angle = 0.
! 152. file = PTW-elev-0n028.4112.txt, -28, elevation angle = 0.
! 153. file = PTW-elev-0n027.4112.txt, -27, elevation angle = 0.
! 154. file = PTW-elev-0n026.4112.txt, -26, elevation angle = 0.
! 155. file = PTW-elev-0n025.4112.txt, -25, elevation angle = 0.
! 156. file = PTW-elev-0n024.4112.txt, -24, elevation angle = 0.
! 157. file = PTW-elev-0n023.4112.txt, -23, elevation angle = 0.
! 158. file = PTW-elev-0n022.4112.txt, -22, elevation angle = 0.
! 159. file = PTW-elev-0n021.4112.txt, -21, elevation angle = 0.
! 160. file = PTW-elev-0n020.4112.txt, -20, elevation angle = 0.
! 161. file = PTW-elev-0n019.4112.txt, -19, elevation angle = 0.
! 162. file = PTW-elev-0n018.4112.txt, -18, elevation angle = 0.
! 163. file = PTW-elev-0n017.4112.txt, -17, elevation angle = 0.
! 164. file = PTW-elev-0n016.4112.txt, -16, elevation angle = 0.
! 165. file = PTW-elev-0n015.4112.txt, -15, elevation angle = 0.
! 166. file = PTW-elev-0n014.4112.txt, -14, elevation angle = 0.
! 167. file = PTW-elev-0n013.4112.txt, -13, elevation angle = 0.
! 168. file = PTW-elev-0n012.4112.txt, -12, elevation angle = 0.
! 169. file = PTW-elev-0n011.4112.txt, -11, elevation angle = 0.
! 170. file = PTW-elev-0n010.4112.txt, -10, elevation angle = 0.
! 171. file = PTW-elev-0n009.4112.txt, -9, elevation angle = 0.
! 172. file = PTW-elev-0n008.4112.txt, -8, elevation angle = 0.
! 173. file = PTW-elev-0n007.4112.txt, -7, elevation angle = 0.
! 174. file = PTW-elev-0n006.4112.txt, -6, elevation angle = 0.
! 175. file = PTW-elev-0n005.4112.txt, -5, elevation angle = 0.
! 176. file = PTW-elev-0n004.4112.txt, -4, elevation angle = 0.
! 177. file = PTW-elev-0n003.4112.txt, -3, elevation angle = 0.
! 178. file = PTW-elev-0n002.4112.txt, -2, elevation angle = 0.
! 179. file = PTW-elev-0n001.4112.txt, -1, elevation angle = 0.
! 180. file = PTW-elev-0p000.4112.txt, 0, elevation angle = 0.
! 181. file = PTW-elev-0p001.4112.txt, 1, elevation angle = 0.
! 182. file = PTW-elev-0p002.4112.txt, 2, elevation angle = 0.
! 183. file = PTW-elev-0p003.4112.txt, 3, elevation angle = 0.
! 184. file = PTW-elev-0p004.4112.txt, 4, elevation angle = 0.
! 185. file = PTW-elev-0p005.4112.txt, 5, elevation angle = 0.
! 186. file = PTW-elev-0p006.4112.txt, 6, elevation angle = 0.
! 187. file = PTW-elev-0p007.4112.txt, 7, elevation angle = 0.
! 188. file = PTW-elev-0p008.4112.txt, 8, elevation angle = 0.
! 189. file = PTW-elev-0p009.4112.txt, 9, elevation angle = 0.
! 190. file = PTW-elev-0p010.4112.txt, 10, elevation angle = 0.
! 191. file = PTW-elev-0p011.4112.txt, 11, elevation angle = 0.
! 192. file = PTW-elev-0p012.4112.txt, 12, elevation angle = 0.
! 193. file = PTW-elev-0p013.4112.txt, 13, elevation angle = 0.
! 194. file = PTW-elev-0p014.4112.txt, 14, elevation angle = 0.
! 195. file = PTW-elev-0p015.4112.txt, 15, elevation angle = 0.
! 196. file = PTW-elev-0p016.4112.txt, 16, elevation angle = 0.
! 197. file = PTW-elev-0p017.4112.txt, 17, elevation angle = 0.
! 198. file = PTW-elev-0p018.4112.txt, 18, elevation angle = 0.
! 199. file = PTW-elev-0p019.4112.txt, 19, elevation angle = 0.
! 200. file = PTW-elev-0p020.4112.txt, 20, elevation angle = 0.
! 201. file = PTW-elev-0p021.4112.txt, 21, elevation angle = 0.
! 202. file = PTW-elev-0p022.4112.txt, 22, elevation angle = 0.
! 203. file = PTW-elev-0p023.4112.txt, 23, elevation angle = 0.
! 204. file = PTW-elev-0p024.4112.txt, 24, elevation angle = 0.
! 205. file = PTW-elev-0p025.4112.txt, 25, elevation angle = 0.
! 206. file = PTW-elev-0p026.4112.txt, 26, elevation angle = 0.
! 207. file = PTW-elev-0p027.4112.txt, 27, elevation angle = 0.
! 208. file = PTW-elev-0p028.4112.txt, 28, elevation angle = 0.
! 209. file = PTW-elev-0p029.4112.txt, 29, elevation angle = 0.
! 210. file = PTW-elev-0p030.4112.txt, 30, elevation angle = 0.
! 211. file = PTW-elev-0p031.4112.txt, 31, elevation angle = 0.
! 212. file = PTW-elev-0p032.4112.txt, 32, elevation angle = 0.
! 213. file = PTW-elev-0p033.4112.txt, 33, elevation angle = 0.
! 214. file = PTW-elev-0p034.4112.txt, 34, elevation angle = 0.
! 215. file = PTW-elev-0p035.4112.txt, 35, elevation angle = 0.
! 216. file = PTW-elev-0p036.4112.txt, 36, elevation angle = 0.
! 217. file = PTW-elev-0p037.4112.txt, 37, elevation angle = 0.
! 218. file = PTW-elev-0p038.4112.txt, 38, elevation angle = 0.
! 219. file = PTW-elev-0p039.4112.txt, 39, elevation angle = 0.
! 220. file = PTW-elev-0p040.4112.txt, 40, elevation angle = 0.
! 221. file = PTW-elev-0p041.4112.txt, 41, elevation angle = 0.
! 222. file = PTW-elev-0p042.4112.txt, 42, elevation angle = 0.
! 223. file = PTW-elev-0p043.4112.txt, 43, elevation angle = 0.
! 224. file = PTW-elev-0p044.4112.txt, 44, elevation angle = 0.
! 225. file = PTW-elev-0p045.4112.txt, 45, elevation angle = 0.
! 226. file = PTW-elev-0p046.4112.txt, 46, elevation angle = 0.
! 227. file = PTW-elev-0p047.4112.txt, 47, elevation angle = 0.
! 228. file = PTW-elev-0p048.4112.txt, 48, elevation angle = 0.
! 229. file = PTW-elev-0p049.4112.txt, 49, elevation angle = 0.
! 230. file = PTW-elev-0p050.4112.txt, 50, elevation angle = 0.
! 231. file = PTW-elev-0p051.4112.txt, 51, elevation angle = 0.
! 232. file = PTW-elev-0p052.4112.txt, 52, elevation angle = 0.
! 233. file = PTW-elev-0p053.4112.txt, 53, elevation angle = 0.
! 234. file = PTW-elev-0p054.4112.txt, 54, elevation angle = 0.
! 235. file = PTW-elev-0p055.4112.txt, 55, elevation angle = 0.
! 236. file = PTW-elev-0p056.4112.txt, 56, elevation angle = 0.
! 237. file = PTW-elev-0p057.4112.txt, 57, elevation angle = 0.
! 238. file = PTW-elev-0p058.4112.txt, 58, elevation angle = 0.
! 239. file = PTW-elev-0p059.4112.txt, 59, elevation angle = 0.
! 240. file = PTW-elev-0p060.4112.txt, 60, elevation angle = 0.
! 241. file = PTW-elev-0p061.4112.txt, 61, elevation angle = 0.
! 242. file = PTW-elev-0p062.4112.txt, 62, elevation angle = 0.
! 243. file = PTW-elev-0p063.4112.txt, 63, elevation angle = 0.
! 244. file = PTW-elev-0p064.4112.txt, 64, elevation angle = 0.
! 245. file = PTW-elev-0p065.4112.txt, 65, elevation angle = 0.
! 246. file = PTW-elev-0p066.4112.txt, 66, elevation angle = 0.
! 247. file = PTW-elev-0p067.4112.txt, 67, elevation angle = 0.
! 248. file = PTW-elev-0p068.4112.txt, 68, elevation angle = 0.
! 249. file = PTW-elev-0p069.4112.txt, 69, elevation angle = 0.
! 250. file = PTW-elev-0p070.4112.txt, 70, elevation angle = 0.
! 251. file = PTW-elev-0p071.4112.txt, 71, elevation angle = 0.
! 252. file = PTW-elev-0p072.4112.txt, 72, elevation angle = 0.
! 253. file = PTW-elev-0p073.4112.txt, 73, elevation angle = 0.
! 254. file = PTW-elev-0p074.4112.txt, 74, elevation angle = 0.
! 255. file = PTW-elev-0p075.4112.txt, 75, elevation angle = 0.
! 256. file = PTW-elev-0p076.4112.txt, 76, elevation angle = 0.
! 257. file = PTW-elev-0p077.4112.txt, 77, elevation angle = 0.
! 258. file = PTW-elev-0p078.4112.txt, 78, elevation angle = 0.
! 259. file = PTW-elev-0p079.4112.txt, 79, elevation angle = 0.
! 260. file = PTW-elev-0p080.4112.txt, 80, elevation angle = 0.
! 261. file = PTW-elev-0p081.4112.txt, 81, elevation angle = 0.
! 262. file = PTW-elev-0p082.4112.txt, 82, elevation angle = 0.
! 263. file = PTW-elev-0p083.4112.txt, 83, elevation angle = 0.
! 264. file = PTW-elev-0p084.4112.txt, 84, elevation angle = 0.
! 265. file = PTW-elev-0p085.4112.txt, 85, elevation angle = 0.
! 266. file = PTW-elev-0p086.4112.txt, 86, elevation angle = 0.
! 267. file = PTW-elev-0p087.4112.txt, 87, elevation angle = 0.
! 268. file = PTW-elev-0p088.4112.txt, 88, elevation angle = 0.
! 269. file = PTW-elev-0p089.4112.txt, 89, elevation angle = 0.
! 270. file = PTW-elev-0p090.4112.txt, 90, elevation angle = 0.
! 271. file = PTW-elev-0p091.4112.txt, 91, elevation angle = 0.
! 272. file = PTW-elev-0p092.4112.txt, 92, elevation angle = 0.
! 273. file = PTW-elev-0p093.4112.txt, 93, elevation angle = 0.
! 274. file = PTW-elev-0p094.4112.txt, 94, elevation angle = 0.
! 275. file = PTW-elev-0p095.4112.txt, 95, elevation angle = 0.
! 276. file = PTW-elev-0p096.4112.txt, 96, elevation angle = 0.
! 277. file = PTW-elev-0p097.4112.txt, 97, elevation angle = 0.
! 278. file = PTW-elev-0p098.4112.txt, 98, elevation angle = 0.
! 279. file = PTW-elev-0p099.4112.txt, 99, elevation angle = 0.
! 280. file = PTW-elev-0p100.4112.txt, 100, elevation angle = 0.
! 281. file = PTW-elev-0p101.4112.txt, 101, elevation angle = 0.
! 282. file = PTW-elev-0p102.4112.txt, 102, elevation angle = 0.
! 283. file = PTW-elev-0p103.4112.txt, 103, elevation angle = 0.
! 284. file = PTW-elev-0p104.4112.txt, 104, elevation angle = 0.
! 285. file = PTW-elev-0p105.4112.txt, 105, elevation angle = 0.
! 286. file = PTW-elev-0p106.4112.txt, 106, elevation angle = 0.
! 287. file = PTW-elev-0p107.4112.txt, 107, elevation angle = 0.
! 288. file = PTW-elev-0p108.4112.txt, 108, elevation angle = 0.
! 289. file = PTW-elev-0p109.4112.txt, 109, elevation angle = 0.
! 290. file = PTW-elev-0p110.4112.txt, 110, elevation angle = 0.
! 291. file = PTW-elev-0p111.4112.txt, 111, elevation angle = 0.
! 292. file = PTW-elev-0p112.4112.txt, 112, elevation angle = 0.
! 293. file = PTW-elev-0p113.4112.txt, 113, elevation angle = 0.
! 294. file = PTW-elev-0p114.4112.txt, 114, elevation angle = 0.
! 295. file = PTW-elev-0p115.4112.txt, 115, elevation angle = 0.
! 296. file = PTW-elev-0p116.4112.txt, 116, elevation angle = 0.
! 297. file = PTW-elev-0p117.4112.txt, 117, elevation angle = 0.
! 298. file = PTW-elev-0p118.4112.txt, 118, elevation angle = 0.
! 299. file = PTW-elev-0p119.4112.txt, 119, elevation angle = 0.
! 300. file = PTW-elev-0p120.4112.txt, 120, elevation angle = 0.
! 301. file = PTW-elev-0p121.4112.txt, 121, elevation angle = 0.
! 302. file = PTW-elev-0p122.4112.txt, 122, elevation angle = 0.
! 303. file = PTW-elev-0p123.4112.txt, 123, elevation angle = 0.
! 304. file = PTW-elev-0p124.4112.txt, 124, elevation angle = 0.
! 305. file = PTW-elev-0p125.4112.txt, 125, elevation angle = 0.
! 306. file = PTW-elev-0p126.4112.txt, 126, elevation angle = 0.
! 307. file = PTW-elev-0p127.4112.txt, 127, elevation angle = 0.
! 308. file = PTW-elev-0p128.4112.txt, 128, elevation angle = 0.
! 309. file = PTW-elev-0p129.4112.txt, 129, elevation angle = 0.
! 310. file = PTW-elev-0p130.4112.txt, 130, elevation angle = 0.
! 311. file = PTW-elev-0p131.4112.txt, 131, elevation angle = 0.
! 312. file = PTW-elev-0p132.4112.txt, 132, elevation angle = 0.
! 313. file = PTW-elev-0p133.4112.txt, 133, elevation angle = 0.
! 314. file = PTW-elev-0p134.4112.txt, 134, elevation angle = 0.
! 315. file = PTW-elev-0p135.4112.txt, 135, elevation angle = 0.
! 316. file = PTW-elev-0p136.4112.txt, 136, elevation angle = 0.
! 317. file = PTW-elev-0p137.4112.txt, 137, elevation angle = 0.
! 318. file = PTW-elev-0p138.4112.txt, 138, elevation angle = 0.
! 319. file = PTW-elev-0p139.4112.txt, 139, elevation angle = 0.
! 320. file = PTW-elev-0p140.4112.txt, 140, elevation angle = 0.
! 321. file = PTW-elev-0p141.4112.txt, 141, elevation angle = 0.
! 322. file = PTW-elev-0p142.4112.txt, 142, elevation angle = 0.
! 323. file = PTW-elev-0p143.4112.txt, 143, elevation angle = 0.
! 324. file = PTW-elev-0p144.4112.txt, 144, elevation angle = 0.
! 325. file = PTW-elev-0p145.4112.txt, 145, elevation angle = 0.
! 326. file = PTW-elev-0p146.4112.txt, 146, elevation angle = 0.
! 327. file = PTW-elev-0p147.4112.txt, 147, elevation angle = 0.
! 328. file = PTW-elev-0p148.4112.txt, 148, elevation angle = 0.
! 329. file = PTW-elev-0p149.4112.txt, 149, elevation angle = 0.
! 330. file = PTW-elev-0p150.4112.txt, 150, elevation angle = 0.
! 331. file = PTW-elev-0p151.4112.txt, 151, elevation angle = 0.
! 332. file = PTW-elev-0p152.4112.txt, 152, elevation angle = 0.
! 333. file = PTW-elev-0p153.4112.txt, 153, elevation angle = 0.
! 334. file = PTW-elev-0p154.4112.txt, 154, elevation angle = 0.
! 335. file = PTW-elev-0p155.4112.txt, 155, elevation angle = 0.
! 336. file = PTW-elev-0p156.4112.txt, 156, elevation angle = 0.
! 337. file = PTW-elev-0p157.4112.txt, 157, elevation angle = 0.
! 338. file = PTW-elev-0p158.4112.txt, 158, elevation angle = 0.
! 339. file = PTW-elev-0p159.4112.txt, 159, elevation angle = 0.
! 340. file = PTW-elev-0p160.4112.txt, 160, elevation angle = 0.
! 341. file = PTW-elev-0p161.4112.txt, 161, elevation angle = 0.
! 342. file = PTW-elev-0p162.4112.txt, 162, elevation angle = 0.
! 343. file = PTW-elev-0p163.4112.txt, 163, elevation angle = 0.
! 344. file = PTW-elev-0p164.4112.txt, 164, elevation angle = 0.
! 345. file = PTW-elev-0p165.4112.txt, 165, elevation angle = 0.
! 346. file = PTW-elev-0p166.4112.txt, 166, elevation angle = 0.
! 347. file = PTW-elev-0p167.4112.txt, 167, elevation angle = 0.
! 348. file = PTW-elev-0p168.4112.txt, 168, elevation angle = 0.
! 349. file = PTW-elev-0p169.4112.txt, 169, elevation angle = 0.
! 350. file = PTW-elev-0p170.4112.txt, 170, elevation angle = 0.
! 351. file = PTW-elev-0p171.4112.txt, 171, elevation angle = 0.
! 352. file = PTW-elev-0p172.4112.txt, 172, elevation angle = 0.
! 353. file = PTW-elev-0p173.4112.txt, 173, elevation angle = 0.
! 354. file = PTW-elev-0p174.4112.txt, 174, elevation angle = 0.
! 355. file = PTW-elev-0p175.4112.txt, 175, elevation angle = 0.
! 356. file = PTW-elev-0p176.4112.txt, 176, elevation angle = 0.
! 357. file = PTW-elev-0p177.4112.txt, 177, elevation angle = 0.
! 358. file = PTW-elev-0p178.4112.txt, 178, elevation angle = 0.
! 359. file = PTW-elev-0p179.4112.txt, 179, elevation angle = 0.
! 360. file = PTW-elev-0p180.4112.txt, 180, elevation angle = 0.
!
! completed at 2020-05-12 21:49:23
!
! compiler version: GCC version 9.3.0.
! compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip gather.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
!
! STOP Successful run for "gather.f08."
