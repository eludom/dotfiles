#! /bin/bash
#
# Usage:
#  installDotFiles [install|delete]
#
# Install my dotfiles on a new system. 
#
# Symlink everything from ~/ to ~/git/dotfiles/
#

set -u -e -x

echo args $#

if [ $# -eq 0 ]; then
    op="install"
elif [ $# -eq 1 ]; then
    op=$1
else
    echo too many aruments
    echo usage: $0 [install|delete]
    exit
fi

DOTFILES=~/git/dotfiles
NOW=`date "+%Y-%m-%d:%H:%M:%S"`

if [ ! -d ${DOTFILES} ]; then
    echo "You need to install dotfiles from github first"
    cat <<EOF
cd ~

mkdir -p git
cd git
git clone git://github.com/eludom/dotfiles.git
    exit
EOF
fi

linkThese=( .bashrc .gitconfig bin elisp .emacs.d)

cd ~

# install

if [ "$op" == "install" ]; then

  for linkThis in ${linkThese[@]}; do
    if [ -L ~/${linkThis} ]; then
      :
    elif [ -f ~/${linkThis} ]; then
      mv ${linkThis} ${linkThis}.${NOW}.old
      ln -s ${DOTFILES}/${linkThis} .
    elif [ -d ~/${linkThis} ]; then
      mv ${linkThis} ${linkThis}.${NOW}.old
      ln -s ${DOTFILES}/${linkThis} .
    else
      ln -s ${DOTFILES}/${linkThis} .
    fi
  done

# delete

elif [ "$op" == "delete" ]; then
  for linkThis in ${linkThese[@]}; do
    if [ -L ~/${linkThis} ]; then
	rm ~/${linkThis}
    fi
  done
else
  echo bad option $op. Should be one of insall or delete
fi





