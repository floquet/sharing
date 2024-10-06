! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program createFacetFile

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    ! class structures
    use mClassModel,                    only : model
    ! utilities
    use mFormatDescriptors,             only : fmt_datecom
    use mHarvestCommandLine,            only : harvest_single_command_line_argument
    use mPrecisionDefinitions,          only : ip

    implicit none

    type ( model ) :: myModel

    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

        ! initialize model
        ! model details
        myModel % mirror      = 0
        myModel % numParts    = 1
        myModel % numSubParts = 1
        call myModel % create_file_names ( )

        ! action sequence
        call myModel % perform_census     ( )
        call myModel % memory_allocations ( )
        call myModel % read_input_file    ( )

        ! write data files
        call myModel % writeFacetFile   ( )
        call myModel % compute_triangle ( )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '(    "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "createFacetFile.f08."'

end program createFacetFile

! dantopa:CAD handlers/facet % pwd                                                                                                                   (master)tertius
! /Users/dantopa/primary-repos/di2e/tertius/codes/compiled/CAD handlers/facet
!
! dantopa:CAD handlers/facet % make clean                                                                                                            (master)tertius
! rm -rf facet-maker.o m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o facet-maker m_allocations.mod m_class_census.mod m_class_face.mod m_class_model.mod m_class_vertex.mod m_facet_writer.mod m_file_handling.mod m_format_descriptors.mod m_harvest_command_line.mod m_obj_reader.mod m_parameters_simulation.mod m_precision_definitions.mod
! rm -f *.mod *.smod *.o
!
! dantopa:CAD handlers/facet % make debug                                                                                                            (master)tertius
! PROGRAM  = facet-maker
! PRG_OBJ  = facet-maker.o
! SRCS     = facet-maker.f08 m_allocations.f08 m_class_census.f08 m_class_face.f08 m_class_model.f08 m_class_vertex.f08 m_facet_writer.f08 m_file_handling.f08 m_format_descriptors.f08 m_harvest_command_line.f08 m_obj_reader.f08 m_parameters_simulation.f08 m_precision_definitions.f08
! OBJS     = facet-maker.o m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o
! MODS     = m_allocations.f08 m_class_census.f08 m_class_face.f08 m_class_model.f08 m_class_vertex.f08 m_facet_writer.f08 m_file_handling.f08 m_format_descriptors.f08 m_harvest_command_line.f08 m_obj_reader.f08 m_parameters_simulation.f08 m_precision_definitions.f08
! MOD_OBJS = m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o
!
! dantopa:CAD handlers/facet % make -k                                                                                                               (master)tertius
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_parameters_simulation.o m_parameters_simulation.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_class_vertex.o m_class_vertex.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_class_face.o m_class_face.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_allocations.o m_allocations.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_class_census.o m_class_census.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_file_handling.o m_file_handling.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_obj_reader.o m_obj_reader.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_facet_writer.o m_facet_writer.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_harvest_command_line.o m_harvest_command_line.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o m_class_model.o m_class_model.f08
! gfortran -g -c -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto -Wconversion-extra -finit-derived -o facet-maker.o facet-maker.f08
! gfortran -g -o facet-maker facet-maker.o m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o
!
! dantopa:CAD handlers/facet % ./facet-maker myShip                                                                                                  (master)tertius
!
! target directory: ./data/
! input  file: ./data/myShip.obj
! output file: ./data/myShip.facet
! No entries found for species v
! STOP Program crashed in subroutine count_species_sub...
