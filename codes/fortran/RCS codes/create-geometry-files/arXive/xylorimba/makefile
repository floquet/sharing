# Find all source files, create a list of corresponding object files
# https://stackoverflow.com/questions/8855896/specify-directory-where-gfortran-should-look-for-modules
PROGRAM = gather

EXT = f08
SRCS=$(wildcard *.$(EXT))
OBJS=$(patsubst %.$(EXT),%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS=$(wildcard m_*.$(EXT))
MOD_OBJS=$(patsubst %.$(EXT),%.o,$(MODS))

# Compiler/Linker settings
# https://stackoverflow.com/questions/42140832/automatic-array-allocation-upon-assignment-in-fortran
# the command line option -fno-realloc-lhs disables this automatic (re-)allocation, making the compiler not Fortran 2003+ compliant
FC = gfortran
FC = gfortran
FCFLAGS = -g -c -Og -pedantic\
-Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra \
-fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived
FLFLAGS = -g -framework accelerate
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
	rm -f *.mod *.smod *.o

.PHONY: debug default clean
#.PHONY: list
#list:
#	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
# Dependencies

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# resolve module interdependencies
m_allocations.o            : m_precision_definitions.o m_format_descriptors.o m_parameters_simulation.o m_mom_e_fields.o #m_array_bounds.o
m_array_bounds.o           : m_precision_definitions.o
m_file_handling.o          :
m_format_descriptors.o     :
m_harvest_command_line.o   : m_precision_definitions.o m_format_descriptors.o
m_io_utilities.o           : m_file_handling.o m_format_descriptors.o m_mom_e_fields.o
m_mom_output.o             : m_precision_definitions.o m_allocations.o m_file_handling.o m_format_descriptors.o m_io_utilities.o m_mom_e_fields.o m_array_bounds.o
m_mom_e_fields.o           : m_precision_definitions.o
m_parameters_simulation.o  : m_precision_definitions.o
m_precision_definitions.o  :
m_rcs_data_table.o         : m_precision_definitions.o m_array_bounds.o

# dantopa:3d/xylophone % pwd                                                                                                                                  (master)fortran-alpha
# /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/readers/3d/xylophone
#
# dantopa:3d/xylophone % date                                                                                                                                 (master)fortran-alpha
# Tue May 12 21:01:27 MDT 2020
#
# dantopa:3d/xylophone % make clean                                                                                                                           (master)fortran-alpha
# rm -rf gather.o m_allocations.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_io_utilities.o m_mom_e_fields.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o m_rcs_data_table.o gather m_allocations.mod m_file_handling.mod m_format_descriptors.mod m_harvest_command_line.mod m_io_utilities.mod m_mom_e_fields.mod m_mom_output.mod m_mom_results.mod m_parameters_simulation.mod m_precision_definitions.mod m_rcs_data_table.mod
# rm -f *.mod *.smod *.o
#
# dantopa:3d/xylophone % make debug                                                                                                                           (master)fortran-alpha
# PROGRAM  = gather
# PRG_OBJ  = gather.o
# SRCS     = gather.f08 m_allocations.f08 m_file_handling.f08 m_format_descriptors.f08 m_harvest_command_line.f08 m_io_utilities.f08 m_mom_e_fields.f08 m_mom_output.f08 m_mom_results.f08 m_parameters_simulation.f08 m_precision_definitions.f08 m_rcs_data_table.f08
# OBJS     = gather.o m_allocations.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_io_utilities.o m_mom_e_fields.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o m_rcs_data_table.o
# MODS     = m_allocations.f08 m_file_handling.f08 m_format_descriptors.f08 m_harvest_command_line.f08 m_io_utilities.f08 m_mom_e_fields.f08 m_mom_output.f08 m_mom_results.f08 m_parameters_simulation.f08 m_precision_definitions.f08 m_rcs_data_table.f08
# MOD_OBJS = m_allocations.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_io_utilities.o m_mom_e_fields.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o m_rcs_data_table.o
#
# dantopa:3d/xylophone % make -k; make -k                                                                                                                     (master)fortran-alpha
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_precision_definitions.o m_precision_definitions.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_format_descriptors.o m_format_descriptors.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_parameters_simulation.o m_parameters_simulation.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_e_fields.o m_mom_e_fields.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_allocations.o m_allocations.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_file_handling.o m_file_handling.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_harvest_command_line.o m_harvest_command_line.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_io_utilities.o m_io_utilities.f08
# m_io_utilities.f08:7:8:
#
#     7 |     use mMoMresults,                    only : MoM
#       |        1
# Fatal Error: Cannot open module file 'mmomresults.mod' for reading at (1): No such file or directory
# compilation terminated.
# make: *** [m_io_utilities.o] Error 1
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_results.o m_mom_results.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_rcs_data_table.o m_rcs_data_table.f08
# m_rcs_data_table.f08:47:31:
#
#    47 |                 me % loc_max = [ nu, maxloc ( meanTotalRCS ( : ) ), elevationAngle ]
#       |                               1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_rcs_data_table.f08:47:36:
#
#    47 |                 me % loc_max = [ nu, maxloc ( meanTotalRCS ( : ) ), elevationAngle ]
#       |                                    1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_rcs_data_table.f08:52:31:
#
#    52 |                 me % loc_min = [ nu, minloc ( meanTotalRCS ( : ) ), elevationAngle ]
#       |                               1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# m_rcs_data_table.f08:52:36:
#
#    52 |                 me % loc_min = [ nu, minloc ( meanTotalRCS ( : ) ), elevationAngle ]
#       |                                    1
# Warning: Creating array temporary at (1) [-Warray-temporaries]
# make: Target `default' not remade because of errors.
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_io_utilities.o m_io_utilities.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m_mom_output.o m_mom_output.f08
# gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o gather.o gather.f08
# gather.f08:16:43:
#
#    16 |     real ( sp ) :: meanTotalRCS ( 1 : 360 )
#       |                                           1
# Warning: Unused variable 'meantotalrcs' declared at (1) [-Wunused-variable]
# gfortran -g -framework accelerate -o gather gather.o m_allocations.o m_file_handling.o m_format_descriptors.o m_harvest_command_line.o m_io_utilities.o m_mom_e_fields.o m_mom_output.o m_mom_results.o m_parameters_simulation.o m_precision_definitions.o m_rcs_data_table.o
#
# dantopa:3d/xylophone % ./gather                                                                                                                             (master)fortran-alpha
# Error in 'get_command_argument' fetching argument 1.
# get_command_argument status = 42
# Command line argument cannot be retrieved.
#
# Modern Fortran Explained: Incorporating Fortran 2018, Metcalf, Reid, Cohen
# Section 9.12.2, p. 216
# STOP Program crashed in module 'mHarvestCommandLine', subroutine 'harvest_all_command_line_arguments'...
#
# dantopa:3d/xylophone % ./gather $myData -179                                                                                                                (master)fortran-alpha
# MoMoutputFile = /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/readers/3d/MoM-output/PTW-elev-0n001.4112.txt.
# elevationAngle = -179.
# Array size verified: number of elements = 3628800 totalling 0.135183334E-01 GB.
# /Users/dantopa/primary-repos/bitbucket/fortran-alpha/rcs/readers/3d/MoM-output/PTW-elev-0n001.4112.txt has 14843 lines
#
# completed at 2020-05-12 21:02:10
#
# compiler version: GCC version 9.3.0.
# compiler options: -fdiagnostics-color=auto -fPIC -feliminate-unused-debug-symbols -mmacosx-version-min=10.15.0 -mtune=core2 -auxbase-strip gather.o -g -Og -Wpedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -finit-derived.
#
# STOP Successful run for "gather.f08."
