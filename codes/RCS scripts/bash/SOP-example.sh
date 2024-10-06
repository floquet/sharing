#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

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

# DREN command sequence
# 1. tar -xzf sop-demo.tar.gz
# 2. cd sop-demo
# 3. source sop-example.sh

# directory contents

# executables
#   MMoM_4.1.12
#   createFacetFile
#   harvestRCSfromMoM
#   plotRCSdata

# data files
#   PEC-Materials.lib
#   PTW.geo
#   PTW.obj

# sequence of operations
# 1. ./createFacetFile PTW.obj
#       creates PTW.facet, PTW.check, PTW.data
# 2. ./MMoM 4.1.12 PTW.geo > PTW-output.txt
# 3. ./harvestRCSfromMoM PTW.4112.txt
# 4. ./plotRCSdata PTW-rcs.dat

export ticks=${SECONDS}

new_step "./createFacetFile PTW.obj"
          ./createFacetFile PTW.obj

new_step "./MMoM_4.1.12 PTW.geo  > PTW-output.txt"
          ./MMoM_4.1.12 PTW.geo  > PTW-output.txt

new_step "./harvestRCSfromMoM PTW.4112.txt"
          ./harvestRCSfromMoM PTW.4112.txt


echo ""
echo "time used = ${SECONDS} s"
date
