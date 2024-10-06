# Find all source files, create a list of corresponding object files
# https://stackoverflow.com/questions/8855896/specify-directory-where-gfortran-should-look-for-modules
PROGRAM = harvestRCSfromMoM

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
	@echo "ALPHA    = $(ALPHA)"
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

.PHONY: clean debug default directories flags options purge verify
#.PHONY: list
#list:
#	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# resolve module interdependencies (listings are alphabetical)
# classes
m-class-averages.o                    : m-allocations.o m-precision-definitions.o
m-class-data-file.o                   : m-class-averages.o m-class-electric-fields.o m-class-mesh.o m-allocations.o m-allocations-special.o m-file-handling.o m-library-of-constants.o m-precision-definitions.o m-text-file-utilities.o
m-class-electric-fields.o             : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-class-mesh.o                        : m-allocations.o m-class-averages.o m-precision-definitions.o
# utilities
m-allocations.o                       : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-allocations-special.o               : m-class-averages.o m-allocations.o m-precision-definitions.o
m-file-handling.o                     :
m-format-descriptors.o                :
m-get-command-line-arguments.o        : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-library-of-constants.o              : m-precision-definitions.o
m-list-of-mom-files.o                 : m-allocations.o m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o m-text-file-utilities.o
m-precision-definitions.o             :
m-process-control.o                   : m-class-data-file.o m-library-of-constants.o m-precision-definitions.o
m-text-file-utilities.o               : m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
