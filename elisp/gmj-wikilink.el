(defun gmj-word-to-wikipedia-linkify ()
  "Make the current word or text selection into a org mode Wikipedia link.

For Example: 「Emacs」 ⇒ [[http://en.wikipedia.org/wiki/Emacs][Emacs]]

Adapted from From http://xahlee.blogspot.com/2014/10/emacs-lisp-change-current-word-to.html" 
  (interactive)
  (let (linkText bds p0 p1 p2 wikiTerm resultStr)

    (if (region-active-p)
        (progn
          (setq p1 (region-beginning))
          (setq p2 (region-end)))
      (progn
        (setq p0 (point))
        (skip-chars-backward "^ \t\n")
        (setq p1 (point))
        (goto-char p0)
        (skip-chars-forward "^ \t\n")
        (setq p2 (point))))

    (setq linkText (buffer-substring-no-properties p1 p2))
    (setq wikiTerm (replace-regexp-in-string " " "_" linkText))
    (setq resultStr (concat "[[http://en.wikipedia.org/wiki/" wikiTerm "][" linkText "]]"))
    (delete-region p1 p2)
    (insert resultStr)))
