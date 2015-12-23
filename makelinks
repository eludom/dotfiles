#! /bin/bash
#
# Link files from this directory into $HOME
#

set -e -u

linkTo=$HOME
linkThese=( .bashrc .gitconfig bin)
link2=./bin/link2

for linkThis in ${linkThese[@]}; do
  ${link2} $linkThis $linkTo
done
