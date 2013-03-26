;
; George Jones .emacs file
;
; Tue Mar 26 19:24:39 2013

;
; Define useful functions
;

(defun chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
		       str)
    (setq str (replace-match "" t t str)))
  str)


(defun insert-date ()
  "Insert current date and time in buffer"
  (interactive)
  (insert-string (current-time-string))
)


; Set some sensible defaults
(setq inhibit-startup-message t
      require-final-newline t
      default-major-mode 'text-mode
      text-mode-hook 'turn-on-auto-fill
      describe-function-show-arglist t)

;
; My (gmj) stuff from ages past...


(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

(global-set-key "\C-Xd" 'insert-date)
(global-set-key "\C-\\" 'compile)
;(global-set-key "\C-XP" 'plan)
(global-set-key "\C-XR" 'gnus)
;(global-set-key "\C-XW" 'w3m)
(global-set-key "\C-]" 'call-last-kbd-macro)
(global-set-key "\eq" 'query-replace)
(global-set-key "\C-X5" 'split-window-horizontally)

(global-set-key "\er" 'replace-string)
(global-set-key "\em" 'set-mark-command)
(global-set-key "\e " 'set-mark-command)
(global-set-key "\e#" 'what-line)
(global-set-key "\eg" 'goto-line)
(global-set-key "\ei" 'ispell-buffer)
;(global-set-key "\C-X\C-K" 'bury-buffer)
(global-set-key "\C-he" 'emacs-version)
(global-set-key "\C-Xp" 'fill-paragraph)
(global-set-key "\C-Xc" 'copy-region-as-kill)
(global-set-key "\C-X!" 'compile)
(global-unset-key "\C-X\C-l")

; Determine Location

; these should be set by .bashrc

(setq myOS (getenv "myOS"))
(setq myLocation (getenv "myLocation"))
(setq myPublicIP (getenv "myPublicIP"))
(setq myPublicDomainName (getenv "myPublicDomainName"))
(setq myNoSuchVar (getenv "myNoSuchVar"))


(setq atHome nil)
(setq atWork nil)
(cond ((string-equal myLocation "home") (setq atHome t))
      ((string-equal myLocation "work") (setq atWork t))
      (t (message "Location Unknown"))
      )

(setq onMac nil)
(setq onUbuntu nil)
(cond ((string-equal myOS "mac") (setq onMac t))
      ((string-equal myOS "ubuntu") (setq onUbuntu t))
      (t (message "OS Unknown"))
      )

; Do work specific setup here
(if (file-exists-p "/Users/gmj/.emacs.atWork")
      (load "/Users/gmj/.emacs.atWork"))

; packages

(require 'package) (package-initialize) 
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

; load paths

; where do I find useful things?
;(add-to-list 'load-path (expand-file-name "~/lisp/"))
;(add-to-list 'load-path (expand-file-name "~/elisp/org-mode/lisp"))
;(add-to-list 'load-path (expand-file-name "~/elisp/org-mode/lisp"))
;(add-to-list 'load-path (expand-file-name "~/elisp/org-mode/contrib/oldexp"))
;(add-to-list 'load-path (expand-file-name "~/elisp/org-mode/contrib/lisp"))
;(add-to-list 'load-path (expand-file-name "~/elisp/tramp-2.2.6/lisp/"))


; bash comletion setup
;
; https://github.com/szermatt/emacs-bash-completion
;
(require 'bash-completion)
(bash-completion-setup)


; Location dependant things

(require 'tramp)

; Browser setup

; (setq browse-url-browser-function 'w3m-browse-url)
; (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
; ;; optional keyboard short-cut
; (global-set-key "\C-xm" 'browse-url-at-point)


; GNUS/mail setup

(setq mm-discouraged-alternatives '("text/html" "text/richtext"))
(setq gnus-inhibit-mime-unbuttonizing t)
(setq gnus-mime-display-multipart-related-as-mixed t)
(setq gnus-buttonized-mime-types
      '("multipart/alternative" "multipart/signed"))

(setq-default
 gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%)\n"
 gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M"))
 gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
 gnus-thread-sort-functions '(gnus-thread-sort-by-date)
 gnus-sum-thread-tree-false-root ""
 gnus-sum-thread-tree-indent " "
 gnus-sum-thread-tree-leaf-with-other "├► "
 gnus-sum-thread-tree-root ""
 gnus-sum-thread-tree-single-leaf "╰► "
 gnus-sum-thread-tree-vertical "│")

; org-mode settings

(require 'org-exp-bibtex)
(setq org-return-follows-link t)
(setq org-use-property-inheritance t)
(setq org-export-with-toc nil)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\M-\C-g" 'org-plot/gnuplot)
(setq org-agenda-include-diary t)
(setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS"  "|" "DONE" "WAITING" "DELEGATED" "CANCELED")))
(setq org-directory "~/plans/")

; org-mode babel settings

(require 'org-exp-blocks)
(org-babel-do-load-languages
    'org-babel-load-languages '((python . t) (sh . t) (lisp . t) (R . t) (ditaa . t)))
;(setq org-export-babel-evaluate n)
(setq org-confirm-babel-evaluate nil)
(setq org-babel-sh-command "bash")

; org-mode HTMLize email

(require 'org-mime)
(setq org-mime-library 'mml)
(add-hook 'message-mode-hook
          (lambda ()
            (local-set-key "\C-c\M-o" 'org-mime-htmlize)))
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "\C-c\M-o" 'org-mime-org-buffer-htmlize)))

(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "blockquote" "border-left: 2px solid gray; padding-left: 4px;")))  

(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "pre" (format "color: %s; background-color: %s; padding: 0.5em;"
                           "#E6E1DC" "#232323"))))
;
; Capture mode setup
;

(require 'org-contacts)
(require 'org-capture)

(setq org-directory "~/Org")
(setq org-default-notes-file "~/Org/refile.org")

;; I use C-M-r to start capture mode
;(global-set-key (kbd "C-M-r") 'org-capture)
(global-set-key (kbd "\C-cc") 'org-capture)
;; I use C-c r to start capture mode when using SSH from my Android phone
;(global-set-key (kbd "C-c r") 'org-capture)
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/Org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/Org/refile.org")
               "* TODO Respond to %:from on %:subject\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/Org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/Org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/Org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("p" "Phone call" entry (file "~/Org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/Org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(add-to-list 'org-capture-templates
             '("c" "Contacts" entry (file "~/Org/contacts.org")
               "* %(org-contacts-template-name)
                  :PROPERTIES:
                  :EMAIL: %(org-contacts-template-email)
                  :END:"))

;
; Load my stuff last.  May override defaults
;

(load "~/elisp/emacs-rc-override") 
(eval-after-load "org-exp" '(load "~/elisp/emacs-rc-override"))
(message ".emacs finished")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(display-time-mode t)
 '(org-agenda-files (quote ( "~/Org/refile.org")))
 '(org-contacts-files (quote ("~/Org/contacts.org")))
 '(org-ditaa-jar-path "/Users/gmj/elisp/org-mode/contrib/scripts/ditaa.jar")
 '(org-mime-default-header "#+OPTIONS: latex:t toc:nil
"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 250 :width normal :foundry "unknown" :family "Andale Mono")))))
; '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 200 :width normal :foundry "unknown" :family "Droid Sans Mono")))))

(put 'upcase-region 'disabled nil)

