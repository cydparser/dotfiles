(add-hook 'coffee-mode-hook
	  (lambda ()
	    (make-local-variable 'tab-width)
	    (set 'tab-width 2)
	    ;; If you don't have js2-mode
	    (setq coffee-js-mode 'javascript-mode)
	    ;; Compile '.coffee' files on every save
	    (and (file-exists-p (buffer-file-name))
		 (file-exists-p (coffee-compiled-file-name))
		 (coffee-cos-mode t))))
