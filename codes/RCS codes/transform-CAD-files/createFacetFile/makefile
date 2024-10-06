# Find all source files, create a list of corresponding object files
PROGRAM = createFacetFile

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

debug:
	@echo "PROGRAM  = $(PROGRAM)"
	@echo "PRG_OBJ  = $(PRG_OBJ)"
	@echo "SRCS     = $(SRCS)"
	@echo "OBJS     = $(OBJS)"
	@echo "MODS     = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"

clean:
	rm -rf $(OBJS) $(PROGRAM) $(patsubst %.o,%.mod,$(MOD_OBJS))
	rm -f *.mod *.smod *.o

.PHONY: debug default clean

# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# resolve module interdependencies
# class modules
m-class-census.o           : m-precision-definitions.o
m-class-face.o             : m-library-of-constants.o m-precision-definitions.o
m-class-vertex.o           : m-library-of-constants.o m-precision-definitions.o
m-class-io-tools.o         :
m-class-model.o            : m-class-census.o m-class-vertex.o m-class-face.o m-allocations.o m-format-descriptors.o m-obj-reader.o m-file-handling.o m-facet-writer.o m-harvest-command-line.o m-library-of-constants.o
# action modules
m-facet-writer.o           : m-precision-definitions.o m-class-vertex.o m-class-face.o m-format-descriptors.o
# vanilla modules
m-allocations.o            : m-precision-definitions.o m-format-descriptors.o m-class-vertex.o m-class-face.o
m-file-handling.o          :
m-format-descriptors.o     :
m-harvest-command-line.o   :
m-library-of-constants.o   :
m-parameters-simulation.o  : m-precision-definitions.o
m-precision-definitions.o  :
