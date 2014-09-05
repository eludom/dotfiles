; http://irreal.org/blog/?p=2247

(defun net-utils-restore-windows ()
  "Restore windows and clean up after ping."
  (interactive)
  (kill-buffer (current-buffer))
  (jump-to-register :net-utils-full screen))

(defadvice net-utils-run-program (around net-utils-big-page activate)
  (window-configuration-to-register :net-utils-fullscreen)
  (let ((buf ad-do-it))
    (switch-to-buffer buf)
    (delete-other-windows)
    (set-temporary-overlay-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "q") 'net-utils-restore-windows)
        map))
    (message "Type \"q\" to restore other windows.")))
