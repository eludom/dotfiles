
(global-set-key (kbd "C-x # i") 'ifdef-ifdef)
(global-set-key (kbd "C-x # d") 'ifdef-define)
(global-set-key (kbd "C-x # b") 'ifdef-buffer)

; define global config things for ifdef.
; I'm pretty sure global setq is not the right way...

; set one of these
(setq ifdef-delete-chunks t) ;  delete non-matching chunks
(setq ifdef-comment-chunks nil) ;  delete non-matching chunks
(setq comment-start "#")

(defun my-text-mode-hook ()
  (setq comment-start "#")
  ; (message "my-text-mode-hook ran.")
  )

(add-hook 'text-mode-hook 'my-text-mode-hook)

(defun ifdef-org-export-hook ()
  "Export hook to apply #ifdef logic to buffer during org-mode export"
  (interactive)
  (setq ifdef-delete-chunks t) ;  delete non-matching chunks
  (ifdef-buffer)
  (ifdef-delete-all-ifdef-lines)
)

(defun ifdef-buffer ()
  "Apply cpp-like #ifdef processing to current buffer."
  (interactive)

  (ifdef-define)
  (goto-char (point-min))
  (while (ifdef-ifdef) nil)
  (ifdef-delete-all-ifdef-lines)
)


(defun ifdef-delete-all-ifdef-lines ()
  "Delete all #define, #ifdef, and #endif lines in the current buffer"
  (interactive)

  (goto-char (point-min))

  (while (re-search-forward "^\\s\-\*#\\(ifdef\\|define\\|endif\\)" nil t)
    (setq pos1 (line-beginning-position) )
    (forward-line 1)
    (beginning-of-line)
    (setq pos2 (line-beginning-position) )
    (delete-region pos1 pos2)
  )
)

(defun ifdef-define ()
  "Find #ifdef FOO. (setq ifdef-condition FOO).  FOO can be an elisp regexp.

e.g.  #define \(interesting\|contributions\)"
  (interactive)
  (setq ifdef-condition nil)

  (let ((case-fold-search t))
    (save-excursion 
      (goto-char (point-min))
      ; first #define wins
      (if (search-forward-regexp "^\\s\-\*\\(#define\\) \\(.*$\\)" nil t) (setq ifdef-condition (match-string 2)))
    ) ; save-excursion
  ) ;let

   (message (concat (concat "ifdef-condition is \"" ifdef-condition) "\""))
  ifdef-condition
)

(defun ifdef-ifdef ()
  "Delete the next non-matching #ifdef section.

Find ifdef FOO. Cut it out if conditional not defined.
Return t if #ifdef section found (matching or not), nil if not found or no pattern."

  (interactive)
  (catch 'exit
    ; (message "ifdef-ifdef")
    (let ((case-fold-search t))
      (if (boundp 'ifdef-condition)
          (progn ; true
          (setq ifdef-look-for-this (concat "#ifdef " ifdef-condition))
          ; (message (concat "ifdef-look-for-this " ifdef-look-for-this))
          )
          (progn ; false
            (message "ifdef-condition not defined")
          (throw 'exit nil)
          )
      )
      (setq ifdef-found-ifdef-section nil)
  
      ; (message "ifdef-ifdef continue")
      (let (beg end (cnt 1) ifdefChunk)
  ;      (save-excursion
         (progn
           ; (message "ifdef-ifdef looking for chunk to delete")
        (when (re-search-forward
               "^\\s\-\*#ifdef" nil t)
  
          (setq beg (match-beginning 0))
          (while (re-search-forward "^\\s\-\*#endif" nil t)
            (setq ifdef-chunk (buffer-substring beg (point)))
            ; (message (concat "ifdef-chunk-START>" ifdef-chunk "<ifdef-chunk-END"))
            ; (message (concat "ifdef-look-for-this " ifdef-look-for-this))
            (setq ifdef-found-ifdef-section t)
            (setq ifdef-delete-or-comment-this-chunk nil)

            (when (not (string-match ifdef-look-for-this ifdef-chunk))
              (setq ifdef-delete-or-comment-this-chunk t))
              ; (message "ifdef-delete-or-comment-this-chunk")
              (if ifdef-delete-or-comment-this-chunk
                  (if ifdef-delete-chunks ; if delete-chunks
                      (progn ; if delete chunks
                        ; (message "deleting chunk")
                        (delete-region beg (point))
                           ; now get rid of any resulting blank lines
  
                        (setq ifdef-this-line-is-blank (looking-at "[ \t]*$"))
                        (setq ifdef-this-line-is-blank t)
                        (if ifdef-this-line-is-blank
                            (delete-blank-lines); collapse surrounding bank lines to one
                        )  
                      )
                      (if ifdef-comment-chunks ; else if comment chunks
                          (progn 
                            (comment-region beg (point))
                          ) 
                      ) ; if commenting this chunk
                   ) ; if deleting this chunk
               ) ; if commenting or deleting this chunk

            (throw 'exit ifdef-found-ifdef-section)))
        nil)))))