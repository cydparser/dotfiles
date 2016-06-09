(defconst syntax-checking+-packages
  '(flycheck))

(defun syntax-checking+/pre-init-flycheck ()
  (spacemacs|use-package-add-hook flycheck
    :post-config
    (progn
      (let ((map flycheck-mode-map))
        (define-key map (kbd "M-n") 'flycheck-next-error)
        (define-key map (kbd "M-p") 'flycheck-previous-error))

      (defun syntax-checking+//flycheck-may-enable-mode (f)
        "Disable flycheck in special buffers."
        (interactive)
        (and (apply (list f))
             (not (string-prefix-p "*" (buffer-name)))))

      (advice-add 'flycheck-may-enable-mode :around
                  #'syntax-checking+//flycheck-may-enable-mode))))

(defun syntax-checking+/post-init-flycheck ()
  (setq flycheck-rubocoprc (init/xdg-config "ruby/rubocop.yml")
        flycheck-rubylintrc (init/xdg-config "ruby/ruby-lint.yml")))
