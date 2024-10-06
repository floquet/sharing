#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

export stem="PTW-default"
# timestamp results
export facetfilename="PTW-default.facet"
export ymd=$(date +%Y-%m-%d-%H-%M)
date > ${myFile}
pwd >> ${myFile}
echo "" >> ${myFile}

export SECONDS=0
# resolutions
for elevation in {0..45..5}; do
    export indexSECONDS=${SECONDS}
    export facetfilename="${stem}"
    alpha=$(printf "%02d\n" ${elevation})
    # radar frequencies"
    for frequency in {3..30}; do
        export nuSECONDS=${SECONDS}
        nu=$(printf "%02d\n" ${frequency})
        # generate geometry file
        export   geofilename="${stem}-${alpha}-${nu}.geo"
        echo "cp ptw-tabula-rasa.geo ${geofilename}"
              cp ptw-tabula-rasa.geo ${geofilename}
        # customize geometry file
        sed -i 's/ego/'${stem}'/'                  ${geofilename}
        sed -i 's/myFacet/'${facetfilename}'/'     ${geofilename}
        sed -i 's/nu-mhz/'${frequency}'.000/g'     ${geofilename}
        sed -i 's/elev-angle/'${elevation}'.000/g' ${geofilename}
        # Hg MoM
        echo "./MMoM_4.1.12 ${geofilename}"
              ./MMoM_4.1.12 ${geofilename}
        echo "mv ${stem}-${alpha}-${nu}.* /Tlaloc/Mercury-MoM/PTW/elevations/angle-${alpha}/."
              mv ${stem}-${alpha}-${nu}.* /Tlaloc/Mercury-MoM/PTW/elevations/angle-${alpha}/.
        echo "Resolution level ${index}, nu = ${nu}, time = $((SECONDS-nuSECONDS)) s" >> ${myFile}
    done
    echo "Resolution level ${index}, time = $((SECONDS-indexSECONDS)) s" >> ${myFile}
    echo "" >> ${myFile}
done
    echo "Total time = ${SECONDS} s" >> ${myFile}

echo "Time: ${SECONDS} seconds"
