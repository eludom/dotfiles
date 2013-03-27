; $Id: .emacs,v 1.5 2008/09/30 08:36:53 george Exp george $
;
; George Jones <gmj@pobox.com> .emacs 
;
; $Log: .emacs,v $
; Revision 1.5  2008/09/30 08:36:53  george
; Added acient things
;
; Revision 1.4  2008/09/30 08:20:46  george
; test3
;

;
; My (gmj) stuff from ages past...
;

;
; define useful functions
;

(defun insert-date ()
  "Insert current date and time in buffer"
  (interactive)
  (insert-string (current-time-string))
)

(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;
; Global key bindings
;

(global-set-key "\C-Xd" 'insert-date)
(global-set-key "\C-\\" 'compile)
(global-set-key "\C-XP" 'plan)
(global-set-key "\C-XR" 'gnus)
(global-set-key "\C-XW" 'w3m)
(global-set-key "\C-]" 'call-last-kbd-macro)
(global-set-key "\eq" 'query-replace)

(global-set-key "\er" 'replace-string)
(global-set-key "\em" 'set-mark-command)
(global-set-key "\e " 'set-mark-command)
(global-set-key "\e#" 'what-line)
(global-set-key "\eg" 'goto-line)
(global-set-key "\ei" 'ispell-buffer)
(global-set-key "\C-X\C-K" 'bury-buffer)
(global-set-key "\C-he" 'emacs-version)
(global-set-key "\C-Xp" 'fill-paragraph)
(global-set-key "\C-Xc" 'copy-region-as-kill)
(global-set-key "\C-X!" 'compile)
(global-unset-key "\C-X\C-l")

; General font stuff

(set-default-font "12x24")
;(set-background-color "AntiqueWhite")
;(set-foreground-color "Black")

;;; Add some components to emacs' path
(setq load-path (append (list (concat (getenv "HOME") "/.lisp"))
			load-path))

;
; Package setup - planner
;


     (setq planner-project "WikiPlanner")

     (setq muse-project-alist
           '(("WikiPlanner"
              ("~/Plans"           ;; where your Planner pages are located
               :default "TaskPool" ;; use value of `planner-default-page'
               :major-mode planner-mode
               :visit-link planner-visit-link)

              ;; This next part is for specifying where Planner pages
              ;; should be published and what Muse publishing style to
              ;; use.  In this example, we will use the XHTML publishing
              ;; style.

              (:base "planner-xhtml"
                     ;; where files are published to
                     ;; (the value of `planner-publishing-directory', if
                     ;;  you have a configuration for an older version
                     ;;  of Planner)
                     :path "~/public_html/Plans"))))

'
;     (add-to-list 'load-path "/usr/share/emacs22/site-lisp/muse-el/")
;     (add-to-list 'load-path "/path/to/planner")
;     (add-to-list 'load-path "/path/to/remember")

     (require 'planner)

; mail setings

;(setq user-full-name "George M Jones")
;(setq user-mail-address "eludom@gmail.com")

;(setq user-mail-replyto-address "gmj@port111.com")

;(setq mail-default-reply-to "gmj@PObox.com")

;
;
; Acient things from UUNET (and before ???)
;
;
;;
;; HTML Editing setup
;;
;
;;(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))
;;(setq html-helper-do-write-file-hooks t)
;;(setq html-helper-build-new-buffer t)
;;(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;
;;(set-background-color "black")
;
;
;;
;; Stuff from lamour@uu.net...
;;
;
;;(setq debug-on-error t)
;
;;; Enable the commands `narrow-to-region' ("C-x n n") and 
;;; `eval-expression' ("M-ESC", or "ESC ESC").  Both are useful
;;; commands, but they can be confusing for a new user, so they're
;;; disabled by default.
;(put 'narrow-to-region 'disabled nil)
;(put 'eval-expression 'disabled nil)
;(put 'downcase-region 'disabled nil)
;
;;; Set some sensible defaults
;(setq inhibit-startup-message t
;      require-final-newline t
;      default-major-mode 'text-mode
;      text-mode-hook 'turn-on-auto-fill
;      describe-function-show-arglist t)
;
;;; Make all modifiers behave like ESC does
;;(setq modifier-keys-are-sticky t)
;
;;; Set some external commands
;;(setq explicit-shell-file-name "/usr/local/bin/zsh"
;;      grep-command "egrep")
;
;;;; Add some components to emacs' path
;;(setq load-path (append (list (concat (getenv "HOME") "/emacs/lisp"))
;;			load-path))
;(setq load-path (append (list (concat (getenv "HOME") "/lisp"))
;			load-path))
;(setq load-path (append (list (concat (getenv "HOME") "/lisp/sc"))
;			load-path))
;;(setq load-path (append (list (concat (getenv "HOME") "/lisp/gnus"))
;;			load-path))
;;(setq load-path (append (list (concat (getenv "HOME") "/lisp/custom"))
;;			load-path))
;
;;
;; Mail stuff
;;
;
;;;; ********************
;;;; (ding) gnus stuff moved to ~/.gnus
;;; mail settings
;(setq message-directory "~/mail/"
;      gnus-directory "~/news/"
;      message-autosave-directory "~/mail/"
;;      mail-host-address "opal.he.net"
;;      message-default-headers (concat "Reply-To: " (user-login-name) "@uu.net\n"))
;      message-default-headers (concat "Reply-To: " "gmj" "@pobox.com\n"))
;
;
;;; Supercite
;(autoload 'sc-cite-original     "supercite" "Supercite 3.1" t)
;(autoload 'sc-cite "supercite" "Supercite 3.1" t)
;(setq mail-yank-hooks 'sc-cite-original)
;(setq sc-downcase-p t)
;(setq sc-preferred-attribution-list
;      '("sc-lastchoice" "x-attribution" "sc-consult" 
;	"initials" "firstname" "lastname"))
;

;; Found this config here:                                                  
;; http://www.emacswiki.org/cgi-bin/wiki/JorgenSchaefersEmacsConfig         
(defun fc-choose-browser (url &rest args)                                   
  (interactive "sURL: ")                                                    
  (if (y-or-n-p "Use external browser? ")                                   
      (browse-url-generic url)                                              
    (w3m-browse-url url)))                                                  

(setq browse-url-browser-function 'fc-choose-browser)                       
(global-set-key "\C-xm" 'browse-url-at-point)                               