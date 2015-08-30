;;; rustfmt.el --- Format rust code using rustfmt    -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Fredrik Bergroth

;; Author: Fredrik Bergroth <fbergroth@gmail.com>
;; URL: https://github.com/fbergroth/emacs-rustfmt
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Call `rustfmt-buffer' to format the current buffer using rustfmt. It is
;; convenient to bind it to a key, such as:
;;
;;    (define-key rust-mode-map (kbd "C-c C-f") #'rustfmt-buffer)
;;
;; Errors and warnings will be visible in the `*rustfmt*' buffer.

;;; Code:

(defvar rustfmt-bin "rustfmt")

;;;###autoload
(defun rustfmt-buffer ()
  "Format the current buffer using rustfmt."
  (interactive)

  (unless (executable-find rustfmt-bin)
    (error "Could not locate executable \"%s\"" rustfmt-bin))

  (let ((cur-file (buffer-file-name))
        (tmp-file (make-temp-file "rustfmt" nil ".rs"))
        (process-buffer (get-buffer-create "*rustfmt*")))
    (write-region nil nil tmp-file nil 'silent)

    (with-current-buffer process-buffer
      (let ((inhibit-read-only t))
        (delete-region (point-min) (point-max))
        (unless (zerop (call-process rustfmt-bin nil t nil
                                     "--write-mode=overwrite" tmp-file))
          (error "Rustfmt failed, see *rustfmt* buffer for details"))

        ;; Clean up *rustfmt* buffer
        (goto-char (point-min))
        (let ((needle (format "Rustfmt failed at %s" tmp-file)))
          (while (re-search-forward needle nil t)
            (replace-match cur-file)))

        ;; Navigate warnings with grep-mode
        (grep-mode)))

    (insert-file-contents tmp-file nil nil nil 'replace)
    (delete-file tmp-file)
    (message "Formatted buffer with rustfmt.")))

(provide 'rustfmt)
;;; rustfmt.el ends here
