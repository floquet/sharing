#! /bin/bash
printf '%s\n' "$(date), ${BASH_SOURCE[0]}"

# primitive file to run spack

echo "Clone spack"
git clone https://github.com/spack/spack.git

echo "cd into spack directory"
cd spack

echo "initialize spack"
. share/spack/setup-env.sh

echo "install latest gcc compiler suite"
spack install gcc

echo "add gcc compilers to spack tools"
spack compiler find ${spack location -i gcc@14.1}

echo "add gcc compilers to spack tools"
spack load gcc@14.1.0

echo "install hwloc"
spack install hwloc
