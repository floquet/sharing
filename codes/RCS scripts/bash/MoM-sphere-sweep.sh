#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

export diameter="005"
# timestamp results
export stem="sphere-d${diameter}"
export ymd=$(date +%Y-%m-%d-%H-%M)
export myFile="/Tlaloc/Mercury-MoM/times/time-${stem}-${ymd}.txt"
date > ${myFile}
pwd >> ${myFile}
echo "" >> ${myFile}

export SECONDS=0
# resolutions
for index in {01..02}; do
    dirOutput="/Tlaloc/Mercury-MoM/library/sphere/${diameter}m/MoM/resolution-${index}"
    mkdir -p ${dirOutput}
    export indexSECONDS=${SECONDS}
    export facetfilename="${stem}-${index}"
    # radar frequencies"
    for frequency in {3..30}; do
        export nuSECONDS=${SECONDS}
        nu=$(printf "%02d\n" ${frequency})
        # generate geometry file
        export   geofilename="${stem}-${index}-${nu}.geo"
        echo "cp tabula-rasa.geo ${geofilename}"
              cp tabula-rasa.geo ${geofilename}
        # customize geometry file
        sed -i 's/ego/'${stem}-${index}'/'     ${geofilename}
        sed -i 's/myFacet/'${facetfilename}'/' ${geofilename}
        sed -i 's/nu-mhz/'${frequency}'.000/g' ${geofilename}
        # Hg MoM
        # echo "./MMoM_4.1.12 ${geofilename}"
        #       ./MMoM_4.1.12 ${geofilename}
        echo "mv ${stem}-${index}-${nu}.4112.dat ${stem}-${index}-${nu}.4112.dat.txt"
              mv ${stem}-${index}-${nu}.4112.dat ${stem}-${index}-${nu}.4112.dat.txt
        echo "Resolution level ${index}, nu = ${nu}, time = $((SECONDS-nuSECONDS)) s" >> ${myFile}
    done
    echo "mv ${stem}-${index}*.* ${dirOutput}/."
          mv ${stem}-${index}*.* ${dirOutput}/.
    echo "Resolution level ${index}, time = $((SECONDS-indexSECONDS)) s" >> ${myFile}
    echo "" >> ${myFile}
done
    echo "Total time = ${SECONDS} s" >> ${myFile}

echo "Time: ${SECONDS} seconds"
