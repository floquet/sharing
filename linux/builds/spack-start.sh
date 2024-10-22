#! /bin/bash
printf '%s\n' "$(date), ${BASH_SOURCE[0]}"

echo "Clone spack"
git clone -c feature.manyFiles=true https://github.com/spack/spack.git

echo "cd into spack directory"
cd spack

echo "initialize spack"