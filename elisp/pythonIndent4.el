;; http://stackoverflow.com/questions/3684738/how-do-i-set-emacs-tab-size-to-4-chars-wide-for-py-files

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode t)
        (setq tab-width 4)
        (setq python-indent 4)))

