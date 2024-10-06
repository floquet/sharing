# Find all source files, create a list of corresponding object files
PROGRAM = novusFacimus

EXT = f08
SRCS=$(wildcard *.$(EXT))
OBJS=$(patsubst %.$(EXT),%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS=$(wildcard m-*.$(EXT))
MOD_OBJS=$(patsubst %.$(EXT),%.o,$(MODS))

# Compiler/Linker settings
# https://stackoverflow.com/questions/42140832/automatic-array-allocation-upon-assignment-in-fortran
# the command line option -fno-realloc-lhs disables this automatic (re-)allocation, making the compiler not Fortran 2003+ compliant
FC = gfortran
FCFLAGS = -g -c -Og -pedantic ${Wflags} ${fflags}
FLFLAGS = -g
PRG_OBJ = $(PROGRAM).o

# Clean the suffixes
.SUFFIXES:

# Set the suffixes we are interested in
.SUFFIXES: .$(EXT) .o
#all : apex
# make without parameters will make first target found.
default : $(PROGRAM)
all     : $(PROGRAM)  # eclipse

# Compiler steps for all objects
%.o : %.$(EXT)
	$(FC) $(FCFLAGS) -o $@ $<

# Linker
$(PROGRAM) : $(OBJS)
	$(FC) $(FLFLAGS) -o $@ $^

clean:
	rm -rf $(OBJS) $(PROGRAM) $(patsubst %.o,%.mod,$(MOD_OBJS))
	rm -rf $(ODIR)/*.o $(ODIR)/*.mod
	rm -rf *.mod *.smod

compiler:
	@echo "Compiler version  = $(shell gcc --version | head -n 1)"
	@echo "Compiler location = $(shell which $(CC))"

debug:
	@echo "PROGRAM  = $(PROGRAM)"
	@echo "PRG_OBJ  = $(PRG_OBJ)"
	@echo "SRCS     = $(SRCS)"
	@echo "OBJS     = $(OBJS)"
	@echo ""
	@echo "MODS     = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"

directories:
	@echo "Include directory IDIR = $(IDIR)"
	@echo "Library directory LDIR = $(LDIR)"
	@echo "Objects directory ODIR = $(ODIR)"
	@echo "Modules directory VDIR = $(VDIR)"

flags:
	@echo "Compile flags: $(FCFLAGS)"
	@echo "Link flags: $(FLFLAGS)"

options:
	@echo "Available macros"
	@echo "clean debug default directories flags options verify"

purge:
	rm -rf $(OBJS) $(patsubst %.o,%.mod,$(MOD_OBJS))
	rm -rf $(ODIR)/*.o $(ODIR)/*.mod
	rm -rf *.mod *.smod

.PHONY: all clean debug default directories flags options purge verify

# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# resolve module interdependencies
m-allocations-special.o    : m-class-edge.o m-class-face.o m-class-vertex.o m-allocations.o m-precision-definitions.o
m-allocations.o            : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-class-average.o          : m-precision-definitions.o
m-class-edge.o             : m-class-vertex.o m-library-of-constants.o m-precision-definitions.o
m-class-face.o             : m-class-vertex.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o
m-class-model.o            : m-class-edge.o m-class-face.o m-class-vertex.o m-allocations-special.o m-allocations.o m-class-average.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o
m-class-vertex.o           : m-io-tools.o m-library-of-constants.o m-precision-definitions.o
m-facet-writer.o           :
m-file-handling.o          :
m-format-descriptors.o     : m-precision-definitions.o
m-harvest-command-line.o   : m-precision-definitions.o
m-io-tools.o               : m-allocations.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-library-of-constants.o   : m-precision-definitions.o
m-precision-definitions.o  :
m-process-control.o        : m-class-model.o

# dantopa:test-evaluate/facet-edge % make clean                                                                                             (master)ftn
# rm -rf m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o novusFacimus.o novusFacimus m-allocations-special.mod m-allocations.mod m-class-average.mod m-class-edge.mod m-class-face.mod m-class-model.mod m-class-vertex.mod m-facet-writer.mod m-file-handling.mod m-format-descriptors.mod m-harvest-command-line.mod m-io-tools.mod m-library-of-constants.mod m-precision-definitions.mod m-process-control.mod
# rm -rf /*.o /*.mod
# rm -rf *.mod *.smod
#
# dantopa:test-evaluate/facet-edge % make debug                                                                                             (master)ftn
# PROGRAM  = novusFacimus
# PRG_OBJ  = novusFacimus.o
# SRCS     = m-allocations-special.f08 m-allocations.f08 m-class-average.f08 m-class-edge.f08 m-class-face.f08 m-class-model.f08 m-class-vertex.f08 m-facet-writer.f08 m-file-handling.f08 m-format-descriptors.f08 m-harvest-command-line.f08 m-io-tools.f08 m-library-of-constants.f08 m-precision-definitions.f08 m-process-control.f08 novusFacimus.f08
# OBJS     = m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o novusFacimus.o
#
# MODS     = m-allocations-special.f08 m-allocations.f08 m-class-average.f08 m-class-edge.f08 m-class-face.f08 m-class-model.f08 m-class-vertex.f08 m-facet-writer.f08 m-file-handling.f08 m-format-descriptors.f08 m-harvest-command-line.f08 m-io-tools.f08 m-library-of-constants.f08 m-precision-definitions.f08 m-process-control.f08
# MOD_OBJS = m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o
# dantopa:test-evaluate/facet-edge % make compiler                                                                                          (master)ftn
# Compiler version  = gcc (MacPorts gcc9 9.3.0_1) 9.3.0
# Compiler location = /usr/bin/cc
#
# dantopa:test-evaluate/facet-edge % make                                                                                                   (master)ftn
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-precision-definitions.o m-precision-definitions.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-format-descriptors.o m-format-descriptors.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-library-of-constants.o m-library-of-constants.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations.o m-allocations.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-file-handling.o m-file-handling.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-io-tools.o m-io-tools.f08
# m-io-tools.f08:89:56:
#
#    89 |                 stub = me % textLine ( kLines )( 1 : 2 )
#       |                                                        1
# Warning: CHARACTER expression will be truncated in assignment (2/132) at (1) [-Wcharacter-truncation]
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-vertex.o m-class-vertex.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-edge.o m-class-edge.f08
# m-class-edge.f08:28:59:
#
#    28 |     subroutine add_new_edge_sub ( me, myVertices, indexFace, indexVertexA, indexVertexB, indexVertexLo, indexVertexHi )
#       |                                                           1
# Warning: Unused dummy argument 'indexface' at (1) [-Wunused-dummy-argument]
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-face.o m-class-face.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations-special.o m-allocations-special.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-average.o m-class-average.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-facet-writer.o m-facet-writer.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-harvest-command-line.o m-harvest-command-line.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-model.o m-class-model.f08
# m-class-model.f08:460:56:
#
#   460 |             nameStem   =       trim ( me % nameOBJ ( 1 : nameLength - 4_ip ) )
#       |                                                        1
# Warning: Conversion from INTEGER(4) to INTEGER(8) at (1) [-Wconversion-extra]
# m-class-model.f08:253:41:
#
#   253 |                 me % centroid ( kDim ) = sum ( [ ( me % myVertex ( kVertex ) % position ( kDim ), &
#       |                                         1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m-class-model.f08:155:58:
#
#   155 |                     write ( strVertexIndex, fmt = dimFmt ) [ ( p % indexVertex ( kDim ), kDim = 1, dim ) ]
#       |                                                          1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m-class-model.f08:159:52:
#
#   159 |                         write ( temp, fmt = dimFmt ) &
#       |                                                    1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-process-control.o m-process-control.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o novusFacimus.o novusFacimus.f08
# gfortran -g -o novusFacimus m-allocations-special.o m-allocations.o m-class-average.o m-class-edge.o m-class-face.o m-class-model.o m-class-vertex.o m-facet-writer.o m-file-handling.o m-format-descriptors.o m-harvest-command-line.o m-io-tools.o m-library-of-constants.o m-precision-definitions.o m-process-control.o novusFacimus.o
#
# dantopa:test-evaluate/facet-edge % ./novusFacimus data/me-10.00.obj                                                                       (master)ftn
# There are 128 vertices and 252 faces.
# Opening data/me-10.00.facet for writing.
# Opening data/me-10.00.areas for writing.
# Opening data/me-10.00.verts for writing.
# Opening data/me-10.00.close for writing.
# Opening data/me-10.00.edges for writing.
# Opening data/me-10.00.debug for writing.
# Opening data/me-10.00.histg for writing.
#
# CPU time used =      0.940E-02 seconds.
#
# completed at 2020-07-23 22:33:29
#
# compiler version: GCC version 9.3.0.
#
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip novusFacimus.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "novusFacimus.f08."
