(message "in .init.el")

; Adapted from: http://orgmode.org/worg/org-contrib/babel/intro.html#sec-8-2-1

; To set up org mode
;
; $ mkdir -p ~/src
; $ cd ~/src/
; $ git clone git://orgmode.org/org-mode.git
					; $ make autoloads

; workaround? from: http://lists.gnu.org/archive/html/emacs-orgmode/2013-11/msg00174.html
(defun org-element-cache-reset (&optional all) (interactive))

; standard eamcs.d stuff first
(add-to-list 'load-path "~/.emacs.d/orgified-init")

;;; init.el --- Where all the magic begins
;;
;; This file loads Org-mode and then loads the rest of our Emacs initialization from Emacs lisp
;; embedded in literate Org-mode files.

;; Load up Org Mode and (now included) Org Babel for elisp embedded in Org Mode files
;(setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))
(setq dotfiles-dir "~/.emacs.d/orgified-init")

; Set up basic org-mode stuff here because the rest of this init file
; is going to use org

(add-to-list 'load-path (expand-file-name "~/src/org-mode/lisp/"))
(add-to-list 'load-path (expand-file-name "~/src/org-mode/contrib/lisp/"))

;; Set up Info directory to point to installed docs
;; INFOPATH hack from http://www.emacswiki.org/emacs/InfoPath
(setenv "INFOPATH" (concat
		    (expand-file-name "~/src/org-mode/doc/")
		    ":"
		    (getenv "INFOPATH")
		    )
	)
(add-hook 'Info-mode-hook; After Info-mode has started
        (lambda ()
	      (setq Info-additional-directory-list Info-default-directory-list)
	      ))
(require 'org)
(require 'org-install)
(require 'ob-tangle)
(require 'ox-bibtex)
;; load up all literate org-mode files in this directory
(mapc #'org-babel-load-file (directory-files dotfiles-dir t "\\.org$"))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (manoj-dark)))
 '(display-time-mode t)
 '(doc-view-continuous t)
 '(major-mode (quote org-mode))
 '(org-agenda-files
   (quote
    ("~/projects/current/network/201411_homeNetworkAndSystemsTodoList.org")))
 '(org-contacts-files (quote ("~/Org/contacts.org")))
 '(org-ditaa-jar-path "/Users/gmj/src/org-mode/contrib/scripts/ditaa.jar")
 '(send-mail-function (quote smtpmail-send-it))
 '(user-mail-address "gmj@pobox.com"))
(put 'upcase-region 'disabled nil)

; load specific files

;(load "bibhook.el")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
