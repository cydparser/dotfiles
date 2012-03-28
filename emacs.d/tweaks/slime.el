;; slime

(when (file-exists-p (expand-file-name "slime" user-packages-directory))
  (setq slime-lisp-implementations
        '((sbcl ("/usr/local/bin/sbcl"))))
  (require 'slime-autoloads)
  (eval-after-load "slime"
    '(slime-setup '(slime-fancy slime-banner))))
