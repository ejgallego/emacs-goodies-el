;;; emacs-goodies-el.el --- startup file for the emacs-goodies-el package

;;; Commentary:
;; 
;; This file is loaded from /etc/emacs/site-start.d/50emacs-goodies-el.el

;;; History:
;;
;; 2003-06-14 - Peter Galbraith
;;  - Delete autoloads that can be generated automatically.
;; 2003-05-14 - Peter Galbraith
;;  - Created from 50emacs-goodies-el.el contents.

;;; Code:

(defgroup emacs-goodies-el nil
  "Debian emacs-goodies-el package customization."
  :group 'convenience)

(require 'emacs-goodies-loaddefs)
(require 'emacs-goodies-custom)

(defcustom emacs-goodies-el-defaults nil
  "Whether default settings are chosen conservatively or aggressively.
non-nil means aggressive.
Setting to aggresisve will enable feature that superceed Emacs defaults."
  :type '(radio (const :tag "conservative" nil)
                (const :tag "aggressive" t))
  :link '(custom-manual "(emacs-goodies-el)Top")
  :group 'emacs-goodies-el)

;; align-string.el
(autoload 'align-string "align-string"
  "Align first occurrence of REGEXP in each line of region."
  t)
(autoload 'align-all-strings "align-string"
  "Align all occurrences of REGEXP in each line of region."
  t)

;; apt-sources
(add-to-list 'auto-mode-alist '("sources.list$" . apt-sources-mode))

;;  auto-fill-inhibit.el
(defgroup auto-fill-inhibit '((auto-fill-inhibit-list custom-variable))
  "Finer grained control over auto-fill-mode (de)activation."
  :load 'auto-fill-inhibit
  :link '(custom-manual "(emacs-goodies-el)auto-fill-inhibit")
  :group 'emacs-goodies-el)

;; clipper.el
(autoload 'clipper-create "clipper" "Create a new 'clip' for use within Emacs."
  t)
(autoload 'clipper-delete "clipper" "Delete an existing 'clip'." t)
(autoload 'clipper-insert "clipper" 
  "Insert a new 'clip' into the current buffer."
  t)
(autoload 'clipper-edit-clip "clipper" "Edit an existing 'clip'." t)

;; cyclebuffer.el
(autoload 'cyclebuffer-forward "cyclebuffer"
  "Cycle buffer forward."
  t)
(autoload 'cyclebuffer-backward "cyclebuffer"
  "Cycle buffer backward."
  t)

;; ff-paths.el
(defcustom ff-paths-install emacs-goodies-el-defaults
  "Whether to setup ff-paths for use.
find-file-using-paths searches certain paths to find files."
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (when value
           (ff-paths-install)))
  :load 'ff-paths
;;  :require 'ff-paths
  :group 'emacs-goodies-el
  :group 'ff-paths)

(defcustom ff-paths-use-ffap emacs-goodies-el-defaults
  "Whether to setup ffap for use.

Usually packages don't advertise or try to setup other packages, but
ff-paths works well in combination with ffap (Find FILENAME, guessing a
default from text around point) and so I recommend it here.

find-file-using-paths searches certain paths to find files."
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (when value
           (require 'ffap)
           (ff-paths-in-ffap-install)))
;;  :require 'ff-paths
  :load 'ff-paths
  :group 'emacs-goodies-el
  :group 'ff-paths)

;; filladapt
(autoload 'turn-on-filladapt-mode "filladapt"
  "Unconditionally turn on Filladapt mode in the current buffer."
  t)

(defcustom filladapt-turn-on-mode-hooks nil
  "*List of hooks for which to turn-on filladapt.
Filladapt works well with any language that uses comments that
start with some character sequence and terminate at end of line.
So it is good for Postscript, Lisp, Perl, C++ and shell modes.
It's not good for C mode because C's comments are multiline."
  :type '(set (const text-mode-hook)
              (const awk-mode-hook)
              (const lisp-mode-hook)
              (const emacs-lisp-mode-hook)
              (const perl-mode-hook))
  :set (lambda (symbol value)
         ;; Remove old values since user may have deleted entries
         (if (and (boundp 'filladapt-mode-hooks) filladapt-mode-hooks)
             (mapcar (lambda (hook) (remove-hook hook 'turn-on-filladapt-mode))
                     filladapt-mode-hooks))
         (set-default symbol value)
         ;; Set entries selected by the user.
         (mapcar (lambda (hook) (add-hook hook 'turn-on-filladapt-mode))
                 value))
  :load 'filladapt
  :group 'emacs-goodies-el
  :group 'filladapt)

;; highlight-completion.el
(autoload 'highlight-completion-mode "highlight-completion"
  "Activate highlight-completion."
  t)

;; highlight-current-line.el - compatibility
(autoload 'highlight-current-line-on "highlight-current-line"
  "Switch highlighting of cursor-line on/off globally."
  t)

;; home-end.el
(defcustom home-end-enable emacs-goodies-el-defaults
  "*Define [home] and [end] keys to act differently when hit 1, 2 or 3 times."
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (cond
          (value
           (global-set-key [end]  'home-end-end)
           (global-set-key [home] 'home-end-home))
          (t
           (global-set-key [end] 'end-of-line
           (global-set-key [home] beginning-of-line))))
  :load 'home-end
  :group 'emacs-goodies-el)

;; keydef.el
(autoload 'keydef "keydef"
  "Define the key sequence SEQ, written in kbd form, to run CMD."
  t)

;; keywiz.el
(autoload 'keywiz "keywiz"
  "Start a key sequence quiz."
  t)

;; map-lines.el
(autoload 'map-lines "map-lines"
  "Map COMMAND over lines matching REGEX."
  t)

;; mutt-alias.el
(autoload 'mutt-alias-insert "mutt-alias"
  "Insert the expansion for ALIAS into the current buffer."
  t)
(autoload 'mutt-alias-lookup "mutt-alias"
  "Lookup and display the expansion for ALIAS."
  t)
  
;; muttrc-mode.el
(add-to-list 'auto-mode-alist '("muttrc" . muttrc-mode))

;; projects.el
(autoload 'add-project "projects"
  "Add the project named NAME with root directory DIRECTORY."
  t)
(autoload 'remove-project "projects"
  "Remove the project named NAME."
  t)
(autoload 'list-projects "projects"
  "List all projects sorted by project name."
  t)

;; setnu.el
(autoload 'setnu-mode "setnu"
  "Toggle setnu-mode."
  t)
(autoload 'turn-on-setnu-mode "setnu"
  "Turn on setnu-mode."
  t)

;; tail.el
(autoload 'tail-file "tail"
  "Tails file specified with argument ``file'' inside a new buffer."
  t)
(autoload 'tail-command "tail"
  "Tails command specified with argument ``command'' inside a new buffer."
  t)

;; todoo.el
(autoload 'todoo "todoo"
  "TODO Mode."
  t)
(autoload 'todoo-mode "todoo"
  "TODO Mode"
  t)
(add-to-list 'auto-mode-alist '("TODO$" . todoo-mode))

;; toggle-buffer.el
(autoload 'joc-toggle-buffer "toggle-buffer"
  "Switch to previous active buffer."
  t)

;; toggle-case.el
(autoload 'joc-toggle-case "toggle-case"
  "Toggles the case of the character under point."
  t)

(autoload 'joc-toggle-case "toggle-case-backwards"
  "Toggle case of character preceding point."
  t)

(autoload 'joc-toggle-case "toggle-case-by-word"
  "Toggles the case of the word under point."
  t)

(autoload 'joc-toggle-case "toggle-case-by-word-backwards"
  "Toggles the case of the word preceding point."
  t)

(autoload 'joc-toggle-case "toggle-case-by-region"
  "Toggles the case of all characters in the current region."
  t)

;; toggle-option.el
(autoload 'toggle-option "toggle-option"
  "Easily toggle frequently toggled options."
  t)

;; under.el
(autoload 'underline-region "under"
  "Underline the region."
  t)

;; xrdb-mode.el
(add-to-list 'auto-mode-alist '("\\.Xdefaults$" . xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.Xenvironment$". xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.Xresources$". xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.ad$". xrdb-mode))
(add-to-list 'auto-mode-alist '("/app-defaults/". xrdb-mode))
(add-to-list 'auto-mode-alist '("/Xresources/". xrdb-mode))

;; wdired.el
(add-hook
 'dired-load-hook
 '(lambda ()
    (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
    (define-key dired-mode-map
      [menu-bar immediate wdired-change-to-wdired-mode]
      '("Edit File Names" . wdired-change-to-wdired-mode))))

(provide 'emacs-goodies-el)

;;; emacs-goodies-el.el ends here
