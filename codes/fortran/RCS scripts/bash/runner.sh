#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

for nu in {03..30}; do
    export new_stem="${stem}-${nu}"
    export filename="${new_stem}.geo"
    echo "./MMoM_4.1.12 ${filename}"
done
