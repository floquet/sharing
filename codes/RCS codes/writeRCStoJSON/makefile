# Find all source files, create a list of corresponding object files
PROGRAM = json-writer

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
	@echo "all clean debug default directories flags options"

purge:
	rm -rf $(OBJS) $(patsubst %.o,%.mod,$(MOD_OBJS))
	rm -rf $(ODIR)/*.o $(ODIR)/*.mod
	rm -rf *.mod *.smod

.PHONY: all clean debug default directories flags options

# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# resolve module interdependencies
m-allocations.o            : m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
m-asset-properties.o       : m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o m-rcs.o
m-file-handling.o          :
m-format-descriptors.o     :
m-library-of-constants.o   : m-precision-definitions.o
m-precision-definitions.o  :
m-rcs.o                    : m-file-handling.o m-format-descriptors.o m-library-of-constants.o m-precision-definitions.o
