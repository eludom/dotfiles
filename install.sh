#! /bin/bash
#
# Create a symlink in ~ to the current directory
#

set -e -u

REALDIR=`pwd`
mkdir -p ${REALDIR}
cd ${REALDIR}

now=`date "+%Y%m%d:%H%M"`

linkThese=( .bashrc .gitconfig bin)

for linkThis in ${linkThese[@]}; do

    if [ -e ~/${linkThis} ]; then
	echo mv ~/${linkThis} ~/${linkThis}.${now}
    fi

    echo ln -s ~/${linkThis} ${linkThis}
done
