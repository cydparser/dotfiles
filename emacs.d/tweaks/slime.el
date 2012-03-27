;; Slime

; (autoload 'slime-selector "slime" t)
(require 'slime-autoloads)

(setq slime-lisp-implementations
  `((sbcl ("/usr/local/bin/sbcl"))))

(add-hook 'lisp-mode-hook
	  (lambda ()
	    (cond ((not (featurep 'slime))
		   (require 'slime) 
		   (slime-mode)))))

(eval-after-load "slime"
  '(slime-setup '(slime-fancy slime-banner)))
