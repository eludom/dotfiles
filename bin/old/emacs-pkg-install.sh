#!/bin/sh
# From 
#   http://hacks-galore.org/aleix/blog/archives/2013/01/08/install-emacs-packages-from-command-line


if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <package>"
  exit 1
fi

which emacs

emacs-snapshot --batch --eval "(defconst pkg-to-install '$1)" -l ~/elisp/emacs-pkg-install.el
