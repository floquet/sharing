# Find all source files, create a list of corresponding object files
# https://stackoverflow.com/questions/8855896/specify-directory-where-gfortran-should-look-for-modules
PROGRAM = sigma

EXT = f08
SRCS=$(wildcard *.$(EXT))
OBJS=$(patsubst %.$(EXT),%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS=$(wildcard m-*.$(EXT))
MOD_OBJS=$(patsubst %.$(EXT),%.o,$(MODS))

#BLIBS = -L/home/dantopa/spacktivity/centos-7-spack/opt/spack/linux-centos7-haswell/gcc-10.1.0/openblas-0.3.10-6xqz2bhjbrbmmxiulmsku5pfkbzxgp4o/lib -llapack -lblas
# Compiler/Linker settings
# https://stackoverflow.com/questions/42140832/automatic-array-allocation-upon-assignment-in-fortran
# the command line option -fno-realloc-lhs disables this automatic (re-)allocation, making the compiler not Fortran 2003+ compliant
FC = gfortran
FCFLAGS = -g -c -Og -pedantic ${Wflags} ${fflags}
# https://stackoverflow.com/questions/35007006/error-in-linking-gfortran-to-lapack-and-blas
FLFLAGS = -g -lopenblas
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
	$(FC) $(FLFLAGS) $(BLIBS) -o $@ $^

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

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
	@echo "Your make file supplies these macros:"
	@echo "all clean debug default directories flags options purge"

purge:
	rm -rf $(OBJS) $(patsubst %.o,%.mod,$(MOD_OBJS))
	rm -rf $(ODIR)/*.o $(ODIR)/*.mod
	rm -rf *.mod *.smod

.PHONY: all clean debug default directories flags options purge

# resolve module interdependencies
# class modules
m_allocations.o            : m_format_descriptors.o m_parameters_simulation.o m_precision_definitions.o
m_build_A_fourier.o        : m_allocations.o m_format_descriptors.o m_matrix_writer.o m_precision_definitions.o
m_file_handling.o          :
m_format_descriptors.o     :
m_lapack_errors.o          : m_format_descriptors.o m_precision_definitions.o
m_matrix_writer.o          : m_file_handling.o m_precision_definitions.o
m_parameters_simulation.o  : m_precision_definitions.o
m_precision_definitions.o  :
m_rcs_profile.o            : m_allocations.o m_file_handling.o m_format_descriptors.o m_matrix_writer.o m_precision_definitions.o
m_solution_normal.o        : m_allocations.o m_build_A_fourier.o m_lapack_errors.o m_matrix_writer.o m_precision_definitions.o
m_test_routines.o          : m_precision_definitions.o m_allocations.o m_build_A_fourier.o m_format_descriptors.o m_matrix_writer.o m_parameters_simulation.o m_rcs_profile.o

# dantopa:fourier/bosun % make                                                                                            (master)ftn
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_parameters_simulation.o m_parameters_simulation.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_allocations.o m_allocations.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_file_handling.o m_file_handling.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_matrix_writer.o m_matrix_writer.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_build_A_fourier.o m_build_A_fourier.f08
# m_build_A_fourier.f08:34:30:
#
#    34 |         integer ( ip ) :: cols = 0
#       |                              1
# Warning: Unused variable 'cols' declared at (1) [-Wunused-variable]
# m_build_A_fourier.f08:33:30:
#
#    33 |         integer ( ip ) :: rows = 0
#       |                              1
# Warning: Unused variable 'rows' declared at (1) [-Wunused-variable]
# m_build_A_fourier.f08:52:52:
#
#    52 |             write ( * , fmt_three ) "shape( A ) = ", shape ( me % A )
#       |                                                    1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_lapack_errors.o m_lapack_errors.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_rcs_profile.o m_rcs_profile.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_solution_normal.o m_solution_normal.f08
# m_solution_normal.f08:137:51:
#
#   137 |                                             dims = [ rows, cols ], myFile = "dgetrf-in.txt" )
#       |                                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:137:51:
#
#   137 |                                             dims = [ rows, cols ], myFile = "dgetrf-in.txt" )
#       |                                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:145:51:
#
#   145 |                                             dims = [ rows, cols ], myFile = "dgetrf-out.txt" )
#       |                                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:145:51:
#
#   145 |                                             dims = [ rows, cols ], myFile = "dgetrf-out.txt" )
#       |                                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:164:35:
#
#   164 |             me % amplitude ( : ) = matmul ( me % Winv ( : , : ), me % Asb )
#       |                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:166:61:
#
#   166 |             me % residual ( : ) = mySystem % b ( : ) - matmul ( mySystem % A ( : , : ), me % amplitude )
#       |                                                             1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:169:31:
#
#   169 |             me % error ( : ) = [ ( me % Winv ( k, k ), k = 1, me % len_solution ) ]
#       |                               1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:91:31:
#
#    91 |             me % W ( : , : ) = matmul ( transpose ( mySystem % A ( : , : ) ) , mySystem % A ( : , : ) )
#       |                               1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:96:51:
#
#    96 |                                             dims = [ me % len_solution, me % len_solution ], myFile = "fresh-out.txt" )
#       |                                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:96:51:
#
#    96 |                                             dims = [ me % len_solution, me % len_solution ], myFile = "fresh-out.txt" )
#       |                                                   1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_solution_normal.f08:98:31:
#
#    98 |             me % Asb ( : )   = matmul ( transpose ( mySystem % A ( : , : ) ), mySystem % b ( : ) )
#       |                               1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_test_routines.o m_test_routines.f08
# m_test_routines.f08:45:22:
#
#    45 |             myA % b = [ ( sigma % profile ( nu, k ), k = 1, colSciacca ) ]
#       |                      1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o sigma.o sigma.f08
# gfortran -g -framework accelerate -I/Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/mom/beast/mods -o sigma m_allocations.o m_build_A_fourier.o m_file_handling.o m_format_descriptors.o m_lapack_errors.o m_matrix_writer.o m_parameters_simulation.o m_precision_definitions.o m_rcs_profile.o m_solution_normal.o m_test_routines.o sigma.o
