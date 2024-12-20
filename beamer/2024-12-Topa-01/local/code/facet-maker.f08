! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program facet_maker

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    ! class structures
    use mClassModel,                    only : model
    ! utilities
    use mPrecisionDefinitions,          only : ip
    use mFormatDescriptors,             only : fmt_datecom

    implicit none

    type ( model ) :: myModel

    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

    character ( len = 256 ) :: dataDirectory = "", dataFile = ""
    character ( len = 512 ) :: namePath = ""

        ! initialize model
        ! model details
        myModel % mirror      = 0
        myModel % numParts    = 1
        myModel % numSubParts = 1
        myModel % partName    = "<PTW MeshModel>"
        myModel % subPartName = "<PTW MeshSheet>"
        ! myModel % partName    = "<B20A MeshModel>"
        ! myModel % subPartName = "<B20A MeshSheet>"
        ! myModel % partName    = "<Sphere MeshModel>"
        ! myModel % subPartName = "<Sphere MeshSheet>"
        ! specify input and output files
        !call myModel % create_file_names ( namePath = "./data/" )
        !call myModel % create_file_names ( namePath = "/Users/dantopa/primary-repos/github/COVID-19/topa/RCS/FreeCAD/sphere/" )
        !call myModel % create_file_names ( namePath = "/Users/dantopa/primary-repos/github/COVID-19/topa/RCS/FreeCAD/B-20A/" )
        dataDirectory = "/Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/facet/data/"
        dataFile      = "ng-very-fine"
        namePath      = trim ( dataDirectory ) // trim ( dataFile )
        call myModel % create_file_names ( namePath = namePath )

        ! action sequence
        call myModel % perform_census     ( )
        call myModel % memory_allocations ( )
        call myModel % read_input_file    ( )
        !call myModel % compute_triangle   ( )

        ! write data
        call myModel % writeFacetFile   ( )
        call myModel % compute_triangle ( )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '(    "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "facet_maker.f08."'

end program facet_maker

! dantopa:rcs/facet % pwd                                                                                                                 (master)fortran-alpha
! /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/facet

! dantopa:rcs/facet % make clean; make debug; make                                                                                        (master)fortran-alpha
! rm -rf facet-maker.o m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o facet-maker m_allocations.mod m_class_census.mod m_class_face.mod m_class_model.mod m_class_vertex.mod m_facet_writer.mod m_file_handling.mod m_format_descriptors.mod m_harvest_command_line.mod m_obj_reader.mod m_parameters_simulation.mod m_precision_definitions.mod
! rm -f *.mod *.smod *.o

! PROGRAM  = facet-maker
! PRG_OBJ  = facet-maker.o
! SRCS     = facet-maker.f08 m_allocations.f08 m_class_census.f08 m_class_face.f08 m_class_model.f08 m_class_vertex.f08 m_facet_writer.f08 m_file_handling.f08 m_format_descriptors.f08 m_harvest_command_line.f08 m_obj_reader.f08 m_parameters_simulation.f08 m_precision_definitions.f08
! OBJS     = facet-maker.o m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o
! MODS     = m_allocations.f08 m_class_census.f08 m_class_face.f08 m_class_model.f08 m_class_vertex.f08 m_facet_writer.f08 m_file_handling.f08 m_format_descriptors.f08 m_harvest_command_line.f08 m_obj_reader.f08 m_parameters_simulation.f08 m_precision_definitions.f08
! MOD_OBJS = m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o

! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_parameters_simulation.o m_parameters_simulation.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_class_vertex.o m_class_vertex.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_class_face.o m_class_face.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_allocations.o m_allocations.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_class_census.o m_class_census.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_file_handling.o m_file_handling.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_obj_reader.o m_obj_reader.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_facet_writer.o m_facet_writer.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_harvest_command_line.o m_harvest_command_line.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o m_class_model.o m_class_model.f08
! gfortran -c -fno-realloc-lhs -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -o facet-maker.o facet-maker.f08
! gfortran -g -o facet-maker facet-maker.o m_allocations.o m_class_census.o m_class_face.o m_class_model.o m_class_vertex.o m_facet_writer.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_obj_reader.o m_parameters_simulation.o m_precision_definitions.o

! dantopa:rcs/facet % ./facet-maker B20-standard-1m                                                                                       (master)fortran-alpha
!
! target directory: ./data/
! input  file: ./data/B20-standard-1m.obj
! output file: ./data/B20-standard-1m.facet
!
! Opening ./data/B20-standard-1m.obj to read data lists.
!
! Opening ./data/B20-standard-1m.facet for writing.
!
! completed at 2020-04-08 16:05:04
!
! compiler version: GCC version 9.3.0.
!
! compiler options: -fPIC -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip facet-maker.o -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
!
! STOP Successful run for "facet_maker.f08."
