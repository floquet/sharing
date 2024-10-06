! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! nb: /Users/dantopa/Mathematica_files/nb/ert/mercury/snake/fortran-01.nb
program altocumulus

! Daniel Topa, ERT Corp
! COVID-19 Prisoner

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    use mQuarry,                        only : quarry
    use mFormatDescriptors,             only : fmt_datecom
    use mWriterBatchCommand,            only : annotateMoMdriverScript, closeTimer, grabSupportFiles, updateBashScript, &
                                                purgeSupportFiles, updateHarvestScript, writeBashCounters, writeBashHeader, &
                                                updateNameList
    use mWriterGeo,                     only : writeGeoElevation

    implicit none

    type ( quarry ) :: myQuarry
    integer :: io_mom = 0, io_harvest = 0, io_namelist = 0, k = 0

    ! containers for date and time
    integer :: dt_values ( 1 : 8 ) = 0

        call writeBashHeader ( nameAndPath="../bash-land-backward/backward-sweep.sh", header = "altocumulus.f08.",io = io_mom )
        call writeBashHeader ( nameAndPath="../bash-land-backward/harvest.sh",        header = "altocumulus.f08.",io = io_harvest )
        !call writeBashHeader ( nameAndPath= "../bash-land-forward/forward-sweep.sh", header = "altocumulus.f08.", io = io_mom )
        !call writeBashHeader ( nameAndPath= "../bash-land-forward/harvest.sh",       header = "altocumulus.f08.", io = io_harvest )
        call writeBashHeader ( nameAndPath= "../bash-land-forward/file_list.txt",    header = "altocumulus.f08.", io = io_namelist )
        call writeBashCounters ( io = io_mom )
        call writeBashCounters ( io = io_harvest )
        call annotateMoMdriverScript ( io_mom )
        call myQuarry % setDirectories ( dirIn = "../inputs/", dirOut = "../outputs/" )
        call myQuarry % stemFileNames  ( quarry_name = "PTW", angle_type = "-elev-" )
        call grabSupportFiles ( myQuarry = myQuarry, unit = io_mom )

        !sweep_elevation_angles: do k = -179, 180
        sweep_elevation_angles: do k = 180, -179, -1
            call myQuarry % fullFileNames  ( angle = k )
            call writeGeoElevation   ( myQuarry = myQuarry, elevation = real ( k ) )
            call updateBashScript    ( myQuarry = myQuarry, unit = io_mom )
            call updateHarvestScript ( myQuarry = myQuarry, unit = io_harvest,  angle = k )
            call updateNameList      ( myQuarry = myQuarry, unit = io_namelist, angle = k )
        end do sweep_elevation_angles

        call purgeSupportFiles ( myQuarry = myQuarry, unit = io_mom )
        call closeTimer ( io_harvest )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "altocumulus.f08."'

end program altocumulus

! dantopa:new-geo/src % pwd                                                                                                                                   (master)fortran-alpha
! /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/writers/new-geo/src
!
! dantopa:new-geo/src % date                                                                                                                                  (master)fortran-alpha
! Tue May 12 20:55:00 MDT 2020
!
! dantopa:new-geo/src % make clean                                                                                                                            (master)fortran-alpha
! rm -rf geo-writer.o m_file_handling.o m_format_descriptors.o m_quarry.o m_string_toolkit.o m_writer_batch_command.o m_writer_geo.o altocumulus m_file_handling.mod m_format_descriptors.mod m_quarry.mod m_string_toolkit.mod m_writer_batch_command.mod m_writer_geo.mod
! rm -f *.mod *.smod *.o
!
! dantopa:new-geo/src % make debug                                                                                                                            (master)fortran-alpha
! PROGRAM  = altocumulus
! PRG_OBJ  = altocumulus.o
! SRCS     = geo-writer.f08 m_file_handling.f08 m_format_descriptors.f08 m_quarry.f08 m_string_toolkit.f08 m_writer_batch_command.f08 m_writer_geo.f08
! OBJS     = geo-writer.o m_file_handling.o m_format_descriptors.o m_quarry.o m_string_toolkit.o m_writer_batch_command.o m_writer_geo.o
! MODS     = m_file_handling.f08 m_format_descriptors.f08 m_quarry.f08 m_string_toolkit.f08 m_writer_batch_command.f08 m_writer_geo.f08
! MOD_OBJS = m_file_handling.o m_format_descriptors.o m_quarry.o m_string_toolkit.o m_writer_batch_command.o m_writer_geo.o
!
! dantopa:new-geo/src % make -k                                                                                                                               (master)fortran-alpha
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o geo-writer.o geo-writer.f08
! geo-writer.f08:9:8:
!
!     9 |     use mQuarry,                        only : quarry
!       |        1
! Fatal Error: Cannot open module file 'mquarry.mod' for reading at (1): No such file or directory
! compilation terminated.
! make: *** [geo-writer.o] Error 1
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_file_handling.o m_file_handling.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_string_toolkit.o m_string_toolkit.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_quarry.o m_quarry.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_writer_batch_command.o m_writer_batch_command.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_writer_geo.o m_writer_geo.f08
! make: Target `default' not remade because of errors.
!
! dantopa:new-geo/src % make -k                                                                                                                               (master)fortran-alpha
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o geo-writer.o geo-writer.f08
! gfortran -g -framework accelerate -I/Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/mom/beast/mods -o altocumulus geo-writer.o m_file_handling.o m_format_descriptors.o m_quarry.o m_string_toolkit.o m_writer_batch_command.o m_writer_geo.o
! dantopa:new-geo/src % ./altocumulus                                                                                                                          (master)fortran-alpha
!
! completed at 2020-05-12 20:55:20
!
! compiler version: GCC version 9.3.0.
! compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip geo-writer.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
!
! STOP Successful run for "altocumulus.f08."
