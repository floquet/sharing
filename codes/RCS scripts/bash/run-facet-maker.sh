#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

export objs="me-1.00 me-10.00 me-4.45 ng-coarse ng-fine ng-moderate ng-very-fine st-0.005 st-0.01 st-0.10 st-1.00"

for o in ${objs}; do
    ./createFacetFile ${o}.obj
done
