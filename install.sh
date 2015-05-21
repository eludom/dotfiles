#! /bin/bash
#
# Usage:
#  installDotFiles [install|delete|list]
#
# Install my dotfiles on a new system. 
#
# Symlink everything from ~/ to ~/git/github.com/eludom/dotfiles
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

GITREPO="git://github.com/eludom/dotfiles.git"
GITHUBDIR="${HOME}/git/github.com/eludom"
DOTFILES=${GITHUBDIR}/dotfiles

NOW=`date "+%Y-%m-%d:%H:%M:%S"`

if [ ! -d ${DOTFILES} ]; then
    echo "installing dotfiles from github"

    if [ -d GITHUBDIR ]; then
	cd ${GITHUBDIR}
	git pull ${GITREPO}
    else
	mkdir -p ${GITHUBDIR}
	cd ${GITHUBDIR}
	git clone ${GITREPO}
    fi
fi


# install

linkThese=( .bashrc .gitconfig bin)
cd ${HOME}


if [ "$op" == "install" ]; then

  for linkThis in ${linkThese[@]}; do
    if [ -L ${HOME}/${linkThis} ]; then
      rm ${HOME}/${linkThis} # always redo the link in case I move things
      ln -s ${DOTFILES}/${linkThis} .
    elif [ -f ${HOME}/${linkThis} ]; then
      mv ${linkThis} ${linkThis}.${NOW}.old
      ln -s ${DOTFILES}/${linkThis} .
    elif [ -d ${HOME}/${linkThis} ]; then
       mv ${linkThis} ${linkThis}.${NOW}.old
       ln -s ${DOTFILES}/${linkThis} .
    else
      ln -s ${DOTFILES}/${linkThis} .
    fi
  done

# delete

elif [ "$op" == "delete" ]; then
  for linkThis in ${linkThese[@]}; do
    if [ -L ${HOME}/${linkThis} ]; then
	rm ${HOME}/${linkThis}
    fi
  done

# list

elif [ "$op" == "list" ]; then
  for linkThis in ${linkThese[@]}; do
    if [ -e ${HOME}/${linkThis} ]; then
	file ${HOME}/${linkThis}
    else
	echo ${HOME}/${linkThis} does not exist
    fi
  done

else
  echo bad option $op. Should be one of insall or delete
fi





