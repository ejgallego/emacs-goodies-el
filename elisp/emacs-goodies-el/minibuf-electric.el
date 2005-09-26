;;; minibuf-electric.el -- Electric minibuffer behavior from XEmacs.
;;;
;;; Modified by Karl Hegbloom for GNU Emacs.  Taken from XEmacs 21.4
;;; "lisp/minibuf.el".  It needs fine tuning and placement in a
;;; suitable location within the GNU Emacs Lisp tree.  See below for
;;; notes concerning key-maps.
;;;
;;; Submitted for inclusion in the Debian `emacs-goodies-el' package.
;;;
;;; GPL.


(defcustom minibuffer-electric-file-name-behavior t
  "*If non-nil, slash and tilde in certain places cause immediate deletion.
These are the same places where this behavior would occur later on anyway,
in `substitute-in-file-name'."
  :type 'boolean
  :require 'minibuf-electric
  :group 'minibuffer)


;;; originally by Stig@hackvan.com, taken from XEmacs 21.4
;;;
(defun minibuffer-electric-separator ()
  (interactive)
  (let ((c last-command-char))
    (and minibuffer-completing-file-name ; added for GNU Emacs
	 minibuffer-electric-file-name-behavior
	 (eq c directory-sep-char)
	 (eq c (char-before (point)))
	 (not (save-excursion		;; ange-ftp, tramp
		(goto-char (minibuffer-prompt-end))
		(and (looking-at "/.+:~?[^/]*/.+")
		     (re-search-forward "/.+:~?[^/]*" nil t)
		     (progn
		       (delete-region (point) (point-max))
		       t))))
	 (not (save-excursion
		(goto-char (minibuffer-prompt-end))
		(and (looking-at ".+://[^/]*/.+")
		     (re-search-forward ".+:/" nil t)
		     (progn
		       (delete-region (point) (point-max))
		       t))))
	 ;; permit `//hostname/path/to/file'
	 (not (eq (point) (1+ (minibuffer-prompt-end))))
	 ;; permit `http://url/goes/here'
	 (or (not (eq ?: (char-after (- (point) 2))))
	     (eq ?/ (char-after (minibuffer-prompt-end))))
       (delete-region (minibuffer-prompt-end) (point)))
    (insert c)))

(defun minibuffer-electric-tilde ()
  (interactive)
  (and minibuffer-completing-file-name	; Added for GNU Emacs
       minibuffer-electric-file-name-behavior
       (eq directory-sep-char (char-before (point)))
       ;; permit URL's with //, for e.g. http://hostname/~user
       (not (save-excursion (search-backward "//" (minibuffer-prompt-end) t)))
       (delete-region (minibuffer-prompt-end) (point)))
  (insert ?~))


;;; This is really not quite right, but I don't know how to do the
;;; right thing yet.  What's the matter is that these keys should
;;; really only be bound when the minibuffer is reading a file name.
;;; I'm afraid that these key maps may be too general and might be the
;;; ones used when reading other things.  If they really are used only
;;; for reading file names, then I think they are mis-named, and
;;; should be named more specifically.
;;;
;;; For now, it works for me with `find-file', `find-alternate-file',
;;; and `write-file', which all seem to use
;;; `minibuffer-local-completion-map'.  The `insert-file' defun uses
;;; the `minibuffer-local-must-match-map'.

(define-key minibuffer-local-completion-map
  (char-to-string directory-sep-char)
  #'minibuffer-electric-separator)

(define-key minibuffer-local-must-match-map
  (char-to-string directory-sep-char)
  #'minibuffer-electric-separator)

(define-key minibuffer-local-completion-map "~" #'minibuffer-electric-tilde)
(define-key minibuffer-local-must-match-map "~" #'minibuffer-electric-tilde)

(provide 'minibuf-electric)
