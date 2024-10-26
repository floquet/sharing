#! /usr/bin/env bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

# source /repos/github/builds/scripts-spack/environment/builders/test/new-builder.sh

# start master clock
export master=${SECONDS}

source ../shared/common-header.sh

spack_test(){
# https://stackoverflow.com/questions/4423306/how-do-i-find-the-number-of-arguments-passed-to-a-bash-script
    sub_step_counter=$((sub_step_counter+1))
    numArgs="$#"
    # echo "numArgs = ${numArgs}"
    # build command line
    cmdLine=""
    for var in "$@"
        do
            cmdLine+=${var} # append to command line
            (( count++ ))
            (( accum += ${#var} )) # number of characters
        done

    clean=$(echo "${cmdLine}" | tr -d ' ')
    clean=$(echo "${clean}"   | sed 's/\^/-/g')
    clean=$(echo "${clean}"   | sed 's/\%/-/g')
    # echo "\${cmdLine} = ${cmdLine}"
    # echo "\${clean} = ${clean}"
    echo ""
    echo "  ${step_counter}.${sub_step_counter}: spack install ${cmdLine}"
    # catalog basic information about the package: purpose, options, dependencies
    spack info "${1}" >>                        "${mySpackLogs}/info/${1}.txt" &
    # results of concretizer
    spack spec "${cmdLine}" >>                  "${mySpackLogs}/specs/${clean}.txt" &
    # install
    echo "$(date)"                  >>          "${mySpackLogs}/build-logs/${1}.txt"
    echo "spack install ${cmdLine}" >>          "${mySpackLogs}/build-logs/${1}.txt"
    export local=${master}
    spack install ${cmdLine} 2>&1 | tee -a      "${mySpackLogs}/build-logs/${1}.txt"
    export local=$((${SECONDS}-${local}))
    printf "time to build ${1}: %dh:%dm:%ds\n" $((${local}/3600)) $((${local}%3600/60)) $((${local}%60)) >> "${mySpackLogs}/build-logs/${1}.txt"
    echo ""                         >>           ${mySpackLogs}/build-logs/${1}.txt
}

new_step "Create subdirectory for log files"
export mySpackLogs="logs"
mkdir -p ${mySpackLogs}

new_step "Specify versions"
export sub_step_counter=0
    sub_step "Compiler: gcc@14.1.0"
    export myCompiler="gcc@14.1.0"
    sub_step "Clang: llvm@18.1.8"
    export myLLVM="llvm@18.1.8"
    sub_step "Python: python@3.13.0"
    export myPython="python@3.13.0"
    sub_step "OpenMPI: openmpi@5.0.5"
    export myOpenMPI="openmpi@5.0.5"

new_step "Install compilers:"
spack_sub_step_counter=0

    sub_step "spack install ${myCompiler}"
        spack install gcc ${myCompiler}

    sub_step "add ${myCompiler} to compiler bullpen"
        spack compiler find $(spack location -i ${myCompiler})

    sub_step "spack install ${myLLVM}"
        spack install llvm ${myLLVM}

    sub_step "add ${myLLVM} to compiler bullpen"
        spack compiler find $(spack location -i ${myLLVM})

new_step "Spack installs: "${myCompiler}""
spack_sub_step_counter=0

    spack_test "chapel" "${myCompiler}"
    spack_test "doxygen" "${myCompiler}" "${myPython}"
    spack_test "eigen" "${myCompiler}"
    spack_test "environment-modules" "${myCompiler}"
    spack_test "gdb" "${myCompiler}" "${myPython}"
    spack_test "gsl" "${myCompiler}"
    spack_test "julia" "${myCompiler}" "${myLLVM}"
    spack_test "lua" "${myCompiler}"
    spack_test "netcdf-fortran" "${myCompiler}" "${myOpenMPI}"
    spack_test "netcdf-cxx4" "${myCompiler}" "${myOpenMPI}"
    spack_test "octave" "+arpack +fftw +gnuplot +hdf5 +llvm +qhull +suitesparse +zlib" "${myCompiler}" "${myPython}"
    spack_test "opencoarrays" "${myCompiler}" "${myOpenMPI}"
    spack_test "parallel-netcdf" "${myCompiler}" "${myOpenMPI}"
    spack_test "petsc" "+fftw +mpfr +mumps +scalapack +strumpack +suite-sparse +superlu-dist" "${myCompiler}" "${myPython}" "${myOpenMPI}"
    spack_test "py-astropy" "+extras" "${myCompiler}" "${myPython}"
    spack_test "py-seaborn" "${myCompiler}" "${myPython}"
    spack_test "py-urllib3" "${myCompiler}" "${myPython}"
    spack_test "py-virtualenv" "${myCompiler}" "${myPython}"
    spack_test "rust" "${myCompiler}" "${myPython}"
    spack_test "tau" "${myCompiler}" "${myPython}" "${myOpenMPI}"
    spack_test 'valgrind' "${myCompiler}"  "${myOpenMPI}"
#   spack_test "xerces-c" "${myCompiler}"

new_step "Install python tools"
spack_sub_step_counter=0

    spack_test "py-astropy" "+extras" "${myCompiler}" "${myPython}"
    spack_test "py-seaborn" "${myCompiler}" "${myPython}"
    spack_test "py-urllib3" "${myCompiler}" "${myPython}"
    spack_test "py-virtualenv" "${myCompiler}" "${myPython}"

new_step "Install numeric tools"
spack_sub_step_counter=0

    spack_test "alglib" "${myCompiler}"
    spack_test "armadillo" "${myCompiler}"
    spack_test "blitz" "${myCompiler}" "${myPython}"
    spack_test "eigen" "${myCompiler}"
    spack_test "gsl" "${myCompiler}"
    spack_test "h5cpp" "${myCompiler}" "${myOpenMPI}"
    spack_test "mpich" "${myCompiler}" "${myPython}"
    spack_test "netcdf-fortran" "${myCompiler}" "${myOpenMPI}"
    spack_test "netcdf-cxx4" "${myCompiler}" "${myOpenMPI}"
    spack_test "octave" "+arpack +fftw +gnuplot +hdf5 +llvm +qhull +suitesparse +zlib" "${myCompiler}" "${myPython}"
    spack_test "petsc" "+fftw +mpfr +mumps +scalapack +strumpack +suite-sparse +superlu-dist" "${myCompiler}" "${myPython}" "${myOpenMPI}"
    spack_test "opencoarrays" "${myCompiler}" "${myOpenMPI}"
    spack_test "parallel-netcdf" "${myCompiler}" "${myOpenMPI}"
    spack_test "sprng" "+fortran" "${myCompiler}" "${myOpenMPI}"

new_step "Install debug tools"
spack_sub_step_counter=0

    spack_test "gdb" "${myCompiler}" "${myPython}"
    spack_test "tau" "${myCompiler}" "${myPython}" "${myOpenMPI}"
    spack_test "valgrind" "${myCompiler}"  "${myOpenMPI}"

new_step "Install languages:"
spack_sub_step_counter=0

    spack_test "chapel" "${myCompiler}"
    spack_test "julia" "${myCompiler}" "${myLLVM}"
    spack_test "lua" "${myCompiler}"
    spack_test "rust" "${myCompiler}" "${myPython}"

new_step "Install strays:"
spack_sub_step_counter=0

    spack_test "xcalc" "${myCompiler}"

wait

new_step "print wall time used"
  export master=$((${SECONDS}-${master}))
  printf 'time for all builds: %dh:%dm:%ds\n' $((${master}/3600)) $((${master}%3600/60)) $((${master}%60))
