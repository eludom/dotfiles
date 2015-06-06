#! /bin/bash
#
# Create a symlinks in ~ to a a list of things in the current directory. Save old versions.
#

set -e -u

REALDIR=`pwd`
mkdir -p ${REALDIR}
cd ${REALDIR}

now=`date "+%Y%m%d:%H%M"`

linkThese=( .bashrc .gitconfig bin)

for linkThis in ${linkThese[@]}; do

    if [ -e ~/${linkThis} ]; then
	mv ~/${linkThis} ~/${linkThis}.${now}
    fi

    ln -s ${REALDIR}/${linkThis} ~/${linkThis} 
done
