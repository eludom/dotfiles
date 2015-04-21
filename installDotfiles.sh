#! /bin/bash
#
# Usage:
#  installDotFiles [install|delete|list]
#
# Install my dotfiles on a new system. 
#
# Symlink everything from ~/ to ~/git/dotfiles/
#

set -u -e

if [ $# -eq 0 ]; then
    op="install"
elif [ $# -eq 1 ]; then
    op=$1
else
    echo too many aruments
    echo usage: $0 [install|delete|list]
    exit
fi

DOTFILES=~/git/dotfiles
NOW=`date "+%Y-%m-%d:%H:%M:%S"`

if [ ! -d ${DOTFILES} ]; then
    echo "installing dotfiles from github"

    cd ~
    mkdir -p git
    cd git
    git clone git://github.com/eludom/dotfiles.git
fi


# install

linkThese=(elisp .emacs.d)
#linkThese=( .bashrc .gitconfig bin elisp .emacs.d)
cd ~


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

# list

elif [ "$op" == "list" ]; then
  for linkThis in ${linkThese[@]}; do
    if [ -e ~/${linkThis} ]; then
	file ~/${linkThis}
    else
	echo ~/${linkThis} does not exist
    fi
  done

else
  echo bad option $op. Should be one of insall or delete
fi





