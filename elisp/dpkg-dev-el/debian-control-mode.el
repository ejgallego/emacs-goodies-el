;;; debian-control-mode.el --- major mode for Debian control files

;; Copyright (C) 2001 Free Software Foundation, Inc.

;; Author: Colin Walters <walters@debian.org>
;; Maintainer: Colin Walters <walters@debian.org>
;; Created: 29 Nov 2001
;; Version: 0.5
;; X-RCS: $Id: debian-control-mode.el,v 1.4 2003/11/04 02:07:56 psg Exp $
;; URL: http://cvs.verbum.org/debian/debian-control-mode
;; Keywords: convenience

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; debian-control-mode.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your Debian installation, in /usr/share/common-licenses/GPL
;; If not, write to the Free Software Foundation, 675 Mass Ave,
;; Cambridge, MA 02139, USA.

;;; Commentary:

;; debian-control-mode.el is developed under Emacs 21, and is targeted
;; for use in Emacs 21 and relatively recent versions of XEmacs.

;;; Change Log:

;; Changes from 0.4 to 0.5:  Peter S Galbraith <psg@debian.org>

;; * Add "View upgrading-checklist" to control menu.
;; * Added debian-control-find-file to make this work on XEmacs.

;; Changes from 0.3 to 0.4:

;; * Don't depend on face properties to find names of packages.
;; * Use an after-change-function to put special text properties on,
;;   instead of using font-lock to do it.  That way they'll be added
;;   regardless of the value of `font-lock-mode'.
;; * Fix up portable definition of `with-auto-compression-mode'.

;; Changes from 0.2 to 0.3:

;; * Fix bug in filling description lines.
;; * Clicking on a source or binary package name shows bugs for that
;;   package.
;; * New function `debian-control-mode-add-field', bound to 'C-c C-a'
;;   by default.
;; * New function `debian-control-visit-policy', bound to 'C-c C-p'
;;   by default.
;; * New function `debian-control-view-package-bugs', bound to 'C-c C-b'
;;   by default.
;; * Initial menu support.
;; * Initial customize support.
;; * Imenu support.
;; * Initial attempts at XEmacs support.
;; * Use the term "field" instead of "header".

;; Changes from 0.1 to 0.2:

;; * Tighten up regexps; whitespace before and after a field value is
;;   insignificant.  Also, package names may contain '+' and '.'.
;; * Add more comments for compliance with Emacs Lisp coding standards.
;; * Allow filling of a regular field to work.
;; * Provide `debian-control-mode'.

;;; Bugs:

;; Filling doesn't work on XEmacs.  I have no idea why.
;; Mouse stuff doesn't work on XEmacs.
;; Emacs 20 isn't supported.

;;; Code:

