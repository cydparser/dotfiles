(defvar init-xdg-config-home (or (getenv "XDG_CONFIG_HOME")
                                 (expand-file-name ".config" (getenv "HOME")))
  "XDG config home directory.")

(defvar init-dotspacemacs-dir (file-name-directory file)
  "Location of spacemacs.d.")

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-configuration-layer-path (list (concat init-dotspacemacs-dir "layers/"))
   dotspacemacs-configuration-layers
   '(auto-completion
     '(c-c++
       :variables
       c-c++-enable-clang-support t)
     '(color
       :variables
       colors-enable-rainbow-identifiers t)
     dockerfile
     emacs-lisp
     erc
     git
     ;; stack install apply-refact hasktags hindent hlint hoogle
     haskell
     github
     ;; npm install -g eslint js-beautify tern
     javascript
     markdown
     nixos
     org
     ;; gem install rubocop ruby-lint
     '(ruby
       :variables
       ruby-test-runner 'rspec)
     '(shell
       :variables
       shell-default-shell 'multi-term)
     spell-checking
     syntax-checking
     version-control
     yaml)
   dotspacemacs-additional-packages '()
   dotspacemacs-excluded-packages
   '(chruby
     company-ghc
     ghc
     fish-mode
     rbenv
     rvm)))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  (setq-default
   dotspacemacs-active-transparency 100
   dotspacemacs-colorize-cursor-according-to-state nil
   dotspacemacs-editing-style 'emacs
   dotspacemacs-inactive-transparency 100
   dotspacemacs-loading-progress-bar nil
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
  (setq custom-file (expand-file-name "custom.el" init-dotspacemacs-dir)
        rust-enable-racer t)

  (defalias 'ar 'align-regexp)
  (defalias 'ms 'magit-status)
  (defalias 'rs 'replace-string)
  (defalias 'sl 'sort-lines)

  (let ((pdict (expand-file-name "ispell/words" init-xdg-config-home)))
    (if (file-exists-p pdict)
        (setq ispell-personal-dictionary pdict))))

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration. You are free to put any user code."
  (setq magit-repository-directories '("~/src/"))

  ;; Use Spacemacs as the $EDITOR for git commits.
  (global-git-commit-mode t))
