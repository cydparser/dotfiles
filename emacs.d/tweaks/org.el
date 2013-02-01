;; org-mode

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-log-done t
      org-startup-truncated nil)
(if (file-exists-p "~/org")
    (setq org-agenda-files (directory-files "~/org" :full "^[^.]")))
