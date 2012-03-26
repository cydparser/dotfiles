;; org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/prof-dev.org" "~/org/2011.org"))
