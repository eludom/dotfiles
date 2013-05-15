(message "in .init.el")

; Adapted from: http://orgmode.org/worg/org-contrib/babel/intro.html#sec-8-2-1

;;; init.el --- Where all the magic begins
;;
;; This file loads Org-mode and then loads the rest of our Emacs initialization from Emacs lisp
;; embedded in literate Org-mode files.

;; Load up Org Mode and (now included) Org Babel for elisp embedded in Org Mode files
(setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))

;(let* ((org-dir (expand-file-name
;                 "lisp" (expand-file-name
;                         "org" (expand-file-name
;                                "src" dotfiles-dir))))
;       (org-contrib-dir (expand-file-name
;                         "lisp" (expand-file-name
;                                 "contrib" (expand-file-name
;                                            ".." org-dir))))
;       (load-path (append (list org-dir org-contrib-dir)
;                          (or load-path nil))))
;  ;; load up Org-mode and Org-babel
;  (require 'org-install)
;  (require 'ob-tangle))

(require 'org)
;(require 'org-install)
;(require 'ob-tangle)
;; load up all literate org-mode files in this directory
(mapc #'org-babel-load-file (directory-files dotfiles-dir t "\\.org$"))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(org-ditaa-jar-path "/Users/gmj/elisp/old/org-mode/contrib/scripts/ditaa.jar"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 240 :width normal :foundry "apple" :family "Monaco")))))
