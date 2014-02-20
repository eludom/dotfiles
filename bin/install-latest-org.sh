#! /bin/bash 
set -x -u
date
cd ~
mkdir -p ~/src
cd ~/src
set +x # errors OK
git clone git://orgmode.org/org-mode.git 2>&1
set -x
ls -r -d -1 $PWD/{*,.*}
