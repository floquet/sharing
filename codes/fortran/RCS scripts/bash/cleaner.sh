#! /bin/bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

echo "rm -r ../tempdir"
      rm -r ../tempdir

echo "rm ../*.txt"
      rm ../*.txt

#echo "rm ../*.obj"
#      rm ../*.obj
