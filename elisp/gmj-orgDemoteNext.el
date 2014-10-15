(defun gmj-org-demote (howManyTimes)
  "demote current and next /howManyTimes/ -1 org mode elements.
  "
  (interactive "p")
  (let ((count 0))
    (while (< count howManyTimes)
      (progn
	(message "foo")
	(org-demote-subtree)
	(org-forward-element)
	(setq count (+ count 1))))))


