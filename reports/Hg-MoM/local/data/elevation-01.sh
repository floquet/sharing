#!/bin/bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

# Alterations to the shell environment
# 1. ulimit is set to unlimited
# 2. OMP_NUM_THREADS is set to 10
# 3. LD_LIBRARY_PATH is altered, and then restored before exit
# 4. There are many parameters declared: counter, subcounter, mom, inputs, outputs, bin, stem, facets, f

# Privacy concerns: information gathered on your machine
# 1. Probe commands: lsb_release, lscpu, proc/meminfo
# 2. $HOSTNAME is used to build the name of the tarball

# counts steps in batch process
export counter=0
export SECONDS=0
function new_step(){
    export counter=$((counter+1))
    export subcounter=0
    echo ""; echo ""
    echo "Step ${counter}: ${1}"
}
function sub_step(){
    subcounter=$((subcounter+1))
    echo ""
    echo "  Substep ${counter}.${subcounter}: ${1}"
}

new_step "Set environment variables"
export previous_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
export OMP_NUM_THREADS=10
export LD_LIBRARY_PATH="/usr/lib64":"$(pwd)":"${LD_LIBRARY_PATH}"
echo "\${OMP_NUM_THREADS} = ${OMP_NUM_THREADS}"
echo "\${LD_LIBRARY_PATH} = ${LD_LIBRARY_PATH}"

# local directory structure
export     mom=$(dirname $PWD)
export     bin=${mom}/bin
export  inputs=${mom}/inputs
export outputs=${mom}/outputs
echo "\${mom}     = ${mom}"
echo "\${bin}     = ${bin}"
echo "\${inputs}  = ${inputs}"
echo "\${outputs} = ${outputs}"

# MoM Users Manual, p. 3
echo "ulimit -s unlimited"
      ulimit -s unlimited
echo "ulimit = $(ulimit)"

export ticks=${SECONDS}
export f="PTW"
new_step "Run Sciacca example: ${f}"
sub_step "cd ${bin}"
          cd ${bin}
sub_step "cp ${inputs}/${f}/*.* ${bin}"
          cp ${inputs}/${f}/*.* ${bin}
sub_step "mkdir -p ${outputs}/${f}"
          mkdir -p ${outputs}/${f}
sub_step "./MMoM_4.1.12 ${f}-elevation.geo > ${outputs}/${f}/${f}-run.out"
          ./MMoM_4.1.12 ${f}-elevation.geo > ${outputs}/${f}/${f}-run.out
sub_step "mv *.dat *.txt *.rtg ${outputs}/${f}"
          mv *.dat *.txt *.rtg ${outputs}/${f}
sub_step "rm ${f}*.*"
	      rm ${f}*.*
sub_step "time used to run ${f} data = $((SECONDS-ticks)) s"

new_step "System characterization: catalog MoM-tolerant environments"
    sub_step "lsb_release -a > ${outputs}/lsb-release.txt"
              lsb_release -a > ${outputs}/lsb-release.txt

    sub_step "lscpu > ${outputs}/lscpu.txt"
              lscpu > ${outputs}/lscpu.txt

    sub_step "cat /proc/meminfo > ${outputs}/meminfo.txt"
              cat /proc/meminfo > ${outputs}/meminfo.txt

new_step "Zip up results"
    echo "cd ${mom}"
          cd ${mom}
    echo "rm MoM-${HOSTNAME}.tar.gz"
          rm MoM-${HOSTNAME}.tar.gz
    echo "tar -czf MoM-${HOSTNAME}.tar.gz outputs/."
          tar -czf MoM-${HOSTNAME}.tar.gz outputs/.
    echo ""
    echo "Kindly email the tarball ${mom}/MoM-${HOSTNAME}.tar.gz to daniel.topa@ertcorp.com"

new_step "Exit"
export LD_LIBRARY_PATH=${previous_LD_LIBRARY_PATH}
echo "time used = ${SECONDS} s"
date
