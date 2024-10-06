! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program novusFacimus

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    ! utilities
    use mFormatDescriptors,             only : fmt_cpu_time, fmt_datecom
    use mProcessControl,                only : main_process_sub
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    real ( rp ) :: start = 0.0_rp, finish = 0.0_rp
    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

        call cpu_time ( start )

            call main_process_sub ( )

        call cpu_time ( finish )
        ! execution complete - tag output
        write ( * , fmt = fmt_cpu_time ) finish - start
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt = fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '(    "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "novusFacimus.f08."'

end program novusFacimus

! dantopa:test-evaluate/facet-edge % make clean                                                                                             (master)ftn
! rm -rf m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o novusFacimus.o novusFacimus m-allocations-special.mod m-allocations.mod m-class-average.mod m-class-edge.mod m-class-face.mod m-class-model.mod m-class-vertex.mod m-facet-writer.mod m-file-handling.mod m-format-descriptors.mod m-harvest-command-line.mod m-io-tools.mod m-library-of-constants.mod m-precision-definitions.mod m-process-control.mod
! rm -rf /*.o /*.mod
! rm -rf *.mod *.smod
!
! dantopa:test-evaluate/facet-edge % make debug                                                                                             (master)ftn
! PROGRAM  = novusFacimus
! PRG_OBJ  = novusFacimus.o
! SRCS     = m-allocations-special.f08 m-allocations.f08 m-class-average.f08 m-class-edge.f08 m-class-face.f08 m-class-model.f08 m-class-vertex.f08 m-facet-writer.f08 m-file-handling.f08 m-format-descriptors.f08 m-harvest-command-line.f08 m-io-tools.f08 m-library-of-constants.f08 m-precision-definitions.f08 m-process-control.f08 novusFacimus.f08
! OBJS     = m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o novusFacimus.o
!
! MODS     = m-allocations-special.f08 m-allocations.f08 m-class-average.f08 m-class-edge.f08 m-class-face.f08 m-class-model.f08 m-class-vertex.f08 m-facet-writer.f08 m-file-handling.f08 m-format-descriptors.f08 m-harvest-command-line.f08 m-io-tools.f08 m-library-of-constants.f08 m-precision-definitions.f08 m-process-control.f08
! MOD_OBJS = m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o
! dantopa:test-evaluate/facet-edge % make compiler                                                                                          (master)ftn
! Compiler version  = gcc (MacPorts gcc9 9.3.0_1) 9.3.0
! Compiler location = /usr/bin/cc
!
! dantopa:test-evaluate/facet-edge % make                                                                                                   (master)ftn
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-precision-definitions.o m-precision-definitions.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-format-descriptors.o m-format-descriptors.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-library-of-constants.o m-library-of-constants.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations.o m-allocations.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-file-handling.o m-file-handling.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-io-tools.o m-io-tools.f08
! m-io-tools.f08:89:56:
!
!    89 |                 stub = me % textLine ( kLines )( 1 : 2 )
!       |                                                        1
! Warning: CHARACTER expression will be truncated in assignment (2/132) at (1) [-Wcharacter-truncation]
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-vertex.o m-class-vertex.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-edge.o m-class-edge.f08
! m-class-edge.f08:28:59:
!
!    28 |     subroutine add_new_edge_sub ( me, myVertices, indexFace, indexVertexA, indexVertexB, indexVertexLo, indexVertexHi )
!       |                                                           1
! Warning: Unused dummy argument 'indexface' at (1) [-Wunused-dummy-argument]
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-face.o m-class-face.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations-special.o m-allocations-special.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-average.o m-class-average.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-facet-writer.o m-facet-writer.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-harvest-command-line.o m-harvest-command-line.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-model.o m-class-model.f08
! m-class-model.f08:460:56:
!
!   460 |             nameStem   =       trim ( me % nameOBJ ( 1 : nameLength - 4_ip ) )
!       |                                                        1
! Warning: Conversion from INTEGER(4) to INTEGER(8) at (1) [-Wconversion-extra]
! m-class-model.f08:253:41:
!
!   253 |                 me % centroid ( kDim ) = sum ( [ ( me % myVertex ( kVertex ) % position ( kDim ), &
!       |                                         1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! m-class-model.f08:155:58:
!
!   155 |                     write ( strVertexIndex, fmt = dimFmt ) [ ( p % indexVertex ( kDim ), kDim = 1, dim ) ]
!       |                                                          1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! m-class-model.f08:159:52:
!
!   159 |                         write ( temp, fmt = dimFmt ) &
!       |                                                    1
! Warning: Creating array temporary at (1) [-Warray-temporaries]
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-process-control.o m-process-control.f08
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o novusFacimus.o novusFacimus.f08
! gfortran -g -o novusFacimus m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o novusFacimus.o
!
! dantopa:test-evaluate/facet-edge % ./novusFacimus data/me-10.00.obj                                                                       (master)ftn
! There are 128 vertices and 252 faces.
! Opening data/me-10.00.facet for writing.
! Opening data/me-10.00.areas for writing.
! Opening data/me-10.00.verts for writing.
! Opening data/me-10.00.close for writing.
! Opening data/me-10.00.edges for writing.
! Opening data/me-10.00.debug for writing.
! Opening data/me-10.00.histg for writing.
!
! CPU time used =      0.940E-02 seconds.
!
! completed at 2020-07-23 22:33:29
!
! compiler version: GCC version 9.3.0.
!
! compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip novusFacimus.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
!
! STOP Successful run for "novusFacimus.f08."
