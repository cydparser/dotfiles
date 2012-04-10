;; source: https://github.com/purcell/emacs.d/blob/master/init-exec-path.el

(defun set-exec-path-from-shell-path ()
  "Set up Emacs' 'exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "\n$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(if (and (eq system-type 'darwin) window-system)
    (set-exec-path-from-shell-path))
