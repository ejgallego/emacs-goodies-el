;; htmlize.el -- HTML-ize font-lock buffers

;; Copyright (C) 1997,1998,1999,2000,2001,2002,2003 Hrvoje Niksic

;; Author: Hrvoje Niksic <hniksic@xemacs.org>
;; Keywords: hypermedia, extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This package analyses the text properties of the buffer and
;; converts them, along with the text, to HTML.  Mail to
;; <hniksic@xemacs.org> to discuss features and additions.  All
;; suggestions are more than welcome.

;; To use, just switch to a buffer you want HTML-ized, and type `M-x
;; htmlize-buffer'.  After that, you should find yourself in an HTML
;; buffer, which you can edit and save with C-x C-w.  Alternatively,
;; `M-x htmlize-file' will find a file, font-lockify the buffer, and
;; save the HTML version, all before you blink.  Furthermore, `M-x
;; htmlize-many-files' will prompt you for a slew of files to undergo
;; the same treatment.  `M-x htmlize-many-files-dired' will do the
;; same for the files marked by dired.

;; The code attempts to generate compliant HTML, but I can't make any
;; guarantees; I haven't yet bothered to run the generated markup
;; through a validator.  I tried to make the package elisp-compatible
;; with multiple Emacsen, specifically aiming for XEmacs 19.14+ and
;; GNU Emacs 19.34+.  Please let me know if it doesn't work on any of
;; those, and I'll try to fix it.  I relied heavily on the presence of
;; CL extensions, especially for compatibility; please don't try to
;; remove that dependency.

;; When compiling under GNU Emacs, you're likely to get oodles of
;; warnings; ignore them all.  For any of this to work, you need to
;; run Emacs under a window-system -- anything else will almost
;; certainly fail.

