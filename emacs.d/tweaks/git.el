;; fixes read-only rebasing
(setq auto-mode-alist
      (delete '("git-rebase-todo" . rebase-mode) auto-mode-alist))
