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

(require 'emacs-goodies-loaddefs)

(defgroup emacs-goodies-el '((df custom-group))
  "Debian emacs-goodies-el package customization."
  :group 'convenience)

(defcustom emacs-goodies-el-defaults nil
  "Whether default settings are chosen conservatively or aggressively.
non-nil means aggressive.
Setting to aggresisve will enable feature that superceed Emacs defaults."
  :type '(radio (const :tag "conservative" nil)
                (const :tag "aggressive" t))
  :link '(custom-manual "(emacs-goodies-el)Top")
  :group 'emacs-goodies-el)

(defcustom emacs-goodies-el-use-ff-paths emacs-goodies-el-defaults
  "Whether to setup ff-paths for use.
find-file-using-paths searches certain paths to find files."
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (when value
           (require 'ff-paths)))
  :group 'emacs-goodies-el)

(defcustom emacs-goodies-el-use-ffap emacs-goodies-el-defaults
  "Whether to setup ffap for use, and add ff-paths as a helper to it.
ffap.el --- find file (or url) at point.
non-nil also setups the keybindings:
 C-x C-f       find-file-at-point (abbreviated as ffap)
 C-x 4 f       ffap-other-window
 C-x 5 f       ffap-other-frame
 S-mouse-3     ffap-at-mouse
 C-S-mouse-3   ffap-menu"
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (when value
           (require 'ffap)
           (ffap-bindings)
           (require 'ff-paths)
           (ff-paths-in-ffap-install)))
  :group 'emacs-goodies-el)

;; df.el
(defgroup df nil
  "Display space left on partitions in the mode-line."
  :load 'df
  :group 'tools)

;; autoloads for apt-utils.el
(autoload 'apt-utils-search "apt-utils"
  "Search Debian packages for regular expression.
With ARG, match names only."
  t)

; autoloads for bar-cursor.el
(autoload 'bar-cursor-change "bar-cursor"
  "Enable or disable advice based on value of variable `bar-cursor-mode'."
  t)
(defcustom bar-cursor-mode nil
  "*Non-nil means to convert the block cursor into a bar cursor.
In overwrite mode, the bar cursor changes back into a block cursor.
This is a quasi-minor mode, meaning that it can be turned on & off easily
though only globally (hence the quasi-)"
  :type 'boolean
  :group 'emacs-goodies-el
  :set (lambda (symbol value)
         (set-default symbol value)
         (bar-cursor-change)))

; autoloads for highlight-completion.el
(autoload 'highlight-completion-mode "highlight-completion"
  "Activate highlight-completion."
  t)

; autoloads for toggle-buffer.el
(autoload 'joc-toggle-buffer "toggle-buffer"
  "Switch to previous active buffer."
  t)

; autoloads for mutt-alias.el
(autoload 'mutt-alias-insert "mutt-alias"
  "Insert the expansion for ALIAS into the current buffer."
  t)
(autoload 'mutt-alias-lookup "mutt-alias"
  "Lookup and display the expansion for ALIAS."
  t)
  
; autoloads for setnu.el
(autoload 'setnu-mode "setnu"
  "Toggle setnu-mode."
  t)
(autoload 'turn-on-setnu-mode "setnu"
  "Turn on setnu-mode."
  t)

; autoloads for wdired.el
(add-hook
 'dired-load-hook
 '(lambda ()
    (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
    (define-key dired-mode-map
      [menu-bar immediate wdired-change-to-wdired-mode]
      '("Edit File Names" . wdired-change-to-wdired-mode))))

; autoloads for clipper.el
(autoload 'clipper-create "clipper"
  "Create a new 'clip' for use within Emacs."
  t)
(autoload 'clipper-delete "clipper"
  "Delete an existing 'clip'."
  t)
(autoload 'clipper-insert "clipper"
  "Insert a new 'clip' into the current buffer."
  t)
(autoload 'clipper-edit-clip "clipper"
  "Edit an existing 'clip'."
  t)

; autoloads for projects.el
(autoload 'add-project "projects"
  "Add the project named NAME with root directory DIRECTORY."
  t)
(autoload 'remove-project "projects"
  "Remove the project named NAME."
  t)
(autoload 'list-projects "projects"
  "List all projects sorted by project name."
  t)

; autoloads for toggle-case.el
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

; autoloads for tail.el
(autoload 'tail-file "tail"
  "Tails file specified with argument ``file'' inside a new buffer."
  t)
(autoload 'tail-command "tail"
  "Tails command specified with argument ``command'' inside a new buffer."
  t)

; autoloads for under.el
(autoload 'underline-region "under"
  "Underline the region."
  t)

; autoloads for highlight-current-line.el
(autoload 'highlight-current-line-on "highlight-current-line"
  "Switch highlighting of cursor-line on/off."
  t)

; autoloads for align-string.el
(autoload 'align-string "align-string"
  "Align first occurrence of REGEXP in each line of region."
  t)
(autoload 'align-all-strings "align-string"
  "Align all occurrences of REGEXP in each line of region."
  t)

; autoloads for diminish.el
(defcustom diminished-minor-modes nil
  "List of minor modes to diminish and their mode line display strings.
The display string can be the empty string if you want the name of the mode
completely removed from the mode line.  If you prefer, you can abbreviate
the name.  For 2 characters or more will be displayed as a separate word on
the mode line, just like minor modes' names.  A single character will be
scrunched up against the previous word.  Multiple single-letter diminished
modes will all be scrunched together.

The display of undiminished modes will not be affected."
  :type '(alist :key-type (symbol :tag "Minor-mode")
		:value-type (string :tag "Title"))
  :options (mapcar 'car minor-mode-alist)
  :set (lambda (symbol value)
         (if (and (boundp 'diminished-minor-modes) diminished-minor-modes)
             (mapcar 
              (lambda (x) (diminish-undo (car x) t)) diminished-minor-modes))
         (set-default symbol value)
         (mapcar (lambda (x) (diminish (car x) (cdr x) t)) value)))

; autoloads for keydef.el
(autoload 'keydef "keydef"
  "Define the key sequence SEQ, written in kbd form, to run CMD."
  t)

; autoloads for toggle-option.el
(autoload 'toggle-option "toggle-option"
  "Easily toggle frequently toggled options."
  t)

; autoloads and automode for todoo.el
(autoload 'todoo "todoo"
  "TODO Mode."
  t)
(autoload 'todoo-mode "todoo"
  "TODO Mode"
  t)
(add-to-list 'auto-mode-alist '("TODO$" . todoo-mode))

; autoloads for cyclebuffer.el
(autoload 'cyclebuffer-forward "cyclebuffer"
  "Cycle buffer forward."
  t)
(autoload 'cyclebuffer-backward "cyclebuffer"
  "Cycle buffer backward."
  t)

; autoloads for keywiz.el
(autoload 'keywiz "keywiz"
  "Start a key sequence quiz."
  t)

; autoloads and automode for apt-sources.el
(add-to-list 'auto-mode-alist '("sources.list$" . apt-sources-mode))

; autoloads and automode for muttrc-mode.el
(add-to-list 'auto-mode-alist '("muttrc" . muttrc-mode))

; autoloads and automode for xrdb-mode.el
(add-to-list 'auto-mode-alist '("\\.Xdefaults$" . xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.Xenvironment$". xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.Xresources$". xrdb-mode))
(add-to-list 'auto-mode-alist '("\\.ad$". xrdb-mode))
(add-to-list 'auto-mode-alist '("/app-defaults/". xrdb-mode))
(add-to-list 'auto-mode-alist '("/Xresources/". xrdb-mode))

; autoloads for map-lines.el
(autoload 'map-lines "map-lines"
  "Map COMMAND over lines matching REGEX."
  t)

(provide 'emacs-goodies-el)

;;; emacs-goodies-el.el ends here
