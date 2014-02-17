#! /bin/bash
sudo add-apt-repository ppa:cassou/emacs
sudo apt-get update
sudo apt-get purge emacs emacs-snapshot-common emacs-snapshot-bin-common emacs-snapshot emacs-snapshot-el emacs-snapshot-gtk emacs23 emacs23-bin-common emacs23-common emacs23-el emacs23-nox emacs23-lucid auctex apel emacs24 emacs24-bin-common emacs24-common emacs24-common-non-dfsg emacs24-el
sudo apt-get install emacs-snapshot-el emacs-snapshot-gtk emacs-snapshot
