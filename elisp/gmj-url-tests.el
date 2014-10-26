; Experiments with fetching URLs in elisp					;
;;; TODO
;;   - string-match returning length, properties, etc.  Just get sting.
;;   - clean up other-buffer-stuff (should wind up in buffer we started in)

; get some text from a url
(defun gmj-get-url (getThis)
  (with-current-buffer
      (url-retrieve-synchronously getThis)
    (prog1
	(buffer-string)
      (kill-buffer))))

; get contents of of a URL in other buffer
(defun gmj-get-url-in-buffer (getThis)
  (progn
    (switch-to-buffer-other-window "*getResults*")
    (erase-buffer)
    (insert (gmj-get-url getThis))
    (other-window 1)))


; get the HTTP status

(defun gmj-get-http-status (getThis)
    (gmj-get-url-in-buffer getThis)
    (switch-to-buffer-other-window "*getResults*")
    (goto-char (point-min))
    (if (re-search-forward "^HTTP/.*")
	(setq foo (match-string 0))
      (setq foo ("baz"))
      ))


(gmj-get-http-status "http://foo.com/")
#("HTTP/1.1 200 OK" 0 15 (fontified nil))

















