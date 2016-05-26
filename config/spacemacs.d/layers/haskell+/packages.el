(setq haskell+-packages
      '((company-ghc :excluded t)
        (ghc :excluded t)
        haskell-mode
        hlint-refactor))

(defun haskell+/pre-init-company-ghci ()
  (spacemacs|use-package-add-hook company-ghci
    :post-config
    (progn
      (let ((f (init/xdg-data "hoogle")))
        (when (and (executable-find "hoogle") (file-exists-p f))
          (defun company-ghci/hoogle-info (symbol)
            "Use local hoogle database to search for documentation of SYMBOL"
            (shell-command-to-string (format "hoogle --info -d %s %s" f symbol))))))))

(defun haskell+/pre-init-haskell-mode ()
  (spacemacs|use-package-add-hook haskell-mode
    :post-config
    (progn
      (defun haskell+/goto-next-error ()
        "Go to the next Haskell or flycheck error."
        (interactive)
        (if (haskell+//check-overlays-p)
            (haskell-goto-next-error)
          (flycheck-next-error)))

      (defun haskell+/goto-prev-error ()
        "Go to the previous Haskell or flycheck error."
        (interactive)
        (if (haskell+//check-overlays-p)
            (haskell-goto-prev-error)
          (flycheck-previous-error)))

      (defun haskell+//check-overlays-p ()
        (car (haskell-check-filter-overlays
              (overlays-in (point-min) (point-max)))))

      (defun haskell+/process-insert-type ()
        "Insert the type of the identifier at point."
        (interactive)
        (haskell-process-do-type :insert-value))

      (defun haskell+/process-reload-switch ()
        "Reload file and switch to the REPL."
        (interactive)
        (haskell-process-load-or-reload)
        (haskell-interactive-switch))

      (dolist (mode haskell-modes)
        (spacemacs/set-leader-keys-for-major-mode mode
          "ot" 'haskell+/process-insert-type
          "os" 'haskell+/process-reload-switch))

      (with-eval-after-load 'haskell
        (let ((map interactive-haskell-mode-map))
          (define-key map (kbd "M-n") 'haskell+/goto-next-error)
          (define-key map (kbd "M-p") 'haskell+/goto-prev-error))))))

(defun haskell+/post-init-haskell-mode ()
  (setq
   haskell-compile-cabal-build-alt-command "cd %s && stack clean && stack build --ghc-options -ferror-spans"
   haskell-compile-cabal-build-command "cd %s && stack build --ghc-options -ferror-spans"
   haskell-compile-command "stack ghc -- -Wall -ferror-spans -fforce-recomp -c %s"
   haskell-process-args-stack-ghci
   (list "--fast" ; TODO After ghc-8, add `-fexternal-interpreter -prof`
         "--ghc-options"
         (concat
          "-XNamedWildCards -XPartialTypeSignatures -ferror-spans -fdefer-type-errors"
          " -fno-warn-missing-signatures -fno-warn-partial-type-signatures -fno-warn-type-defaults"))))

(defun haskell+/init-hlint-refactor ()
  (use-package hlint-refactor
    :defer t
    :init
    (progn
      (dolist (mode haskell-modes)
        (add-hook mode 'hlint-refactor-mode)
        (spacemacs/declare-prefix-for-mode mode "mr" "haskell/refactor")
        (spacemacs/set-leader-keys-for-major-mode mode
          "rb" 'hlint-refactor-refactor-buffer
          "rr" 'hlint-refactor-refactor-at-point)))))
