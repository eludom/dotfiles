;;
;; Install package from command line. Example:
;;
;;   $ emacs --batch --expr "(define pkg-to-install 'smex)" -l emacs-pkg-install.el
;;
;; From 
;;   http://hacks-galore.org/aleix/blog/archives/2013/01/08/install-emacs-packages-from-command-line

(require 'package)
(package-initialize) 

(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; Fix HTTP1/1.1 problems
(setq url-http-attempt-keepalives nil)

(package-refresh-contents)

(package-install pkg-to-install)
