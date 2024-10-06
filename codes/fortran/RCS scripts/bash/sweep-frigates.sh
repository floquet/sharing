#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

export stem="frigate-mefisto-A"
export ymd=$(date +%Y-%m-%d-%H-%M)
export pwd=$(pwd)
export who="${BASH_SOURCE[0]}"

echo "\${ymd} = ${ymd}"
echo "\${pwd} = ${pwd}"

# sweep radar frequencies
for frequency in {3..30}; do
    nu=$(printf "%02d\n" ${frequency})
    # IO files
    export   geofilename="${stem}-${nu}.geo"
    export facetfilename="${stem}"
    # update facet file
    echo "cp frigate.facet ${stem}.facet"
          cp frigate.facet ${stem}.facet
    # grab a new template
    echo "cp tabula-rasa.geo ${geofilename}"
          cp tabula-rasa.geo ${geofilename}
    # customize template
    sed -i 's/ego/'${stem}'/'              ${geofilename}
    sed -i 's/myFacet/'${facetfilename}'/' ${geofilename}
    sed -i 's/nu-mhz/'${frequency}'.000/g' ${geofilename}
    sed -i 's/Fiducial-run/'${ymd}'/'      ${geofilename}

    echo ""
    echo "./MMoM_4.1.12 ${geofilename}"
          ./MMoM_4.1.12 ${geofilename}

    echo "mv frigate-* results/."
          mv frigate-* results/.
done
