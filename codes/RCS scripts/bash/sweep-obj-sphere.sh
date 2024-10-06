#! /bin/bash
printf '%s\n' "$(date) ${BASH_SOURCE[0]}"

export SECONDS=0
export counter=0
function new_step(){
    counter=$((counter+1))
    echo ""
    echo "Step ${counter}: ${1}"
}
export vault="/Tlaloc/Mercury-MoM/zeta/sphere/"
export models="sphere-010-00.obj sphere-010-01.obj sphere-010-02.obj sphere-010-03.obj sphere-010-04.obj sphere-010-05.obj sphere-010-06.obj sphere-010-07.obj sphere-100-00.obj sphere-100-01.obj sphere-100-02.obj sphere-100-03.obj sphere-100-04.obj sphere-100-05.obj" # sphere-100-06.obj"
export models="${models} sphereCoarse.obj sphereFine.obj sphereSuperFine.obj"

for m in ${models}; do
    new_step "./facimusFacet-centos7 ${vault}${m} &"
              ./facimusFacet-centos7 ${vault}${m} &
done

wait

new_step "Execution complete"
echo ""; echo "time used = ${SECONDS} s"
date
