#! /bin/bash
#
# Link dotifles and bin into $HOME
#

set -e -u

# Get the path to this (install.sh) script.
#   See http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


# ~/bin will be an actual directory because in different contexts and
# scopes with different projects/people it might have
# different/additional things.

mkdir -p $HOME/bin

bin/link2 -r bin/link2 ~/bin/link2
bin/link2 -r bin/linkall ~/bin/linkall

# link the rest of bin/

~/bin/linkall $DIR/bin ~/bin/

# link .dotfiles  into ~

linkTo=$HOME
linkThese=( .bashrc )
link2=./bin/link2

for linkThis in ${linkThese[@]}; do
  ${link2} -r $linkThis $linkTo
done
