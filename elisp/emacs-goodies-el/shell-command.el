;;; shell-command.el --- enables tab-completion for `shell-command'

;; Copyright (C) 1998-2003 TSUCHIYA Masatoshi <tsuchiya@namazu.org>

;; Author: TSUCHIYA Masatoshi <tsuchiya@namazu.org>
;; Keywords: shell
;; Version: $Revision: 1.1 $

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is an enhancement for shell-command, enabling tab-completion
;; of commands and dir/filenames within the shell-command input
;; context.

;; The latest version of this program can be downloaded from
;; http://namazu.org/~tsuchiya/elisp/shell-command.el.

;;; Install:

;; Install this file to appropriate directory, and put these lines
;; into your ~/.emacs.
;;
;;     (require 'shell-command)
;;     (shell-command-activate-advices)
;;
;; Or alternatively, customize the variable `shell-command-enable-completions'
;; and save the the setting for future sessions.

;;; Code:
(eval-when-compile
  (require 'shell)
  (require 'comint))

(eval-and-compile
  ;; Stuffs to keep compatibility between Emacsen.
  (if (locate-library "custom")
      (require 'custom)
    (or (fboundp 'defgroup)
	(defmacro defgroup (symbol members doc &rest args) nil))
    (or (fboundp 'defcustom)
	(defmacro defcustom (symbol value doc &rest args)
	  (list 'defvar symbol value doc))))
  ;; These macros, such as `when' and `unless' are imported from
  ;; subr.el of Emacs-21.2.
  (or (fboundp 'when)
      (progn
	(defmacro when (cond &rest body)
	  "If COND yields non-nil, do BODY, else return nil."
	  (list 'if cond (cons 'progn body)))
	(put 'when 'edebug-form-spec '(form body))
	(put 'when 'lisp-indent-function 1)))
  (or (fboundp 'unless)
      (progn
	(defmacro unless (cond &rest body)
	  "If COND yields nil, do BODY, else return nil."
	  (cons 'if (cons cond (cons nil body))))
	(put 'unless 'edebug-form-spec '(form body))
	(put 'unless 'lisp-indent-function 1))))

(defgroup shell-command nil
  "Enable Tab completions for `shell-command' and related commands."
  :group 'shell)

(defcustom shell-command-enable-completions nil
  "*Enable Tab completions for `shell-command',
`shell-command-on-region', `grep' and `grep-find'."
  :type 'boolean
  :set (lambda (symbol value)
	 (set-default symbol value)
	 (if (featurep 'shell-command)
	     (shell-command-activate-advices)))
  :require 'shell-command
  :group 'shell-command)

(defcustom shell-command-complete-functions
  '(shell-dynamic-complete-environment-variable
    shell-dynamic-complete-command
    shell-replace-by-expanded-directory
    comint-dynamic-complete-filename)
  "Function list to complete shell commands."
  :type '(repeat function)
  :group 'shell-command)

(defcustom shell-command-prompt
  "Shell command [%w]%$ "
  "Prompt string of `shell-command'.
A number of %-sequences is available to customize.  Note
`shell-command-make-prompt-string'."
  :type 'string
  :group 'shell-command)

(defcustom shell-command-on-region-prompt
  "Shell command on region [%w]%$ "
  "Prompt string of `shell-command-on-region'.
A number of %-sequences is available to customize.  Note
`shell-command-make-prompt-string'."
  :type 'string
  :group 'shell-command)

(defcustom grep-prompt
  "Run grep [%w]%$ "
  "Prompt string of `grep'.
A number of %-sequences is available to customize.  Note
`shell-command-make-prompt-string'."
  :type 'string
  :group 'shell-command)

(defcustom grep-find-prompt
  "Run find [%w]%$ "
  "Prompt string of `grep-find'.
A number of %-sequences is available to customize.  Note
`shell-command-make-prompt-string'."
  :type 'string
  :group 'shell-command)


(put 'shell-command/static-if 'lisp-indent-function 2)
(defmacro shell-command/static-if (cond then &rest else)
  (if (eval cond) then (` (progn  (,@ else)))))


(defun shell-command-make-prompt-string (format-string current-directory) "\
Function to generate prompt string

Use FORMAT-STRING to generate prompt string at the directory
CURRENT-DIRECTORY.  The following `%' escapes are available for use in
FORMAT-STRING:

%d     the date in \"Weekday Month Date\" format \(e.g., \"Tue May 26\"\)
%h     the hostname up to the first `.'
%H     the hostname
%t     the current time in 24-hour HH:MM:SS format
%T     the current time in 12-hour HH:MM:SS format
%@     the current time in 12-hour am/pm format
%u     the username of the current user
%w     the current working directory
%W     the basename of the current working directory
%$     if the effective UID is 0, a #, otherwise a $
%%     Insert a literal `%'.
"
  (let ((case-fold-search nil)
	start buf
	(list (list format-string))
	(alist (let ((system-name (system-name))
		     host-name
		     fqdn-name
		     (time (current-time))
		     (dir (directory-file-name
			   (abbreviate-file-name current-directory))))
		 (shell-command/static-if (featurep 'xemacs)
		     (cond
		      ((string= dir (user-home-directory))
		       (setq dir "~"))
		      ((string-match (concat "^"
					     (regexp-quote
					      (file-name-as-directory
					       (user-home-directory))))
				     dir)
		       (setq dir
			     (concat "~/" (substring dir (match-end 0)))))))
		 (if (string-match "^\\([^.]+\\)\\.[^.]" system-name)
		     (setq fqdn-name system-name
			   host-name (match-string 1 system-name))
		   (setq host-name system-name
			 fqdn-name
			 (cond
			  ((and (boundp 'mail-host-address)
				(stringp mail-host-address)
				(string-match "\\." mail-host-address))
			   mail-host-address)
			  ((and user-mail-address
				(string-match "\\." user-mail-address)
				(string-match "@\\(.*\\)\\'"
					      user-mail-address))
			   (match-string 1 user-mail-address))
			  (t system-name))))
		 `(("%%" . "%")
		   ("%d" . ,(format-time-string "%a %b %e" time))
		   ("%h" . ,host-name)
		   ("%H" . ,fqdn-name)
		   ("%t" . ,(format-time-string "%H:%M:%S" time))
		   ("%T" . ,(format-time-string "%I:%M:%S" time))
		   ("%@" . ,(format-time-string "%I:%M%p" time))
		   ("%u" . ,(user-login-name))
		   ("%w" . ,dir)
		   ("%W" . ,(file-name-nondirectory
			     (directory-file-name current-directory)))
		   ("%\\$" . ,(if (= (user-uid) 0) "#" "$"))))))
    (while alist
      (setq buf nil)
      (while list
	(setq start 0)
	(while (string-match (car (car alist)) (car list) start)
	  (setq buf (cons (cdr (car alist))
			  (cons (substring (car list) start
					   (match-beginning 0))
				buf))
		start (match-end 0)))
	(setq buf (cons (substring (car list) start) buf)
	      list (cdr list)))
      (setq list (nreverse buf)
	    alist (cdr alist)))
    (apply 'concat list)))


(defmacro shell-command/minibuffer-prompt-end ()
  (if (fboundp 'minibuffer-prompt-end)
      '(minibuffer-prompt-end)
    '(point-min)))

(defun shell-command-read-minibuffer
  (format-string current-directory &optional initial-contents
		 user-keymap read hist)
  "Read a command string in the minibuffer, with completion."
  (let ((keymap (make-sparse-keymap))
	(prompt (shell-command-make-prompt-string
		 format-string current-directory)))
    (set-keymap-parent keymap (or user-keymap minibuffer-local-map))
    (define-key keymap "\t"
      (lambda ()
	(interactive)
	(let ((orig-function (symbol-function 'message)))
	  (unwind-protect
	      (progn
		(defun message (string &rest arguments)
		  (let* ((s1 (concat prompt
				     (buffer-substring
				      (shell-command/minibuffer-prompt-end)
				      (point-max))))
			 (s2 (apply (function format) string arguments))
			 (w (- (window-width)
			       (string-width s1)
			       (string-width s2)
			       1)))
		    (funcall orig-function
			     (if (>= w 0)
				 (concat s1 (make-string w ?\ ) s2)
			       s2))
		    (if (sit-for 0.3) (funcall orig-function s1))
		    s2))
		(require 'shell)
		(require 'comint)
		(run-hook-with-args-until-success
		 'shell-command-complete-functions))
	    (fset 'message orig-function)))))
    (read-from-minibuffer prompt initial-contents keymap read hist)))


(let (current-load-list)
  (defadvice shell-command
    (before shell-command-with-completion disable compile)
    "Defined in shell-command.el, to enable tab-completion of commands
and dir/filenames within the input context.  Its prompt string is kept
by `shell-command-prompt'."
    (interactive
     (list
      (shell-command-read-minibuffer shell-command-prompt
				     default-directory
				     nil nil nil 'shell-command-history)
      current-prefix-arg))))


(let (current-load-list)
  (defadvice shell-command-on-region
    (before shell-command-on-region-with-completion disable compile)
    "Defined in shell-command.el, to enable tab-completion of commands
and dir/filenames within the input context.  Its prompt string is kept
by `shell-command-on-region-prompt'."
    (interactive
     (list (region-beginning) (region-end)
	   (shell-command-read-minibuffer shell-command-on-region-prompt
					  default-directory
					  nil nil nil 'shell-command-history)
	   current-prefix-arg
	   current-prefix-arg
	   shell-command-default-error-buffer))))


(let (current-load-list)
  (defadvice grep
    (before grep-with-completion disable compile)
    "Defined in shell-command.el, to enable tab-completion of commands
and dir/filenames within the input context.  Its prompt string is kept
by `grep-prompt'."
    (interactive
     (let (grep-default (arg current-prefix-arg))
       (unless grep-command
	 (grep-compute-defaults))
       (when arg
	 (let* ((tag-default
		 (funcall (or find-tag-default-function
			      (get major-mode 'find-tag-default-function)
			      'grep-tag-default))))
	   (setq grep-default (or (car grep-history) grep-command))
	   (when (string-match
		  "[^ ]+\\s +\\(-[^ ]+\\s +\\)*\\(\"[^\"]+\"\\|[^ ]+\\)"
		  grep-default)
	     (setq grep-default
		   (replace-match tag-default t t grep-default 2)))))
       (list (shell-command-read-minibuffer grep-prompt
					    default-directory
					    (or grep-default grep-command)
					    nil nil 'grep-history))))))


(let (current-load-list)
  (defadvice grep-find
    (before grep-find-with-completion disable compile)
    "Defined in shell-command.el, to enable tab-completion of commands
and dir/filenames within the input context.  Its prompt string is kept
by `grep-find-prompt'."
    (interactive
     (progn
       (unless grep-find-command
	 (grep-compute-defaults))
       (list (shell-command-read-minibuffer grep-find-prompt
					    default-directory
					    grep-find-command
					    nil nil 'grep-find-history))))))

;;;###autoload
(defun shell-command-activate-advices ()
  (let ((commands '(shell-command shell-command-on-region grep grep-find)))
    (while commands
      (funcall (if shell-command-enable-completions
		   'ad-enable-advice
		 'ad-disable-advice)
	       (car commands)
	       'before
	       (intern (concat (symbol-name (car commands))
			       "-with-completion")))
      (ad-activate (car commands))
      (setq commands (cdr commands)))))

(provide 'shell-command)

;;; shell-command.el ends here
