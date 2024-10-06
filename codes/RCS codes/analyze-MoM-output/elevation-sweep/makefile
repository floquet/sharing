# Find all source files, create a list of corresponding object files
# https://stackoverflow.com/questions/8855896/specify-directory-where-gfortran-should-look-for-modules
PROGRAM = aeneas

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
FCFLAGS = -g -c -Og -pedantic\
-Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra \
-fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived
FLFLAGS = -g
# FLFLAGS = -g -framework accelerate
#-I/Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/mom/beast/mods
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

debug:
	@echo "PROGRAM  = $(PROGRAM)"
	@echo "PRG_OBJ  = $(PRG_OBJ)"
	@echo "SRCS     = $(SRCS)"
	@echo "OBJS     = $(OBJS)"
	@echo "MODS     = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"

clean:
	rm -rf $(OBJS) $(PROGRAM) $(patsubst %.o,%.mod,$(MOD_OBJS))
	rm -f *.mod *.smod *.o *.dSYM # Cray and Mac boogers

.PHONY: debug default clean
#.PHONY: list
#list:
#	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# resolve module interdependencies (listings are alphabetical)
# classes
m-class-averages.o         : m-allocations.o m-precision-definitions.o
m-class-data-collection.o  : m-class-data-file.o m-class-mesh.o m-allocations-special.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o m-text-file-utilities.o
m-class-data-file.o        : m-class-averages.o m-class-electric-fields.o m-class-mesh.o m-allocations.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o m-text-file-utilities.o
m-class-electric-fields.o  : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-class-mesh.o             : m-allocations.o m-precision-definitions.o
# utilities
m-allocations.o            : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-allocations-special.o    : m-class-averages.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-file-handling.o          :
m-format-descriptors.o     :
m-library-of-constants.o   : m-precision-definitions.o
m-list-of-mom-files.o      : m-allocations.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o m-text-file-utilities.o
m-precision-definitions.o  :
m-scenarios.o              : m-class-data-collection.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o
m-text-file-utilities.o    : m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o


# dantopa:hot/aeneas % pwd                                                                                      (master)fortran-alpha
# /Users/dantopa/primary-repos/bitbucket/fortran-alpha/hot/aeneas

# dantopa:hot/aeneas % make clean                                                                               (master)fortran-alpha
# rm -rf aeneas.o m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o aeneas m-allocations-special.mod m-allocations.mod m-class-averages.mod m-class-data-collection.mod m-class-data-file.mod m-class-electric-fields.mod m-class-mesh.mod m-file-handling.mod m-format-descriptors.mod m-library-of-constants.mod m-list-of-mom-files.mod m-precision-definitions.mod m-scenarios.mod m-text-file-utilities.mod
# rm -f *.mod *.smod *.o *.dSYM # Cray and Mac boogers

# dantopa:hot/aeneas % make debug                                                                               (master)fortran-alpha
# PROGRAM  = aeneas
# PRG_OBJ  = aeneas.o
# SRCS     = aeneas.f08 m-allocations-special.f08 m-allocations.f08 m-class-averages.f08 m-class-data-collection.f08 m-class-data-file.f08 m-class-electric-fields.f08 m-class-mesh.f08 m-file-handling.f08 m-format-descriptors.f08 m-library-of-constants.f08 m-list-of-mom-files.f08 m-precision-definitions.f08 m-scenarios.f08 m-text-file-utilities.f08
# OBJS     = aeneas.o m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o
# MODS     = m-allocations-special.f08 m-allocations.f08 m-class-averages.f08 m-class-data-collection.f08 m-class-data-file.f08 m-class-electric-fields.f08 m-class-mesh.f08 m-file-handling.f08 m-format-descriptors.f08 m-library-of-constants.f08 m-list-of-mom-files.f08 m-precision-definitions.f08 m-scenarios.f08 m-text-file-utilities.f08
# MOD_OBJS = m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o

# dantopa:hot/aeneas % make                                                                                     (master)fortran-alpha
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-format-descriptors.o m-format-descriptors.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-precision-definitions.o m-precision-definitions.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-library-of-constants.o m-library-of-constants.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations.o m-allocations.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-averages.o m-class-averages.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-allocations-special.o m-allocations-special.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-electric-fields.o m-class-electric-fields.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-mesh.o m-class-mesh.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-file-handling.o m-file-handling.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-text-file-utilities.o m-text-file-utilities.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-data-file.o m-class-data-file.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-data-collection.o m-class-data-collection.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-list-of-mom-files.o m-list-of-mom-files.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-scenarios.o m-scenarios.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o aeneas.o aeneas.f08
# gfortran -g -o aeneas aeneas.o m-allocations-special.o m-allocations.o m-class-averages.o m-class-data-collection.o m-class-data-file.o m-class-electric-fields.o m-class-mesh.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-list-of-mom-files.o m-precision-definitions.o m-scenarios.o m-text-file-utilities.o

# dantopa:hot/aeneas % ./aeneas                                                                                 (master)fortran-alpha
# List of 10 input files in ../elevations/list-of-files.txt:
#  1. PTW-elev-0p045.4112.txt.
#  2. PTW-elev-0p050.4112.txt.
#  3. PTW-elev-0p055.4112.txt.
#  4. PTW-elev-0p060.4112.txt.
#  5. PTW-elev-0p065.4112.txt.
#  6. PTW-elev-0p070.4112.txt.
#  7. PTW-elev-0p075.4112.txt.
#  8. PTW-elev-0p080.4112.txt.
#  9. PTW-elev-0p085.4112.txt.
# 10. PTW-elev-0p090.4112.txt.
#
# * Properties of azimuth   mesh:
# * minimum value = -180.000000, maximum value = 179.000000, length = 359.000000
# * number of samples = 360, interval size = 1.00000000
#
# #  #  Dimensions for RCS data containers  #  #
#
# # Expected dimensions:
# # Number of radar frequencies scanned by MoM:   28
# # Number of azimuth   angles scanned by MoM:  360
# # Number of elevation angles scanned manually: 10
#
# # Container for each MoM 4112.txt file: rcs_table_rank_2
# # Free angle dimension = 360 indices run from 1 to 360
# # Frequency dimension  = 28 indices run from 1 to 28
#
# # Container for all MoM 4112.txt files: rcs_table_rank_3
# # Free angle dimension  = 360 indices run from 1 to 360
# # Frequency dimension   = 28 indices run from 1 to 28
# # Fixed angle dimension = 10 indices run from 1 to 10
#
# Analyzing file 001/010: 'PTW-elev-0p045.4112.txt', elevation = 45.
# Analyzing file 002/010: 'PTW-elev-0p050.4112.txt', elevation = 40.
# Analyzing file 003/010: 'PTW-elev-0p055.4112.txt', elevation = 35.
# Analyzing file 004/010: 'PTW-elev-0p060.4112.txt', elevation = 30.
# Analyzing file 005/010: 'PTW-elev-0p065.4112.txt', elevation = 25.
# Analyzing file 006/010: 'PTW-elev-0p070.4112.txt', elevation = 20.
# Analyzing file 007/010: 'PTW-elev-0p075.4112.txt', elevation = 15.
# Analyzing file 008/010: 'PTW-elev-0p080.4112.txt', elevation = 10.
# Analyzing file 009/010: 'PTW-elev-0p085.4112.txt', elevation = 5.
# Analyzing file 010/010: 'PTW-elev-0p090.4112.txt', elevation = 0.
#
#  - - - - - - - - -
#
#  2020-05-28  0:08:55
#
# compiler version: GCC version 9.3.0.
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip aeneas.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "aeneas.f08."
