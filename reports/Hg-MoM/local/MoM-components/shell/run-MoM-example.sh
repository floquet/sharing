#! /bin/bash
printf '%s\n' "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

export SECONDS=0
export ymd=$(date +%Y-%m-%d-%H-%M) # timestamp results

# counts steps in batch process
export counter=0
function new_step(){
    counter=$((counter+1))
    echo ""
    echo "Step ${counter}: ${1}"
}

echo "ulimit -s unlimited"
      ulimit -s unlimited

echo "export OMP_NUM_THREADS=10"
      export OMP_NUM_THREADS=10

new_step "Verify directory location: pwd"
          pwd

new_step "Verify directory contents: ls -alh"
          ls -alh

new_step "Create *.facet file from *.obj file: createFacetFile PTW.obj"
          createFacetFile PTW.obj

new_step "Run Mercury MoM: /.MMoM 4.1.12 PTW.geo > PTW-output.txt"
          /.MMoM 4.1.12 PTW.geo > PTW-output.txt

new_step "Extract RCS data from the ASCII output: harvestRCSdata PTW.4112.txt"
          harvestRCSdata PTW.4112.txt

new_step "Create a plot of the RCS by azimuth and frequency: plotRCSdata PTW-rcs.dat"
          plotRCSdata PTW-rcs.dat
