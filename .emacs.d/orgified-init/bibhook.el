; See  http://comments.gmane.org/gmane.emacs.orgmode/74598

  (defun my-bibliography-selector-hook (backend)
    "Delete the #+BIBLIOGRAPHY: lines when exporting to latex.  For use with ox-bibtex.el"
    (progn
;    (message "in my-bibliography-selector-hook2")
    (case backend
      (latex
       (progn
;       (message "latex hook")
       (goto-char (point-min))
       (while (re-search-forward "^[ \t]*.+BIBLIOGRAPHY:.*$" nil t) (replace-match "")))))))

  (add-hook 'org-export-before-parsing-hook 'my-bibliography-selector-hook)
