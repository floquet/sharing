#! /bin/bash
printf '%s\n' "$(date), ${BASH_SOURCE[0]}"

echo "Clone spack"
git clone https://github.com/spack/spack.git

echo "cd into spack directory"
cd spack

echo "initialize spack"
. share/spack/setup-env.sh

echo "install latest gcc compiler suite"
spack install gcc

echo "add gcc compilers to spack tools"
spack compiler find ${spack location -i gcc}
