# https://stackoverflow.com/questions/35234003/how-to-create-a-makefile-for-a-fortran-program-using-modules
# https://stackoverflow.com/questions/5871780/creating-a-fortran-makefile
# Find all source files, create a list of corresponding object files
SRCS=$(wildcard *.f08)
OBJS=$(patsubst %.f08,%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS=$(wildcard m_*.f08)
#MODS=$(wildcard mod*.f08)
MOD_OBJS=$(patsubst %.f08,%.o,$(MODS))

# Compiler/Linker settings
# -g: create debug data
# -c: compile only- don't link
FC = gfortran
FLFLAGS = -g
FCFLAGS = -c ${gflags}
PROGRAM = nec2_modern
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
	@echo "SRCS     = $(SRCS)"
	@echo "OBJS     = $(OBJS)"
	@echo "MODS     = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"
	@echo "PROGRAM  = $(PROGRAM)"
	@echo "PRG_OBJ  = $(PRG_OBJ)"

clean:
	rm -rf $(OBJS) $(patsubst %.o,%.mod,$(m_OBJS))
	rm -f *.o *.mod *.smod *.dSYM # Cray and Mac boogers

.PHONY: debug default clean

# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(m_OBJS)

# Blocks and allocations depends on shared
# m_unit_values has no dependencies
# strict capitalization needed for portability
# classes
m_functions.o              : m_precision_definitions.o m_parameters.o m_data_blocks.o m_format_descriptors.o
m_subroutines.o            : m_precision_definitions.o

m_block_definitions.o      : m_precision_definitions.o
m_format_descriptors.o     :
m_precision_definitions.o  :
m_parameters.o             : m_precision_definitions.o

# C     NUMERICAL ELECTROMAGNETICS CODE (NEC2)  DEVELOPED AT LAWRENCE
# C     LIVERMORE LAB., LIVERMORE, CA.  (CONTACT G. BURKE AT 415-422-8414
# C     FOR PROBLEMS WITH THE NEC CODE.  FOR PROBLEMS WITH THE VAX IMPLEM-
# C     ENTATION, CONTACT J. BREAKALL AT 415-422-8196 OR E. DOMNING AT 415
# C     422-5936)
# C     FILE CREATED 4/11/80.


# dantopa@dtopa-latitude-5491:modern $ pwd
# /home/dantopa/repos/bitbucket/fortran-alpha/projects/nec2/modern

# dantopa@dtopa-latitude-5491:modern $ date
# Tue 11 Feb 2020 11:04:15 AM MST

# dantopa@dtopa-latitude-5491:modern $ make clean; make debug
# rm -rf m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o nec2_modern.o
# rm -f *.o *.mod *.smod *.dSYM # Cray and Mac boogers
# SRCS     = m_format_descriptors.f08 m_subroutines.f08 m_parameters.f08 m_functions.f08 m_precision_definitions.f08 nec2_modern.f08
# OBJS     = m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o nec2_modern.o
# MODS     = m_format_descriptors.f08 m_subroutines.f08 m_parameters.f08 m_functions.f08 m_precision_definitions.f08
# MOD_OBJS = m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o
# PROGRAM  = nec2_modern
# PRG_OBJ  = nec2_modern.o

# dantopa@dtopa-latitude-5491:modern $ make
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_subroutines.o m_subroutines.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_parameters.o m_parameters.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o m_functions.o m_functions.f08
# gfortran -c -g -ffpe-trap=denormal,invalid,zero -fbacktrace -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Og -pedantic -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -Wfunction-elimination -faggressive-function-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -fdiagnostics-color=auto  -Wconversion-extra  -finit-derived -o nec2_modern.o nec2_modern.f08
# gfortran -g -o nec2_modern m_format_descriptors.o m_subroutines.o m_parameters.o m_functions.o m_precision_definitions.o nec2_modern.o

# dantopa@dtopa-latitude-5491:modern $ ./nec2_modern
# stringIn:  My String
# stringOut: MY STRING
#  impedance_wire ( i, i ) =               (0.0000000000000000,-7.7459666924148332)
#  z % re =    0.0000000000000000
#  z % im =   -7.7459666924148332
# impedance_wire ( i, i ) =  ( 0.0000000000000000, -7.7459666924148332 )
# impedance_wire ( i, i ) =  ( 0.0000000000000000, -7.7459666924148332 )
#
# completed at 2020-02-11 11:04:29
#
# compiler version: GCC version 9.2.1 20200123
#
# compiler options: -fdiagnostics-color=auto -mtune=generic -march=x86-64 -auxbase-strip nec2_modern.o -g -Og -Wall -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wpedantic -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived -fpre-include=/usr/include/finclude/math-vector-fortran.h
#
# STOP Successful run for "nec2_modern.f08".
