;;; readme-debian.el --- a simple mode for README.Debian files

;; Copyright 2002, 2003 Junichi Uekawa.
;;
;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; readme-debian.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your Debian installation, in /usr/share/common-licenses/GPL
;; If not, write to the Free Software Foundation, 675 Mass Ave,
;; Cambridge, MA 02139, USA.

;;; Code:
(require 'debian-changelog-mode)
(defgroup readme-debian nil "Readme Debian (mode)"
  :group 'tools
  :prefix "readme-debian-")

(defcustom readme-debian-mode-load-hook nil "*Hooks that are run when `readme-debian-mode' is loaded."
  :type 'hook
  :group 'readme-debian)
(defcustom readme-debian-mode-hook nil "*Hooks that are run when `readme-debian-mode' is entered."
  :type 'hook
  :group 'readme-debian)

(add-to-list 'auto-mode-alist '("debian/README.Debian$" . readme-debian-mode))
(add-to-list 'auto-mode-alist '("^/usr/share/doc/.*/README.Debian.*$" . readme-debian-mode))

(defvar readme-debian-font-lock-keywords
  '(("^\\(.*\\) for \\(Debian\\)$"
     (1 font-lock-keyword-face)
     (2 font-lock-string-face))
    ("^[-=]+$" 0 font-lock-string-face)
    ("^ -- \\([^<]*\\)\\(<[^>]*>\\)\\(, \\(.*\\)\\)?$"
     (1 font-lock-keyword-face)
     (2 font-lock-function-name-face)
     (3 font-lock-string-face)))
  "Regexp keywords used to fontify README.Debian buffers.")

(defun readme-debian-update-timestamp ()
  "Function to update timestamp in README.Debian files, automatically invoked when saving file."
  (save-excursion
    (goto-line 1)
    (if (re-search-forward "^ -- " nil t)
        (delete-region (progn (beginning-of-line) (point)) (progn (end-of-line) (point)))
      (goto-char (point-max))
      (if (bolp)
	  (insert "\n")
	(insert "\n\n")))
    (insert (concat
	     " -- "
	     debian-changelog-full-name
	     " <" debian-changelog-mailing-address ">, "
	     (current-time-string)))
    (if (and (= (point)(point-max)) (not (bolp)))
	(insert "\n"))))

(defvar readme-debian-mode-map nil "Keymap for README.Debian mode.")
(if readme-debian-mode-map
    ()
  (setq readme-debian-mode-map (make-sparse-keymap)))
(defvar readme-debian-mode-syntax-table nil "Syntax table for README.Debian mode.")
(if readme-debian-mode-syntax-table
    ()                   ; Do not change the table if it is already set up.
  (setq readme-debian-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?\" ".   " readme-debian-mode-syntax-table)
  (modify-syntax-entry ?\\ ".   " readme-debian-mode-syntax-table)
  (modify-syntax-entry ?' "w   " readme-debian-mode-syntax-table))

(defvar font-lock-defaults)             ;For XEmacs byte-compilation
(defun readme-debian-mode ()
  "Mode for reading and editing README.Debian files.
Upon saving the visited README.Debian file, the timestamp at the bottom
will be updated.

\\{readme-debian-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'readme-debian-mode)
  (setq mode-name "README.Debian")
  (mapcar 'make-local-variable '(font-lock-defaults write-file-hooks))
  (use-local-map readme-debian-mode-map)
  (set-syntax-table readme-debian-mode-syntax-table)
  (setq font-lock-defaults
   '(readme-debian-font-lock-keywords
     nil ;; keywords-only? No, let it do syntax via table.
     nil ;; case-fold?
     nil ;; Local syntax table.
     ))
  ;; add timestamp update func to write-file-hook
  (add-to-list 'write-file-hooks 'readme-debian-update-timestamp)
  (run-hooks 'readme-debian-mode-hook))

(run-hooks 'readme-debian-mode-load-hook)

(provide 'readme-debian)

;;; readme-debian.el ends here
