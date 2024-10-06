#!/bin/bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

export OMP_NUM_THREADS=10
export LD_LIBRARY_PATH="/usr/lib64":"$(pwd)":"${LD_LIBRARY_PATH}"

echo "ulimit = $(ulimit)"
echo "\${OMP_NUM_THREADS} = ${OMP_NUM_THREADS}"
echo "\${LD_LIBRARY_PATH} = ${LD_LIBRARY_PATH}"

