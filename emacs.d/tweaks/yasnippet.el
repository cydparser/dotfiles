(require 'yasnippet)

(setq yas/root-directory `(,(init-expand-file-name "snippets")
                           ,(init-expand-file-name "snippets-local")))

(dolist (dir yas/root-directory)
  (make-directory dir t)
  (yas/load-directory dir))

(setq yas/prompt-functions '(yas/ido-prompt))

(add-to-list 'hippie-expand-try-functions-list 'yas/hippie-try-expand)

(defun yasutils/uncapitalize (cap)
  (concat (downcase (substring cap 0 1))
          (substring cap 1)))
