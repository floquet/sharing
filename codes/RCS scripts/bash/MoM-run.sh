#!/bin/bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

# counts steps in batch process
export counter=0
export SECONDS=0
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

new_step "Identify source files"
export stem="B-20A"
facets="${stem}-S-1000m ${stem}-S-0100m ${stem}-S-0050m ${stem}-S-0010m"
echo "\${facets} = ${facets}"

new_step "cd ${mom}"
          cd ${mom}

for f in ${facets}; do
	new_step "Run ${f}"
	cp ${stem}/template-${stem}.geo ${f}.geo
	cp ${stem}/${f}.facet .
	sed -i 's/FILE_A/'${f}'/'       ${f}.geo
	sed -i 's/FILE_B/'${f}'.facet/' ${f}.geo
	echo "./MMoM_4.1.12 ${f}.geo > ${stem}/${f}-run.out"
	      ./MMoM_4.1.12 ${f}.geo > ${stem}/${f}-run.out
	mv ${f}.geo      ${stem}/.
	mv ${f}.4112.txt ${stem}/.
	rm ${f}.facet
done

new_step "Exit"
echo "time used = ${SECONDS} s"
date
