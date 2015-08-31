;;; rustfmt.el --- Format rust code using rustfmt    -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Fredrik Bergroth

;; Author: Fredrik Bergroth <fbergroth@gmail.com>
;; URL: https://github.com/fbergroth/emacs-rustfmt
;; Keywords: convenience
;; Version: 0
;; Package-Requires: ((emacs "24"))

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

;; Call `rustfmt-format-buffer' to format the current buffer using rustfmt. It is
;; convenient to bind it to a key, such as:
;;
;;    (define-key rust-mode-map (kbd "C-c C-f") #'rustfmt-format-buffer)
;;
;; Errors and warnings will be visible in the `*rustfmt*' buffer.

;;; Code:

(defvar rustfmt-bin "rustfmt")

(defun rustfmt--call (cur-file tmp-file)
  "Format the CUR-FILE copy TMP-FILE using rustfmt."
  (with-current-buffer (get-buffer-create "*rustfmt*")
    (delete-region (point-min) (point-max))
    (let ((status (call-process rustfmt-bin nil t nil
                                "--write-mode=overwrite" tmp-file)))
      (goto-char (point-min))
      (while (re-search-forward tmp-file nil t)
        (replace-match cur-file))

      (unless (zerop status)
        (error "Rustfmt failed, see *rustfmt* buffer for details")))))

;;;###autoload
(defun rustfmt-format-buffer ()
  "Format the current buffer using rustfmt."
  (interactive)
  (unless (executable-find rustfmt-bin)
    (error "Could not locate executable \"%s\"" rustfmt-bin))

  (let ((cur-file (buffer-file-name))
        (tmp-file (make-temp-file "rustfmt" nil ".rs")))
    (unwind-protect
        (progn (write-region nil nil tmp-file nil 'silent)
               (rustfmt--call cur-file tmp-file)
               (insert-file-contents tmp-file nil nil nil 'replace)
               (message "Formatted buffer with rustfmt."))
      (delete-file tmp-file))))

(provide 'rustfmt)
;;; rustfmt.el ends here
