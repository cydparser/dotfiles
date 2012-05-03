(setq ido-create-new-buffer 'always
      ido-enable-flex-matching t
      ido-everywhere t
      ido-ignore-extensions t
      ido-save-directory-list-file (expand-file-name "ido.last" user-cache-directory))

(ido-mode 1)
