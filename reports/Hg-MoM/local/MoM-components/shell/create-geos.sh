#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

export stem="sphere-050"
export ymd=$(date +%Y-%m-%d-%H-%M)
export pwd=$(pwd)
export who="${BASH_SOURCE[0]}"

echo "\${ymd} = ${ymd}"
echo "\${pwd} = ${pwd}"

# sweep resolutions
for index in {01..07}; do
    # sweep radar frequencies
    for frequency in {3..30}; do
        nu=$(printf "%02d\n" ${frequency})
        # IO files
        export   geofilename="${stem}-${index}-${nu}.geo"
        export facetfilename="${stem}-${index}"
        # grab a new template
        echo "cp tabula-rasa.geo ${geofilename}"
              cp tabula-rasa.geo ${geofilename}
        # customize template
        sed -i 's/ego/'${stem}-${index}'/'     ${geofilename}
        sed -i 's/myFacet/'${facetfilename}'/' ${geofilename}
        sed -i 's/nu-mhz/'${frequency}'.000/g' ${geofilename}
        sed -i 's/Fiducial-run/'${ymd}'/'      ${geofilename}
    done
done
