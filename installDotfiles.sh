#! /bin/bash -e -u
#
# Install my dotfiles on a new system
#
# run this in dotfiles/ after git clone of git@github.com:eludom/dotfiles.git

export DOTFILES=$PWD

cd $HOME

if [ -f .bashrc ]; then
  mv .bashrc .bashrc.$$.old
fi
ln -s ${DOTFILES}/.bashrc .

ln -s ${DOTFILES}/.bashrc .  
ln -s ${DOTFILES}/bin .
ln -s ${DOTFILES}/lisp .
ln -s ${DOTFILES}/emacs.d .