;; The latest version should be available at:
;;
;;        <http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el>
;;
;; You can find the sample htmlize output (possibly run on an older
;; version of `htmlize.el') at:
;;
;;        <http://fly.srk.fer.hr/~hniksic/emacs/htmlize.html>
;;

;; Thanks go to:
;;   * Ron Gut <rgut@aware.com>, for useful additions (hooks and
;;     stuff);
;;
;;   * Bob Weiner <weiner@altrasoft.com>, for neat ideas (use of
;;     rgb.txt and caching color strings);
;;
;;   * Toni Drabik <tdrabik@public.srce.hr>, for a crash course to
;;     CSS1.
;;
;;   * Peter Breton <pbreton@ne.mediaone.net>, for useful suggestions
;;     (multiple file stuff) and dired code.
;;
;;   * Thomas Vogels <tov@ece.cmu.edu> and Juanma Barranquero
;;     <barranquero@laley-actualidad.es> for contributing fixes.
;;
;;   * A bunch of other people for sending reports and useful
;;     comments.  I will not attempt to name them because I will
;;     surely forget some.
;;

;; TODO: Should attempt to merge faces (utilize CSS for this?).

;; User quotes: "You sir, are a sick, sick, _sick_ person. :)"
;;                  -- Bill Perry, author of Emacs/W3


;;; Code:

(require 'cl)
(eval-when-compile
  (if (string-match "XEmacs" emacs-version)
      (byte-compiler-options
	(warnings (- unresolved))))
  (defvar font-lock-auto-fontify)
  (defvar global-font-lock-mode))

(defconst htmlize-version "0.71")

;; Incantations to make custom stuff work without customize, e.g. on
;; XEmacs 19.14 or GNU Emacs 19.34.
(eval-and-compile
  (condition-case ()
      (require 'custom)
    (error nil))
  (if (and (featurep 'custom) (fboundp 'custom-declare-variable))
      nil ;; We've got what we needed
    ;; We have the old custom-library, hack around it!
    (defmacro defgroup (&rest args)
      nil)
    (defmacro defcustom (var value doc &rest args) 
      (` (defvar (, var) (, value) (, doc))))
    (defmacro defface (face value doc &rest stuff)
      `(make-face ,face))))

(defgroup htmlize nil
  "HTMLize font-locked buffers."
  :group 'hypermedia)

(defcustom htmlize-head-tags ""
  "*Additional tags to insert within HEAD of the generated document."
  :type 'string
  :group 'htmlize)

(defcustom htmlize-output-type 'css
  "*Output type of generated HTML.  Legal values are `css' and `font'.
When set to `css' (the default), htmlize will generate a style sheet
with description of faces, and use it in the HTML document, specifying
the faces in the actual text with <span class=\"FACE\">.

When set to `font', the properties will be set using layout tags
<font>, <b>, <i>, <u>, and <strike>.

`css' output is normally preferred, but `font' is still useful for
supporting old, pre-CSS browsers, or for easy embedding of colorized
text in foreign HTML documents (no style sheet to carry around) ."
  :type '(choice (const css) (const font))
  :group 'htmlize)

(defcustom htmlize-generate-hyperlinks t
  "*Non-nil means generate the hyperlinks for URLs and mail addresses.
This is on by default; set it to nil if you don't want htmlize to
insert hyperlinks in the resulting HTML.  (In which case you can still
do your own hyperlinkification from htmlize-after-hook.)"
  :type 'boolean
  :group 'htmlize)

(defcustom htmlize-hyperlink-style "\
      a {
        color: inherit;
        background-color: inherit;
        font: inherit;
        text-decoration: inherit;
      }
      a:hover {
        text-decoration: underline;
      }
"
  "*The CSS style used for hyperlinks when in CSS mode."
  :type 'string
  :group 'htmlize)

(defcustom htmlize-css-name-prefix ""
  "*The prefix to use for CSS names.

The CSS names that htmlize generates from face names are often too
generic for CSS files; for example, `font-lock-type-face' is transformed
to `type'.  Use this variable to add a prefix to the generated names.
The string \"htmlize-\" is an example of a reasonable prefix."
  :type 'string
  :group 'htmlize)

(defcustom htmlize-use-rgb-map t
  "*Controls when `rgb.txt' should be looked up for color values.

When set to t (the default), htmlize will, when running under an X
display, look for the `rgb.txt' file and use it to obtain the RGB
values for named colors.  This is useful when the values reported by
`color-instance-rgb-components'/`x-color-values' are incorrect because
of color approximation.

When set to nil, htmlize will never look for `rgb.txt' and will always
use the values Emacs returns.

When set to `force', htmlize will try to look for `rgb.txt' even on
non-X devices."
  :type '(choice (const :tag "When Appropriate" t)
		 (const :tag "Never"          nil)
		 (const :tag "Always"       force))
  :group 'htmlize)

(defcustom htmlize-html-major-mode nil
  "The mode the newly created HTML buffer will be put in.
Set this to nil if you prefer the default (fundamental) mode."
  :type '(radio (const :tag "No mode (fundamental)" nil)
		 (function-item html-mode)
		 (function :tag "User-defined major mode"))
  :group 'htmlize)

(defvar htmlize-before-hook nil
  "Hook run before htmlizing a buffer.
The hook is run in the original buffer (not HTML buffer), so you may
wish to add `font-lock-fontify-buffer' here.")

(defvar htmlize-after-hook nil
  "Hook run after htmlizing a buffer.
Unlike `htmlize-before-hook', these functions are run in the HTML
buffer.  You may use them to modify the outlook of the final HTML
output.")

(defvar htmlize-file-hook nil
  "Hook run after htmlizing a file, and before writing it out to disk.
This is run by the `htmlize-file'.")

;; I try to conditionalize on features rather than Emacs version, but
;; in some cases checking against the version *is* necessary.
(defconst htmlize-running-xemacs (string-match "XEmacs" emacs-version))


;;; Protection of HTML strings.

;; Currently we don't handle non-ASCII characters specially: they are
;; copied to the output buffer as-is.  The user is expected to make
;; them work, e.g. by filling in a META tag in htmlize-head-tags.
;;
;; This is because IMHO doing nothing is (in this case) better than
;; doing the wrong thing and corrupting data.  Doing the right thing
;; is *hard* because it would require converting Emacs characters to
;; Unicode code points.  Making this work under different versions of
;; Mule is tricky and would require large conversion tables.  What's
;; worse, making it work under non-Mule Emacsen is next to impossible
;; because the meaning of 8-bit characters depends on the locale and
;; font in use.  (Contrary to popular belief, you cannot assume that
;; characters in the 160-255 range are Latin 1.)

(if (fboundp 'char-int)
    (defalias 'htmlize-char-int 'char-int)
  (defalias 'htmlize-char-int 'identity))

(defvar htmlize-character-table
  (let ((table (make-vector 256 ?\0)))
    (dotimes (i 256)
      (setf (aref table i) (char-to-string i)))
    (setf (aref table ?&) "&amp;"
	  (aref table ?<) "&lt;"
	  (aref table ?>) "&gt;"
	  (aref table ?\") "&quot;")
    table))

(defun htmlize-protect-string (string)
  ;; Checking whether STRING contains dangerous stuff removes a lot of
  ;; unnecessary consing.
  (if (not (string-match "[&<>\"]" string))
      string
    (mapconcat (lambda (char)
		 (if (> (htmlize-char-int char) 255)
		     ;; Leave multibyte characters as they are, see
		     ;; above for explanation.
		     (char-to-string char)
		   (aref htmlize-character-table char)))
	       string "")))

;;; Color handling.

(if (fboundp 'locate-file)
    (defalias 'htmlize-locate-file 'locate-file)
  (defun htmlize-locate-file (file path)
    (dolist (dir path nil)
      (when (file-exists-p (expand-file-name file dir))
	(return (expand-file-name file dir))))))

(if (fboundp 'file-name-extension)
    (defalias 'htmlize-file-name-extension 'file-name-extension)
  (defun htmlize-file-name-extension (filename &optional period)
    (let ((file (file-name-sans-versions (file-name-nondirectory filename))))
      (and (string-match "\\.[^.]*\\'" file)
	   (substring file (+ (match-beginning 0) (if period 0 1)))))))

(eval-and-compile
  ;; I hate having replacement macros which are not colorized or
  ;; indented properly, so I'll just define save-current-buffer and
  ;; with-current-buffer if I can't find them.  htmlize is hardly a
  ;; package that you use all the time, so that should be fine.
  (unless (fboundp 'save-current-buffer)
    (defmacro save-current-buffer (&rest forms)
      `(let ((__scb_current (current-buffer)))
	 (unwind-protect
	     (progn ,@forms)
	   (set-buffer __scb_current)))))
  (unless (fboundp 'with-current-buffer)
    (defmacro with-current-buffer (buffer &rest forms)
      `(save-current-buffer (set-buffer ,buffer) ,@forms)))
  (unless (fboundp 'with-temp-buffer)
    (defmacro with-temp-buffer (&rest forms)
      (let ((temp-buffer (gensym "tb-")))
	`(let ((,temp-buffer
		(get-buffer-create (generate-new-buffer-name " *temp*"))))
	   (unwind-protect
	       (with-current-buffer ,temp-buffer
		 ,@forms)
	     (and (buffer-live-p ,temp-buffer)
		  (kill-buffer ,temp-buffer))))))))

;; We need a function that efficiently finds the next change of a
;; property (usually `face'), preferably regardless of whether the
;; change occurred because of a text property or an extent/overlay.
;; As it turns out, it is not easy to do that compatibly.

;; Under XEmacs, `next-single-property-change' does that.  Under GNU
;; Emacs beginning with version 21, `next-single-char-property-change'
;; is available and works.  GNU Emacs 20 had
;; `next-char-property-change', which we can use.  GNU Emacs 19 didn't
;; provide any means for simultaneously examining overlays and text
;; properties, so when using Emacs 19.34, we punt and fall back to
;; `next-single-property-change', thus ignoring overlays altogether.

(cond
 (htmlize-running-xemacs
  ;; XEmacs: good.
  (defalias 'htmlize-next-change 'next-single-property-change))
 ((fboundp 'next-single-char-property-change)
  ;; GNU Emacs 21: good.
  (defalias 'htmlize-next-change 'next-single-char-property-change))
 ((fboundp 'next-char-property-change)
  ;; GNU Emacs 20: bad, but fixable.
  (defun htmlize-next-change (pos prop)
    (let ((done nil)
	  (current-value (get-char-property pos prop))
	  newpos next-value)
      ;; Loop over positions returned by next-char-property-change
      ;; until the value of PROP changes or we've hit EOB.
      (while (not done)
	(setq newpos (next-char-property-change pos)
	      next-value (get-char-property newpos prop))
	(cond ((eq newpos pos)
	       ;; Possibly at EOB?  Whatever, just don't infloop.
	       (setq done t))
	      ((eq next-value current-value)
	       ;; PROP hasn't changed -- keep looping.
	       )
	      (t
	       (setq done t)))
	(setq pos newpos))
      pos)))
 (t
  ;; GNU Emacs 19.34: hopeless.
  (defalias 'htmlize-next-change 'next-single-property-change)))

(defvar htmlize-x-library-search-path
  '("/usr/X11R6/lib/X11/"
    "/usr/X11R5/lib/X11/"
    "/usr/lib/X11R6/X11/"
    "/usr/lib/X11R5/X11/"
    "/usr/local/X11R6/lib/X11/"
    "/usr/local/X11R5/lib/X11/"
    "/usr/local/lib/X11R6/X11/"
    "/usr/local/lib/X11R5/X11/"
    "/usr/X11/lib/X11/"
    "/usr/lib/X11/"
    "/usr/local/lib/X11/"
    "/usr/X386/lib/X11/"
    "/usr/x386/lib/X11/"
    "/usr/XFree86/lib/X11/"
    "/usr/unsupported/lib/X11/"
    "/usr/athena/lib/X11/"
    "/usr/local/x11r5/lib/X11/"
    "/usr/lpp/Xamples/lib/X11/"
    "/usr/openwin/lib/X11/"
    "/usr/openwin/share/lib/X11/"))

(defun htmlize-get-color-rgb-hash (&optional rgb-file)
  "Return a hash table mapping X color names to RGB values.
The keys to the hash table are X color names as strings, and the
values are the #rrggbb RGB specifications, extracted from `rgb.txt'.

If RGB-FILE is nil, the function will try hard to find a suitable file
in the system directories."
  (let ((rgb-file (or rgb-file (htmlize-locate-file
				"rgb.txt"
				htmlize-x-library-search-path)))
	(hash (make-hash-table :test 'equal)))
    (with-temp-buffer
      (insert-file-contents rgb-file)
      (while (not (eobp))
	(cond ((looking-at "^\\s-*\\([!#]\\|$\\)")
	       ;; Skip comments and empty lines.
	       )
	      ((looking-at "[ \t]*\\([0-9]+\\)[ \t]+\\([0-9]+\\)[ \t]+\\([0-9]+\\)[ \t]+\\(.*\\)")
	       (setf (gethash (downcase (match-string 4)) hash)
		     (format "#%02x%02x%02x"
			     (string-to-number (match-string 1))
			     (string-to-number (match-string 2))
			     (string-to-number (match-string 3)))))
	      (t
	       (error "Unrecognized line in rgb.txt: %s"
		      (buffer-substring (point) (progn (end-of-line) (point))))))
	(forward-line 1)))
    hash))

(defvar htmlize-color-rgb-hash nil)
(and (or (eq htmlize-use-rgb-map 'force)
	 (and (eq htmlize-use-rgb-map t)
	      (eq window-system 'x)))
     (null htmlize-color-rgb-hash)
     (setq htmlize-color-rgb-hash (htmlize-get-color-rgb-hash)))

;;; Face handling

;; (htmlize-face-foreground FACE) should return the foreground color
;; of the face, either as color name string or as #rrggbb string.
(cond ((fboundp 'face-foreground-name)
       ;; XEmacs 20.4 and later.
       (defalias 'htmlize-face-foreground 'face-foreground-name)
       (defalias 'htmlize-face-background 'face-background-name))
      ((fboundp 'color-instance-name)
       ;; XEmacs before 20.4, hopefully
       (defun htmlize-face-foreground (face)
	 (color-instance-name (face-foreground-instance face)))
       (defun htmlize-face-background (face)
	 (color-instance-name (face-background-instance face))))
      ((fboundp 'x-color-values)
       ;; FSF Emacs
       (defun htmlize-face-foreground (face)
	 (let ((color (or (face-foreground face)
			  (face-foreground 'default)
			  (cdr (assq 'foreground-color (frame-parameters))))))
	   (if (or (null color)
		   (equal color "unspecified-fg")
		   (equal color "unspecified-bg"))
	       ;; Assuming black foreground doesn't seem right, but I
	       ;; can't think of anything better to do.
	       "black"
	     color)))
       (defun htmlize-face-background (face)
	 (let ((color (or (face-background face)
			  (face-background 'default)
			  (cdr (assq 'background-color (frame-parameters))))))
	   (if (or (null color)
		   (equal color "unspecified-fg")
		   (equal color "unspecified-bg"))
	       ;; Assuming white background doesn't seem right, but I
	       ;; can't think of anything better to do.
	       "white"
	     color))))
      (t
       (error "WTF?!")))

(if (fboundp 'find-face)
    (defalias 'htmlize-symbol-face-p 'find-face)
  (defalias 'htmlize-symbol-face-p 'facep))

;; Return the #rrggbb string for foreground color of FACE.  If BG-P is
;; non-nil, background color is used.
(defun htmlize-face-rgb-string-direct (face &optional bg-p)
  (apply #'format "#%02x%02x%02x"
	 ;; Here I cannot conditionalize on (fboundp ...) because
	 ;; ps-print under some versions of GNU Emacs defines its own
	 ;; dummy version of color-instance-rgb-components.
	 (if htmlize-running-xemacs
	     (mapcar (lambda (arg)
		       (/ arg 256))
		     (color-instance-rgb-components
		      (if bg-p
			  (face-background-instance face)
			(face-foreground-instance face))))
	   (mapcar (lambda (arg)
		     (/ arg 256))
		   (x-color-values (if bg-p (htmlize-face-background face)
				     (htmlize-face-foreground face)))))))

(defun htmlize-face-rgb-string (face &optional bg-p)
  (if (and htmlize-use-rgb-map
	   htmlize-color-rgb-hash)
      (let* ((oname (downcase (if bg-p (htmlize-face-background face)
				(htmlize-face-foreground face))))
	     (name (if (string-match "^#" oname)
		       oname
		     (gethash oname htmlize-color-rgb-hash))))
	(unless name
	  (error "Something is rotten (face %s, color %s)" face oname))
	name)
    (htmlize-face-rgb-string-direct face bg-p)))

(defstruct htmlize-face
  rgb-foreground			; foreground color, #rrggbb
  rgb-background			; background color, #rrggbb
  boldp					; whether face is bold
  italicp				; whether face is italic
  underlinep				; whether face is underlined
  strikep				; whether face is strikethrough
  css-name				; CSS name of face
  )
(defvar htmlize-face-hash (make-hash-table :test 'eq))

(defun htmlize-make-face-hash (faces)
  (clrhash htmlize-face-hash)
  (let (face-fancy-names b-font i-font bi-font use-bi use-i)
    (when htmlize-running-xemacs
      (setq b-font (face-font-name 'bold)
	    i-font (face-font-name 'italic)
	    bi-font (face-font-name 'bold-italic)
	    use-bi (not (or (equal b-font bi-font) (equal i-font bi-font)))
	    use-i (not (equal b-font i-font))))
    (dolist (face faces)
      (let ((object (make-htmlize-face
		     :rgb-foreground (htmlize-face-rgb-string face)
		     :rgb-background (htmlize-face-rgb-string face t)
		     :underlinep (face-underline-p face))))
	;; Portability junk -- there is no good way of detecting
	;; whether a face is bold or italic under XEmacs, so I need to
	;; resort to disgusting hacks.  Please close your eyes lest
	;; you vomit or spontaneously combust.
	(if htmlize-running-xemacs
	    (let* ((font (face-font-name face)))
	      ;; Boldness, XEmacs
	      (setf (htmlize-face-boldp object)
		    (or (equal font (face-font-name 'bold))
			(and use-bi
			     (equal font (face-font-name 'bold-italic)))))
	      ;; Italic-ness, XEmacs
	      (setf (htmlize-face-italicp object)
		    (and use-i
			 (or (equal font (face-font-name 'italic))
			     (and use-bi
				  (equal font (face-font-name 'bold-italic))))))
	      ;; OK, you may open them again.
	      ;; Strikethrough, XEmacs
	      (setf (htmlize-face-strikep object) (face-strikethru-p face)))
	  (when (fboundp 'face-bold-p)
	     ;; Boldness, GNU Emacs 20
	    (setf (htmlize-face-boldp object) (face-bold-p face)))
	  (when (fboundp 'face-italic-p)
	    ;; Italic-ness, GNU Emacs
	    (setf (htmlize-face-italicp object) (face-italic-p face)))
	  ;; Strikethrough is not supported by GNU Emacs.
	  (setf (htmlize-face-strikep object) nil))

	;; css-name.  Emacs is lenient about face names -- virtually
	;; any string may name a face, even those consisting of
	;; characters such as ^@.  We try hard to beat the face name
	;; into shape, both esthetically and according to CSS1 specs.
	(setf (htmlize-face-css-name object)
	      (let ((name (downcase (symbol-name face))))
		(when (string-match "\\`font-lock-" name)
		  (setq name (replace-match "" t t name)))
		(when (string-match "-face\\'" name)
		  (setq name (replace-match "" t t name)))
		(while (string-match "[^-a-zA-Z0-9]" name)
		  (setq name (replace-match "X" t t name)))
		(when (string-match "^[-0-9]" name)
		  (setq name (concat "X" name)))
		;; After these transformations, the face could come
		;; out empty.
		(when (equal name "")
		  (setq name "face"))
		;; Apply the prefix.
		(setq name (concat htmlize-css-name-prefix name))
		(let ((i 1))
		  (while (member name face-fancy-names)
		    (setq name (format "%s-%d" name i))
		    (incf i)))
		(push name face-fancy-names)
		name))
	;; Hash it away.
	(setf (gethash face htmlize-face-hash) object)))))

(defun htmlize-faces-in-buffer ()
  "Return a list of faces used by the extents in the current buffer."
  (let (faces)
    ;; just (fboundp 'map-extents) is not enough because W3 defines
    ;; its own variant of `map-extents' under FSF.
    (if (and (fboundp 'map-extents)
	     (string-match "XEmacs" emacs-version))
	(map-extents (lambda (extent ignored)
		       (let ((face (extent-face extent)))
			 (when (consp face)
			   (setq face (car face)))
			 (when (htmlize-symbol-face-p face)
			   (pushnew face faces)))
		       nil)
		     nil nil nil nil nil 'face)
      ;; FSF Emacs code.  This code is not limited to text properties
      ;; and would work correctly under XEmacs, but the above is
      ;; measured to be twice faster, probably because map-extents
      ;; with a PROPERTY argument is more optimized than looping
      ;; through `htmlize-next-change'.
      (save-excursion
	(goto-char (point-min))
	(let (face next)
	  (while (not (eobp))
	    (setq face (get-char-property (point) 'face)
		  next (or (htmlize-next-change (point) 'face)
			   (point-max)))
	    (when (consp face)
	      (setq face (car face)))
	    (when (htmlize-symbol-face-p face)
	      (pushnew face faces))
	    (goto-char next)))
	(setq faces (delq nil faces))))

    (delq 'default faces)))

;;; CSS1 support

(defun htmlize-css-doctype ()
  nil					; no doc-string
  "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\">")

;; Internal function; not a method.
(defun htmlize-css-specs (face-object &optional default-face-object)
  (let (result)
    (when (or (not default-face-object)
	      (not (equal (htmlize-face-rgb-foreground face-object)
			  (htmlize-face-rgb-foreground default-face-object))))
      (push (format "color: %s;" (htmlize-face-rgb-foreground face-object))
	    result))
    ;; Specification of background-color used to be conditionalized
    ;; like this, to ensure that we specify the background color only
    ;; for faces that differ from the default face:
    ;;    (when (or (not default-face-object)
    ;;              (not (equal (htmlize-face-rgb-background face-object)
    ;;                          (htmlize-face-rgb-background default-face-object))))
    ;; However, Josh Howard <jrh@zeppelin.net> reports that the
    ;; `background-color' property is not inheritable and needs to be
    ;; specified everywhere where `color' is.
    (push (format "background-color: %s;"
		  (htmlize-face-rgb-background face-object)) result)
    (when (and (htmlize-face-boldp face-object)
	       (or (not default-face-object)
		   (not (htmlize-face-boldp default-face-object))))
      (push "font-weight: bold;" result))
    (when (and (htmlize-face-italicp face-object)
	       (or (not default-face-object)
		   (not (htmlize-face-italicp default-face-object))))
      (push "font-style: italic;" result))
    (when (and (htmlize-face-underlinep face-object)
	       (or (not default-face-object)
		   (not (htmlize-face-underlinep default-face-object))))
      (push "text-decoration: underline;" result))
    (when (and (htmlize-face-strikep face-object)
	       (or (not default-face-object)
		   (not (htmlize-face-strikep default-face-object))))
      (push "text-decoration: line-through;" result))
    (nreverse result)))

(defun htmlize-css-insert-head ()
  (insert "    <style type=\"text/css\">\n    <!--\n")
  (let ((default-face-object (gethash 'default htmlize-face-hash)))
    (insert "      body {\n        "
	    (mapconcat #'identity (htmlize-css-specs default-face-object)
		       "\n        ")
	    "
      } /* default */\n")
    (maphash
     (lambda (face face-object)
       (let ((cleaned-up-face-name (symbol-name face)))
	 ;; If face name contains `--' or `*/', we must nix them out.
	 (while (string-match "--" cleaned-up-face-name)
	   (setq cleaned-up-face-name (replace-match "-" t t
						     cleaned-up-face-name)))
	 (while (string-match "\\*/" cleaned-up-face-name)
	   (setq cleaned-up-face-name (replace-match "XX" t t
						     cleaned-up-face-name)))
	 (unless (eq face 'default)
	   (let ((specs (htmlize-css-specs face-object default-face-object)))
	     (insert "      ." (htmlize-face-css-name face-object))
	     (if (null specs)
		 (insert " {")
	       (insert " {\n        "
		       (mapconcat #'identity specs "\n        ")))
	     (insert "\n      } /* " cleaned-up-face-name " */\n")))))
     htmlize-face-hash))
  (insert htmlize-hyperlink-style
	  "    -->\n    </style>\n"))

(defun htmlize-css-face-prejunk (face-object)
  (concat "<span class=\"" (htmlize-face-css-name face-object) "\">"))
(defun htmlize-css-face-postjunk (face-object)
  nil					; no doc-string
  "</span>")

;;; <font> support

(defun htmlize-font-doctype ()
  nil					; no doc-string

  ;; According to DTDs published by the W3C, it is illegal to embed
  ;; <font> in <pre>.  This makes sense in general, but is bad for
  ;; htmlize's intended usage of <font> to specify the document color.

  ;; To make generated HTML legal, htmlize.el used to specify the SGML
  ;; declaration of "HTML Pro" DTD here.  HTML Pro aka Silmaril DTD
  ;; was a project whose goal was to produce a DTD that would
  ;; encompass all the incompatible HTML extensions procured by
  ;; Netscape, MSIE, and other players in the field.  Apparently the
  ;; project got abandoned, the last available version being "Draft 0
  ;; Revision 11" from January 1997, as documented at
  ;; <http://validator.w3.org/sgml-lib/pro/html/dtds/htmlpro.html>.

  ;; Since by now (2001) HTML Pro is remembered by none but the most
  ;; die-hard early-web-days nostalgics and used by not even them,
  ;; there is no use in specifying it.  So we return the standard HTML
  ;; 4.0 declaration, which makes generated HTML technically illegal.
  ;; If you have a problem with that, use the `css' generation engine
  ;; which I believe creates fully conformant HTML.

  "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\">"

  ;; Now-abandoned HTML Pro declaration.
  ;"<!DOCTYPE HTML PUBLIC \"+//Silmaril//DTD HTML Pro v0r11 19970101//EN\">"
  )

(defun htmlize-font-body-tag ()
  (let ((face-object (gethash 'default htmlize-face-hash)))
    (format "<body text=\"%s\" bgcolor=\"%s\">"
	    (htmlize-face-rgb-foreground face-object)
	    (htmlize-face-rgb-background face-object))))
(defun htmlize-font-face-prejunk (face-object)
  (concat "<font color=\"" (htmlize-face-rgb-foreground face-object) "\">"
	  (and (htmlize-face-boldp      face-object) "<b>")
	  (and (htmlize-face-italicp    face-object) "<i>")
	  (and (htmlize-face-underlinep face-object) "<u>")
	  (and (htmlize-face-strikep    face-object) "<strike>")))
(defun htmlize-font-face-postjunk (face-object)
  (concat (and (htmlize-face-strikep    face-object) "</strike>")
	  (and (htmlize-face-underlinep face-object) "</u>")
	  (and (htmlize-face-italicp    face-object) "</i>")
	  (and (htmlize-face-boldp      face-object) "</b>")
	  "</font>"))

(defun htmlize-despam-address (string)
  "Replace every occurrence of '@' in STRING with &#64;.
`htmlize-make-hyperlinks' uses this to spam-protect mailto links
without modifying their meaning."
  ;; Suggested by Ville Skytta.
  (while (string-match "@" string)
    (setq string (replace-match "&#64;" nil t string)))
  string)

(defun htmlize-make-hyperlinks ()
  "Make hyperlinks in HTML."
  ;; Function originally submitted by Ville Skytta.  Rewritten by
  ;; Hrvoje Niksic, then modified by Ville Skytta and Hrvoje Niksic.
  (goto-char (point-min))
  (while (re-search-forward
	  "&lt;\\(\\(mailto:\\)?\\([-=+_.a-zA-Z0-9]+@[-_.a-zA-Z0-9]+\\)\\)&gt;"
	  nil t)
    (let ((address (match-string 3))
	  (link-text (match-string 1)))
      (delete-region (match-beginning 0) (match-end 0))
      (insert "&lt;<a href=\"mailto:"
	      (htmlize-despam-address address)
	      "\">"
	      (htmlize-despam-address link-text)
	      "</a>&gt;")))
  (goto-char (point-min))
  (while (re-search-forward "&lt;\\(\\(URL:\\)?\\([a-zA-Z]+://[^;]+\\)\\)&gt;"
			    nil t)
    (let ((url (match-string 3))
	  (link-text (match-string 1)))
      (delete-region (match-beginning 0) (match-end 0))
      (insert "&lt;<a href=\"" url "\">" link-text "</a>&gt;"))))

;; Tests for htmlize-make-hyperlinks:

;; <mailto:hniksic@xemacs.org>
;; <http://fly.srk.fer.hr>
;; <URL:http://www.xemacs.org>
;; <http://www.mail-archive.com/bbdb-info@xemacs.org/>
;; <hniksic@xemacs.org>
;; <xalan-dev-sc.10148567319.hacuhiucknfgmpfnjcpg-john=doe.com@xml.apache.org>

;;; Buffer text transformation: ignoring invisible text, on-the-fly
;;; untabification, etc.

(defun htmlize-buffer-substring (beg end)
  ;; Like buffer-substring-no-properties, but also ignores invisible
  ;; text.
  (if (not (text-property-not-all beg end 'invisible nil))
      ;; Make the simple case fast: if the region contains no
      ;; invisible text, use the buffer-substring-no-properties
      ;; builtin.
      (buffer-substring-no-properties beg end)
    ;; Iterate over the changes in the `invisible' property and filter
    ;; out the portions where it's non-nil, i.e. where the text is
    ;; invisible.
    (let ((visible-text ())
	  invisible next-change)
      (save-excursion
	(save-restriction
	  (narrow-to-region beg end)
	  (goto-char (point-min))
	  (while (not (eobp))
	    (setq invisible (get-char-property (point) 'invisible)
		  next-change (or (htmlize-next-change (point) 'invisible)
				  (point-max)))
	    (unless invisible
	      (push (buffer-substring-no-properties (point) next-change)
		    visible-text))
	    (goto-char next-change))))
      (apply #'concat (nreverse visible-text)))))

(defun htmlize-untabify-1 (line start-column)
  ;; Replaces tabs in LINE with the number of spaces sufficient to
  ;; reach the next tabstop.  The tabstops are positioned at locations
  ;; proportional to tab-width -- e.g. 0, 8, 16, etc. for tab-width 8.
  ;; This works correctly only for single-line strings; for a
  ;; multiline interface, see htmlize-untabify.
  (while (string-match "\t" line)
    (let* ((tabpos (match-beginning 0))
	   (column (+ start-column tabpos))
	   (tabsize (- tab-width (% column tab-width))))
      ;; Replace the tab with TABSIZE spaces.
      (setq line (concat (substring line 0 tabpos)
			 (make-string tabsize ?\ )
			 (substring line (1+ tabpos))))))
  line)

(defun htmlize-untabify (text start-column)
  "Untabify TEXT, assuming it starts at START-COLUMN."
  ;; Since htmlize-untabify-1 works only on single lines, iterate the
  ;; string line by line and untabify each line.  It's possible to
  ;; rewrite htmlize-untabify-1 to work with multiple-line strings,
  ;; but that function conses four strings for each tab and becomes
  ;; really slow with large inputs.  Therefore it's actually a good
  ;; idea to feed it smaller chunks.
  (let ((output nil)
	(line-beg 0)
	(textlen (length text)))
    (while (< line-beg textlen)
      (let* ((line-end (or (and (string-match "\n" text line-beg)
				(1+ (match-beginning 0)))
			   textlen))
	     (line (substring text line-beg line-end)))
	;; Untabify the line and push it to OUTPUT.
	(push (htmlize-untabify-1 line start-column) output)
	;; START-COLUMN is only valid for the first line.
	(setq start-column 0)
	;; Advance to the next position in TEXT.
	(setq line-beg line-end)))
    (apply #'concat (nreverse output))))

(defmacro htmlize-method (method &rest args)
  (let ((func (gensym "hm-")))
    `(let ((,func (intern (format "htmlize-%s-%s" htmlize-output-type ',method))))
       (and (fboundp ,func)
	    (funcall ,func ,@args)))))

(defun htmlize-buffer-1 ()
  ;; Internal function; don't call it from outside this file.  Htmlize
  ;; current buffer, writing the resulting HTML to a new buffer, and
  ;; return it.  Unlike htmlize-buffer, this doesn't change current
  ;; buffer or use switch-to-buffer.

  (save-excursion
    ;; Protect against the hook changing the current buffer.
    (save-excursion
      (run-hooks 'htmlize-before-hook))
    (htmlize-make-face-hash (cons 'default (htmlize-faces-in-buffer)))
    ;; Generate the new buffer.  It should inherit default-directory
    ;; from the current buffer.
    (let* ((htmlbuf (generate-new-buffer (if (buffer-file-name)
					     (htmlize-make-file-name
					      (file-name-nondirectory
					       (buffer-file-name)))
					   "*html*")))
	   (title (buffer-name (current-buffer)))
	   next-change text face face-object)
      ;; Initialize HTMLBUF and insert the HTML prolog.
      (with-current-buffer htmlbuf
	(buffer-disable-undo)
	(insert (htmlize-method doctype) ?\n
		(format "<!-- Created by htmlize-%s in %s mode. -->\n"
			htmlize-version htmlize-output-type)
		"<html>\n  <head>\n    <title>"
		(htmlize-protect-string title)
		"</title>\n" htmlize-head-tags)
	(htmlize-method insert-head)
	(insert "  </head>"
		"\n  "
		(or (htmlize-method body-tag)
		    "<body>")
		"\n    <pre>\n"))
      ;; This loop traverses and reads the source buffer, appending
      ;; the resulting HTML to HTMLBUF with `princ'.  This method is
      ;; fast because: 1) it doesn't require examining the text
      ;; properties char by char (htmlize-next-change is used to move
      ;; between runs with the same face), and 2) it doesn't require
      ;; buffer switches, which are slow in Emacs.
      (goto-char (point-min))
      (while (not (eobp))
	;; Using get-char-property instead of get-text-property
	;; insures that all the extents are examined, not only the
	;; ones that belong to text properties.  Likewise for
	;; `htmlize-next-change'.
	(setq face (get-char-property (point) 'face)
	      next-change (or (htmlize-next-change (point) 'face)
			      (point-max)))
	(and (consp face)
	     ;; Choose the first face.  Here we might want to merge
	     ;; the faces.  Under XEmacs, we might also want to take
	     ;; into account all the `face' properties of all the
	     ;; extents overlapping next-change.  *sigh*
	     (setq face (car face)))
	(and (eq face 'default)
	     (setq face nil))
	;; FSF Emacs allows `face' property to contain arbitrary
	;; stuff.
	(or (htmlize-symbol-face-p face)
	    (setq face nil))
	(when face
	  (setq face-object (gethash face htmlize-face-hash))
	  (princ (htmlize-method face-prejunk face-object) htmlbuf))
	;; Extract buffer text, sans the invisible parts.  Then
	;; untabify it and quote HTML metacharacters.
	(setq text (htmlize-buffer-substring (point) next-change))
	(when (string-match "\t" text)
	  (setq text (htmlize-untabify text (current-column))))
	(setq text (htmlize-protect-string text))
	;; Insert the text into the output buffer and terminate it,
	;; as per method used.
	(princ text htmlbuf)
	(when face
	  (princ (htmlize-method face-postjunk face-object) htmlbuf))
	(goto-char next-change))

      ;; Insert the epilog.
      (with-current-buffer htmlbuf
	(insert "</pre>\n  </body>\n</html>\n")
	(when htmlize-generate-hyperlinks
	  (htmlize-make-hyperlinks))
	(goto-char (point-min))
	(when htmlize-html-major-mode
	  ;; What sucks about this is that the minor modes, most notably
	  ;; font-lock-mode, won't be initialized.  Oh well.
	  (funcall htmlize-html-major-mode))
	(run-hooks 'htmlize-after-hook)
	(buffer-enable-undo))

      ;; We won't be needing the face data; release it.
      (clrhash htmlize-face-hash)
      htmlbuf)))

;;;###autoload
(defun htmlize-buffer (&optional buffer)
  "Convert buffer to HTML, preserving the font-lock colorization.
The generated HTML is available in a new buffer, which is returned.
When invoked interactively, the new buffer is selected in the
current window."
  (interactive)
  (let ((htmlbuf (with-current-buffer (or buffer (current-buffer))
		   (htmlize-buffer-1))))
    (when (interactive-p)
      (switch-to-buffer htmlbuf))
    htmlbuf))

;;;###autoload
(defun htmlize-region (beg end)
  "Convert the region to HTML, preserving the font-lock colorization.
The generated HTML is available in a new buffer, which is returned.
When invoked interactively, the new buffer is selected in the
current window."
  (interactive "r")
  ;; We don't want the region highlighting to get in the way.
  (when (fboundp 'zmacs-deactivate-region)
    (zmacs-deactivate-region))
  (let ((htmlbuf (save-restriction
		   (narrow-to-region beg end)
		   (htmlize-buffer-1))))
    (when (interactive-p)
      (switch-to-buffer htmlbuf))
    htmlbuf))

(defun htmlize-make-file-name (file)
  "Make an HTML file name from FILE.
The HTML file name is the regular file name, with its extension
changed to `.html'.  The exception are the file names which don't
have an extension, or those which are already `.html' -- in these
cases, \".html\" is simply appended.

Some examples:

 (htmlize-make-file-name \"foo.c\")     ==> \"foo.html\"
 (htmlize-make-file-name \"foo.b.c\")   ==> \"foo.b.html\"
 (htmlize-make-file-name \"foo\")       ==> \"foo.html\"
 (htmlize-make-file-name \"foo.html\")  ==> \"foo.html.html\"
 (htmlize-make-file-name \".emacs\")    ==> \".emacs.html\""
  (let ((extension (htmlize-file-name-extension file))
	(sans-extension (file-name-sans-extension file)))
    (if (or (equal extension "html")
	    (equal extension "htm")
	    (equal sans-extension ""))
	(concat file ".html")
      (concat sans-extension ".html"))))

(defun htmlize-make-absolute-file-name (file dir)
  "Create an absolute HTML file name with the desired directory.
That means, run FILE through `htmlize-make-file-name', and
expand it to either DIR or, if DIR is nil, to its own
directory name."
  (expand-file-name (htmlize-make-file-name (file-name-nondirectory file))
		    (or dir (file-name-directory file))))

;;;###autoload
(defun htmlize-file (file &optional target-directory)
  "HTML-ize FILE, and save the result to an `.html' file.
The file name of the HTML file is determined with `html-make-file-name'.
If TARGET-DIRECTORY is non-nil, the resulting HTML file will be saved
to that directory, instead of to FILE's directory."
  (interactive (list (read-file-name
		      "HTML-ize file: "
		      nil nil nil (and (buffer-file-name)
				       (file-name-nondirectory
					(buffer-file-name))))))
  (let* ((was-visited (get-file-buffer file))
	 ;; Set these to nil to prevent double fontification; we'll
	 ;; fontify manually below.
	 (font-lock-auto-fontify nil)
	 (global-font-lock-mode nil))
    ;; Find FILE, fontify it, HTML-ize it, and write it to FILE.html.
    (with-current-buffer (find-file-noselect file t)
      (font-lock-fontify-buffer)
      (with-current-buffer (htmlize-buffer-1)
	(run-hooks 'htmlize-file-hook)
	(write-region (point-min) (point-max)
		      (htmlize-make-absolute-file-name file target-directory))
	(kill-buffer (current-buffer)))
      ;; If FILE was not previously visited, its buffer is temporary
      ;; and can be killed.
      (unless was-visited
	(kill-buffer (current-buffer))))))

;;;###autoload
(defun htmlize-many-files (files &optional target-directory)
  "HTML-ize files specified by FILES, and save them to `.html' files.
If TARGET-DIRECTORY is specified, the HTML files will be saved to that
directory.  Normally, each HTML file is saved to the directory of the
corresponding source file."
  (interactive
   (list
    (let (list file)
      ;; Use empty string as DEFAULT because setting DEFAULT to nil
      ;; defaults to the directory name, which is not what we want.
      (while (not (equal (setq file (read-file-name "HTML-ize file (RET to finish): "
						    (and list (file-name-directory
							       (car list)))
						    "" t))
			 ""))
	(push file list))
      (nreverse list))))
  (dolist (file files)
    (htmlize-file file target-directory)))

;;;###autoload
(defun htmlize-many-files-dired (arg &optional target-directory)
  "HTMLize dired-marked files."
  (interactive "P")
  (htmlize-many-files (dired-get-marked-files nil arg) target-directory))

(provide 'htmlize)

;;; htmlize.el ends here
