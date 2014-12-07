(defun gmj-org-demote (howManyTimes)
  "demote current and next /howManyTimes/ -1 org mode elements.

  TODO List
    - Operate on region
    - Need error handling on (org-forward-element) with negagive counts.
     Starting on '**** a' below with a negative 2 count returns an error

     * one
     ***** a
     ***** b
     * c
     * two
  "
  
  (interactive "p")
  (let ((count 0))
    (while (< count (abs howManyTimes))
      (progn
	(if (< howManyTimes 0)
	    (org-promote-subtree)
	  (org-demote-subtree))
        (message "org-forward-element")
	(org-forward-element)
        (message "incr count")
	(setq count (+ count 1))))))





