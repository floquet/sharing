# #!/bin/zsh
# https://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
#printf '%s\n' "$(date) $(tput bold)${(%):-%N}$(tput sgr0)"

#!/bin/bash
printf "%s\n" "$(date), $(tput bold)${BASH_SOURCE[0]}$(tput sgr0)"

echo "ulimit -s unlimited"
      ulimit -s unlimited

echo "export OMP_NUM_THREADS=10"
      export OMP_NUM_THREADS=10

echo 'export LD_LIBRARY_PATH="/Users/dantopa/Dropbox/2nd-generation/RCS-project/Mercury MOM/MM_Distribution_4.1.12/Linux64/redistributables/":${LD_LIBRARY_PATH}'
      export LD_LIBRARY_PATH="/Users/dantopa/Dropbox/2nd-generation/RCS-project/Mercury MOM/MM_Distribution_4.1.12/Linux64/redistributables/":${LD_LIBRARY_PATH}


echo "\${OMP_NUM_THREADS} = ${OMP_NUM_THREADS}"
echo "\${LD_LIBRARY_PATH} = ${LD_LIBRARY_PATH}"

