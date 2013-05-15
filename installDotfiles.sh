#! /bin/bash -e -u
#
# Install my dotfiles on a new system
#
# run this in dotfiles/ after git clone of git@github.com:eludom/dotfiles.git

DOTFILES=$PWD
NOW=`date "+%s"`

#if [ -f .bashrc ]; then
#  mv .bashrc .bashrc.$$.old
#fi
#ln -s ${DOTFILES}/.bashrc .

#ln -s ${DOTFILES}/.bashrc .  

#
# Link directories and files in directories to here
#

for dirName in [ bin elisp .emacs.d ]; do

    if [ -L ${HOME}/${dirName} ]; then
	# we already linked this.  Do nothing
	:
    elif [ -d ${HOME}/${dirName} ]; then
	: # this is a directory.  Link files that do not exist.

	cd ${dirName}

	for x in  * .[a-zA-Z]*; do
	    if [ ! -f ${HOME}/${dirName} ]; then
		ln -s $PWD/$x ${HOME}/${dirName}/$x
	    fi
	done

	cd ..
    else
	ln -s $PWD/$dirName $HOME
    fi

done

#
# Link individal files to to here
#
