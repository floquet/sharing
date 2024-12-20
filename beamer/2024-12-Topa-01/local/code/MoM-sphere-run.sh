#!/bin/bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

# counts steps in batch process
export counter=0
function new_step(){
    counter=$((counter+1))
    echo ""
    echo "Step ${counter}: ${1}"
}

new_step "Set environment variables"

export OMP_NUM_THREADS=10
export LD_LIBRARY_PATH="/usr/lib64":"$(pwd)":"${LD_LIBRARY_PATH}"

echo "ulimit = $(ulimit)"
echo "\${OMP_NUM_THREADS} = ${OMP_NUM_THREADS}"
echo "\${LD_LIBRARY_PATH} = ${LD_LIBRARY_PATH}"

facets="Sphere-S000001 Sphere-S00001 Sphere-S0001 Sphere-S001 Sphere-S01"

new_step "cd /Dropbox/2nd-generation/RCS-project/4.1.12/Linux64/bin"
          cd /Dropbox/2nd-generation/RCS-project/4.1.12/Linux64/bin

for f in ${facets}; do
	new_step "Run ${f}"
	cp sphere/sphereTemplate.geo ${f}.geo
	cp sphere/${f}.facet .
	sed -i 's/FILE_A/'${f}'/' ${f}.geo
	sed -i 's/FILE_B/'${f}'.facet/' ${f}.geo
	echo "./MMoM_4.1.12 ${f}.geo > sphere/${f}-run.out"
	      ./MMoM_4.1.12 ${f}.geo > sphere/${f}-run.out
	mv ${f}.geo      sphere/.
	mv ${f}.4112.txt sphere/.
	rm ${f}.facet
done

new_step "Exit"
echo "time used = ${SECONDS} s"
date
