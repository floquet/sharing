# https://stackoverflow.com/questions/35234003/how-to-create-a-makefile-for-a-fortran-program-using-modules
# https://stackoverflow.com/questions/5871780/creating-a-fortran-makefile
# Find all source files, create a list of corresponding object files
SRCS=$(wildcard *.f08)
OBJS=$(patsubst %.f08,%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS=$(wildcard s_*.f08, m_*.f08)
m_OBJS=$(patsubst %.f08,%.o,$(MODS))

# Compiler/Linker settings
# -g: create debug data
# -c: compile only- don't link
FC = gfortran
FLFLAGS = -g
FCFLAGS = -c ${gflags}
PROGRAM = fourier
PRG_OBJ = $(PROGRAM).o

# Clean the suffixes
.SUFFIXES:

# Set the suffixes we are interested in
.SUFFIXES: .f08 .o

# make without parameters will make first target found.
default : $(PROGRAM)

# Compiler steps for all objects
$(OBJS) : %.o : %.f08
	$(FC) $(FCFLAGS) -o $@ $<

# Linker
$(PROGRAM) : $(OBJS)
	$(FC) $(FLFLAGS) -o $@ $^

debug:
	@echo "SRCS = $(SRCS)"
	@echo "OBJS = $(OBJS)"
	@echo "MODS = $(MODS)"
	@echo "m_OBJS = $(m_OBJS)"
	@echo "PROGRAM = $(PROGRAM)"
	@echo "PRG_OBJ = $(PRG_OBJ)"

clean:
	rm -rf $(OBJS) $(patsubst %.o,%.mod,$(m_OBJS))
	rm -f *.o *.mod *.smod *.dSYM # Cray and Mac boogers

.PHONY: debug default clean

# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(m_OBJS)

# Blocks and allocations depends on shared
## strict capitalization needed for portability
m_precision-definitions.o       :
m-format-descriptors.o          :
m-get-command-line-arguments.o  :
m-process-control.o             :
#m_class_edge.o             : m_precision_definitions.o

# dantopa@dtopa-latitude-5491:fourier $ pwd
# /home/dantopa/repos/bitbucket/fortran-alpha/projects/fourier

# dantopa@dtopa-latitude-5491:fourier $ date
# Mon 09 Mar 2020 02:18:46 PM MDT

# dantopa@dtopa-latitude-5491:fourier $ make debug
# SRCS = m_format_descriptors.f08 m_precision_definitions.f08 fourier.f08
# OBJS = m_format_descriptors.o m_precision_definitions.o fourier.o
# MODS = m_format_descriptors.f08 m_precision_definitions.f08
# m_OBJS = m_format_descriptors.o m_precision_definitions.o
# PROGRAM = fourier
# PRG_OBJ = fourier.o

# dantopa@dtopa-latitude-5491:fourier $ make
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o fourier.o fourier.f08
# gfortran -g -o fourier m_format_descriptors.o m_precision_definitions.o fourier.o
# dantopa@dtopa-latitude-5491:fourier $ ./fourier
#
# completed at 2020-03-09 14:18:56
#
# compiler version: GCC version 9.2.1 20200304
# compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -auxbase-strip fourier.o -g -Og -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h
# STOP Successful run for "fourier.f08".