(require 'easymenu)
(require 'font-lock)
(eval-when-compile
  (require 'cl))

;; XEmacs compatibility 
(eval-and-compile
  (unless (fboundp 'line-beginning-position)
    (defun line-beginning-position ()
      (save-excursion
	(beginning-of-line)
	(point))))
  (unless (fboundp 'line-end-position)
    (defun line-end-position ()
      (save-excursion
	(end-of-line)
	(point))))
  (unless (fboundp 'match-string-no-properties)
    (defalias 'match-string-no-properties 'match-string)))

(defgroup debian-control nil "Debian control file maintenance"
  :link '(url-link "http://cvs.verbum.org/debian/debian-control-mode")
  :group 'tools)

(defcustom debian-control-source-package-face 'font-lock-type-face
  "The face to use for highlighting source package names."
  :type 'face
  :group 'debian-control)

(defcustom debian-control-binary-package-face 'font-lock-variable-name-face
  "The face to use for highlighting binary package names."
  :type 'face
  :group 'debian-control)

;; FIXME: As of policy 3.5.6.0, the allowed characters in a field name
;; are not specified.  So we just go with "word constituent" or '-'
;; characters before a colon.
(defvar debian-control-field-regexp "^\\(\\(\\sw\\|-\\)+:\\)")
(defvar debian-control-package-name-regexp "\\([-a-zA-Z0-9+.]+?\\)")

(defvar debian-control-mode-package-name-keymap (make-sparse-keymap))

(defvar debian-control-font-lock-keywords
  `((,(concat "^\\(Source:\\)\\s-*"
	      debian-control-package-name-regexp
	      "\\s-*$")
     (1 font-lock-keyword-face)
     ,(list 2
	    (if (featurep 'xemacs)
		'(symbol-value debian-control-source-package-face)
	      '(list 'face debian-control-source-package-face))
	   nil nil))
    (,(concat "^\\(Package:\\)\\s-*"
	      debian-control-package-name-regexp
	      "\\s-*$")
     (1 font-lock-keyword-face)
     ,(list 2
	    (if (featurep 'xemacs)
		'(symbol-value 'debian-control-binary-package-face)
	      '(list 'face debian-control-binary-package-face))
	    nil nil))
    (,debian-control-field-regexp
     (1 font-lock-keyword-face))))

(defvar debian-control-source-fields
  '("Section" "Priority" "Maintainer" "Build-Depends" "Build-Depends-Indep"
    "Build-Conflicts" "Build-Conflicts-Indep" "Standards-Version")
  "Valid source package field names, collected from several policy sections.")

(defvar debian-control-binary-fields
  '("Architecture" "Depends" "Conflicts" "Pre-Depends" "Essential"
    "Provides" "Recommends" "Suggests" "Replaces" "Enhances" "Description")
  "Valid binary package field names, collected from several policy sections.")

(defvar debian-control-mode-menu nil)

;;;###autoload
(define-derived-mode debian-control-mode fundamental-mode "Debian Control"
  "A major mode for editing Debian control files (i.e. debian/control)."
  (if (< emacs-major-version 21)
      (message "debian-control-mode only supports emacsen version >= 21; disabling features")
    (progn
      (set (make-local-variable 'font-lock-defaults)
	   '((debian-control-font-lock-keywords) t))
      (set (make-local-variable 'fill-paragraph-function)
	   #'debian-control-mode-fill-paragraph)
      (make-local-variable 'after-change-functions)
      (push 'debian-control-mode-after-change-function after-change-functions)
      (set (make-local-variable 'imenu-generic-expression)
        '((nil "^\\(Package\\|Source\\):\\s-*\\([-a-zA-Z0-9+.]+?\\)\\s-*$" 2)))
      
      (define-key debian-control-mode-map (kbd "C-c C-b") 'debian-control-view-package-bugs)
      (define-key debian-control-mode-map (kbd "C-c C-p") 'debian-control-visit-policy)
      (define-key debian-control-mode-map (kbd "C-c C-a") 'debian-control-mode-add-field)
      (define-key debian-control-mode-package-name-keymap (if (featurep 'xemacs)
							      [down-mouse-2]
							    [(mouse-2)])
	'debian-control-mode-bugs-mouse-click)
      (easy-menu-add debian-control-mode-menu)
      (let ((after-change-functions nil))
	(debian-control-mode-after-change-function (point-min) (point-max) 0)))))

(defun debian-control-mode-after-change-function (beg end len)
  (save-excursion
    (let ((modified (buffer-modified-p))
	  (buffer-read-only nil))
      (unwind-protect
	  (progn
	    (goto-char beg)
	    (beginning-of-line)
	    (while (< (point) end)
	      (cond ((looking-at (concat "^\\(Source:\\)\\s-*"
					 debian-control-package-name-regexp
					 "\\s-*$"))
		     (add-text-properties
		      (match-beginning 2) (match-end 2)
		      `(mouse-face
			highlight
			debian-control-mode-package ,(match-string 0)
			help-echo "View bugs for this source package"
			keymap ,debian-control-mode-package-name-keymap)))
		    ((looking-at (concat "^\\(Package:\\)\\s-*"
					 debian-control-package-name-regexp
					 "\\s-*$"))
		     (add-text-properties
		      (match-beginning 2) (match-end 2)
		      `(mouse-face
			highlight
			debian-control-mode-package ,(match-string 0)
			help-echo "View bugs for this binary package"
			keymap ,debian-control-mode-package-name-keymap)))
		    (t nil))
	      (forward-line 1)))
	(set-buffer-modified-p modified)))))

(easy-menu-define 
 debian-control-mode-menu debian-control-mode-map "Debian Control Mode Menu"
 '("Control"
   ["Add field at point" debian-control-mode-add-field t]
   "--"
   "Policy"
    ["View upgrading-checklist" (debian-control-visit-policy 'checklist)
     (file-exists-p "/usr/share/doc/debian-policy/upgrading-checklist.txt.gz")]
    ["View policy (text)" (debian-control-visit-policy 'text)
     (file-exists-p "/usr/share/doc/debian-policy/policy.txt.gz")]
    ["View policy (HTML)" (debian-control-visit-policy 'html) t]
   "--"
   "Access www.debian.org"
   ["Bugs for package" debian-control-view-package-bugs t]
   ["Specific bug number" (debian-changelog-web-bug) nil]
;;   ["Package list (all archives)" (debian-changelog-web-packages) t]
;;  ("Package web pages..." 
;;   ["stable" (debian-changelog-web-package "stable") t]
;;   ["testing" (debian-changelog-web-package "testing") t]
;;   ["unstable" (debian-changelog-web-package "unstable") t])
   "--"
   ["Customize" (customize-group "debian-control") t]))

(defun debian-control-mode-fill-paragraph (&rest args)
  (let (beg end)
    (save-excursion
      ;; Are we looking at a field?
      (if (save-excursion
	    (beginning-of-line)
	    (looking-at debian-control-field-regexp))
	  (setq beg (match-end 0)
		end (line-end-position))
	;; Otherwise, we're looking at a description; handle filling
	;; areas separated with "."  specially
    (setq beg (save-excursion
                 (beginning-of-line)
                 (while (not (or (bobp)
                                 (looking-at "^\\sw-*$")
                                 (looking-at "^ \\.")
                                 (looking-at debian-control-field-regexp)))
                   (forward-line -1))
                 (unless (eobp)
                   (forward-line 1))
                 (point))
          end (save-excursion
                 (beginning-of-line)
                 (while (not (or (eobp)
                                 (looking-at "^\\sw-*$")
                                 (looking-at debian-control-field-regexp)
                                 (looking-at "^ \\.")))
                   (forward-line 1))
                 (unless (bobp)
                   (forward-line -1)
		   (end-of-line))
                 (point))))
      (let ((fill-prefix " "))
	(apply #'fill-region beg end args)))))

(defun debian-control-mode-add-field (binary field)
  "Add a field FIELD to the current package; BINARY means a binary package."
  (interactive
   (let* ((binary-p (if (or (save-excursion
			      (beginning-of-line)
			      (looking-at "^\\(Package\\|Source\\)"))
			    (re-search-backward "^\\(Package\\|Source\\)" nil t))
			(not (not (string-match "Package" (match-string 0))))
		      (error "Couldn't find Package or Source field")))
	  (fields (if binary-p
		      debian-control-binary-fields
		    debian-control-source-fields)))   
     (list
      binary-p
      (capitalize
       (completing-read (format "Add %s package field: " (if binary-p "binary" "source"))
			(mapcar #'(lambda (x) (cons x nil)) fields))))))
  (require 'cl)
  (let ((fields (if binary
		    debian-control-binary-fields
		  debian-control-source-fields))
	(beg (save-excursion
	       (beginning-of-line)
	       (while (not (or (bobp)
			       (looking-at "^\\s-*$")))
		 (forward-line -1))
	       (forward-line 1)
	       (point)))
	(end (save-excursion
	       (beginning-of-line)
	       (while (not (or (eobp)
			       (looking-at "^\\s-*$")))
		 (forward-line 1))
	       (point))))
    (save-restriction
      (narrow-to-region beg end)
      (let ((curfields (let ((result nil))
			 (goto-char (point-min))
			 (while (not (eobp))
			   (when (looking-at debian-control-field-regexp)
			     (push (cons (subseq
					  ;; Text properties are evil
					  (match-string-no-properties 1)
					  0
					  ;; Strip off the ':'
					  (- (match-end 1)
					     (match-beginning 1)
					     1))
					 (match-beginning 0))
				   result))
			   (forward-line 1))
			 result))
	    (x nil))
	;; If the field is already present, just jump to it
	(if (setq x (assoc field curfields))
	    (goto-char (cdr x))
	  (let* ((pos (position field fields :test #'string-equal))
		 (prevfields (subseq fields 0 pos))
		 (nextfields (subseq fields (1+ pos)))
		 (cur nil))
	    (while (or prevfields
		       nextfields)
	      (when prevfields
		(when (setq x (assoc (pop prevfields) curfields))
		  (setq prevfields nil nextfields nil)
		  (goto-char (cdr x))))
	      (when nextfields
		(when (setq x (assoc (pop nextfields) curfields))
		  (setq prevfields nil nextfields nil)
		  (goto-char (cdr x)))))
	    ;; Hack: we don't want to add fields after Description
	    (beginning-of-line)
	    (when (looking-at "^Description")
	      (forward-line -1))
	    (end-of-line)
	    (insert "\n" field ": ")))))))

(defun debian-control-visit-policy (format)
  "Visit the Debian Policy manual in format FORMAT.
Currently valid FORMATs are `html', `text' and `checklist'.
The last one is not strictly a format, but visits the upgrading-checklist.txt
text file."
  (interactive
   (list (intern
	  (completing-read "Policy format: "
                           (mapcar #'(lambda (x) (cons x 0))
                                   '("html" "text" "checklist"))
			   nil t))))
  (case format
    (text
     (debian-control-find-file "/usr/share/doc/debian-policy/policy.txt.gz"))
    (checklist
     (debian-control-find-file
      "/usr/share/doc/debian-policy/upgrading-checklist.txt.gz"))
    (html
     (require 'browse-url)
     (browse-url
      (if (file-exists-p "/usr/share/doc/debian-policy/policy.html/index.html")
	  "file:///usr/share/doc/debian-policy/policy.html/index.html"
	(prog1
	    "http://www.debian.org/doc/debian-policy"
	  (message "Note: package `debian-policy' not installed, using web version")))))
    (t
     (error "Unknown format %s for policy" format))))

(defun debian-control-find-file (file)
  "Find-file a possibly compressed FILE"
  (require 'jka-compr)
  (let ((installed (jka-compr-installed-p)))
    (if (not installed)
        (auto-compression-mode t))
    (find-file file)
    (if (not installed)
        (auto-compression-mode -1))))

(defun debian-control-mode-bugs-mouse-click (event)
  "Display the bugs for the package name clicked on."
  (interactive "e")
  (mouse-set-point event)
  (let ((prop (get-text-property (point) 'debian-control-mode-package)))
    (unless prop
      (error "Couldn't determine package name at point"))
    (debian-control-view-package-bugs prop)))

(defun debian-control-mode-bug-package-names ()
  (let ((result nil))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
	(when (looking-at "^\\(Package\\|Source\\):\\s-*\\([-a-zA-Z0-9+.]+?\\)\\s-*$")
	  (push (concat
		 (if (save-match-data (string-match "Source" (match-string 1)))
		     "src:"
		   "")
		 (match-string-no-properties 2)) result))
	(forward-line 1)))
    result))

(defun debian-control-view-package-bugs (package)
  "View bugs for package PACKAGE via http://bugs.debian.org."
  (interactive
   (list
    (completing-read "View bugs for package: "
		     (mapcar #'(lambda (x) (cons x 0))
			     (debian-control-mode-bug-package-names))
		     nil t)))
  (browse-url (concat "http://bugs.debian.org/" package)))

(add-to-list 'auto-mode-alist '("/debian/control\\'" . debian-control-mode))
;;;###autoload(add-to-list 'auto-mode-alist '("/debian/control\\'" . debian-control-mode))

(provide 'debian-control-mode)

;;; debian-control-mode.el ends here
