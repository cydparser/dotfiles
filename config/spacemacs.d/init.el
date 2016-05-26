(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-configuration-layer-path (list (concat dotspacemacs-directory "layers/"))
   dotspacemacs-configuration-layers
   '(auto-completion
     (c-c++
      :variables
      c-c++-enable-clang-support t)
     colors
     dockerfile
     emacs-lisp
     erc
     git
     ;; stack install apply-refact hasktags hindent hlint hoogle
     (haskell
      :variables
      haskell-enable-ghc-mod-support nil)
     github
     html
     ;; npm install -g eslint js-beautify tern
     ;; javascript
     markdown
     nixos
     org
     ;; gem install rubocop ruby-lint
     (ruby
      :variables
      ruby-test-runner 'rspec)
     (shell
      :variables
      shell-default-shell 'multi-term)
     (spell-checking
      :variables
      spell-checking-enable-by-default nil)
     syntax-checking+
     version-control
     yaml)
   dotspacemacs-additional-packages '()
   dotspacemacs-excluded-packages
   '(chruby
     company-ghc
     fish-mode
     ghc
     rbenv
     rvm
     undo-tree)
   dotspacemacs-scratch-mode 'emacs-lisp-mode))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  (setq-default
   dotspacemacs-active-transparency 100
   dotspacemacs-colorize-cursor-according-to-state nil
   dotspacemacs-command-key ":"
   dotspacemacs-editing-style 'emacs
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-highlight-delimiters 'current
   dotspacemacs-inactive-transparency 100
   dotspacemacs-leader-key "SPC"
   dotspacemacs-loading-progress-bar nil
   dotspacemacs-major-mode-emacs-leader-key "M-M"
   dotspacemacs-maximized-at-startup t
   dotspacemacs-which-key-delay 0.5
   dotspacemacs-themes
   '(spacemacs-dark
     spacemacs-light
     solarized-light
     solarized-dark
     leuven)))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init'.  You are free to put almost
any user code here.  The exception is org related code, which should be placed
in `dotspacemacs/user-config'."

  (defconst init-xdg-config-home
    (or (getenv "XDG_CONFIG_HOME") (expand-file-name ".config" (getenv "HOME")))
    "XDG config home directory.")

  (defun init/xdg-config (path)
    "Convert relative PATH to absolute using XDG config home for the parent directory."
    (expand-file-name path init-xdg-config-home))

  (setq custom-file (expand-file-name "custom.el" (init/xdg-config "spacemacs.d"))
        exec-path-from-shell-check-startup-files nil
        rust-enable-racer t)

  (load custom-file)

  (defalias 'ar 'align-regexp)
  (defalias 'rs 'replace-string)
  (defalias 'sl 'sort-lines)

  (let ((pdict (init/xdg-config "ispell/words")))
    (if (file-exists-p pdict)
        (setq ispell-personal-dictionary pdict))))

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration. You are free to put any user code."
  (setq confirm-nonexistent-file-or-buffer nil
        fill-column 100
        git-link-open-in-browser nil
        js-indent-level tab-width
        js2-basic-offset tab-width
        kill-whole-line t
        ;; `call-process` uses a different path.
        projectile-tags-command (concat "PATH=" (getenv "PATH") " ctags -Re -f \"%s\" %s")
        projectile-use-git-grep t
        sh-basic-offset tab-width
        sh-indentation tab-width)

  (defun init/kill-buffer-current ()
    (interactive)
    (kill-buffer (current-buffer)))

  (dolist (kf '(("C-c C-SPC" . delete-trailing-whitespace)
                ("C-x C-b" . ibuffer)
                ("C-x C-k" . init/kill-buffer-current)
                ("M-m M-m" . back-to-indentation)
                ("M-o" . other-window)))
    (global-set-key (kbd (car kf)) (cdr kf)))

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (unless (equal (buffer-name) "*scratch*")
                (spacemacs/toggle-aggressive-indent-on))))

  (global-flycheck-mode 1)

  ;; Use Spacemacs as the $EDITOR for git commits.
  (global-git-commit-mode t)
  (spacemacs/toggle-camel-case-motion-globally-on))
