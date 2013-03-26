(message "in myOrgHacks.el")

(defun org-my-get-current-options ()
  "Return a string with current options as keyword options.
Does include HTML export options as well as TODO and CATEGORY stuff."
  (require 'org-archive)
  (format
   "#+TITLE:     %s
#+AUTHOR:    %s
#+EMAIL:     %s
#+DATE:      %s
#+DESCRIPTION:
"
;   (buffer-name) (user-full-name) user-mail-address
   (buffer-name) (user-full-name) "gmj@cert.org"
   (format-time-string (substring (car org-time-stamp-formats) 1 -1))
   org-export-with-toc
   ))

;
; Overrride default org-insert-export-options-template ()
; Only insert the fields I want.
;

(defun org-insert-export-options-template ()
  "Overridden Fuction by gmj.  Insert into the buffer a template with information for exporting."
  (interactive)
  (if (not (bolp)) (newline))
  (let ((s (org-my-get-current-options)))
    (and (string-match "#\\+CATEGORY" s)
	 (setq s (substring s 0 (match-beginning 0))))
    (insert s)))

(provide 'emacs-rc-override)
