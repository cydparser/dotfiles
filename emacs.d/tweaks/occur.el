;; http://www.masteringemacs.org/articles/2011/07/20/searching-buffers-occur-mode/

(eval-when-compile
  (require 'cl))

(defun get-buffers-matching-mode (mode)
  "Returns a list of buffers where their major-mode is equal to MODE"
  (remove-if-not #'(lambda (buf)
                     (with-current-buffer buf
                       (eq mode major-mode)))
                 (buffer-list)))

(defun multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with this major mode."
  (interactive)
  (multi-occur
   (get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))

(global-set-key (kbd "M-s o") 'multi-occur-in-this-mode)

(define-key isearch-mode-map (kbd "M-s o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (multi-occur
       (get-buffers-matching-mode major-mode)
       (if isearch-regexp isearch-string (regexp-quote isearch-string))))))
