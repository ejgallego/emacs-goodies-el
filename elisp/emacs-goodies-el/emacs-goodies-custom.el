;;; emacs-goodies-custom.el --- Automatically harvested defgroups
;;
;;  Peter S Galbraith <psg@debian.org>
;;  License of copied code applies to this combined work (GPL V2)
;;
;;; Code:

;; boxquote
(defgroup boxquote nil
  "Mark regions of text with a half-box."
  :group  'editing
  :prefix "boxquote-"
  :link '(custom-manual "(emacs-goodies-el)boxquote")
  :load 'boxquote
;;:require 'boxquote
  :group 'emacs-goodies-el)

;; browse-kill-ring
(defgroup browse-kill-ring nil
  "A package for browsing and inserting the items in `kill-ring'."
  :link '(url-link "http://web.verbum.org/~walters")
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)browse-kill-ring")
  :load 'browse-kill-ring
;;:require 'browse-kill-ring
  :group 'emacs-goodies-el)

;; df
(defgroup df nil
  "Display space left on partitions in the mode-line."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)df")
  :load 'df
;;:require 'df
  :group 'emacs-goodies-el)

;; dict
(defgroup Dict nil
  "Browse DICT dictionaries."
  :prefix "dict-"
  :link '(custom-manual "(emacs-goodies-el)dict")
  :load 'dict
;;:require 'dict
  :group 'external
  :group 'emacs-goodies-extra-el)

;; egocentric
(defgroup egocentric nil
  "Highlight your name in arbitrary buffers."
  :group 'files
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)egocentric")
  :load 'egocentric
;;:require 'egocentric
  :group 'emacs-goodies-el)

;; ff-paths
(defgroup ff-paths nil
  "Find file using paths."
  :group 'ffap
  :group 'matching
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)ff-paths")
  :load 'ff-paths
;;:require 'ff-paths
  :group 'emacs-goodies-el)

;; filladapt
(defgroup filladapt nil
  "Enhanced filling"
  :group 'fill
  :link '(custom-manual "(emacs-goodies-el)filladapt")
  :load 'filladapt
;;:require 'filladapt
  :group 'emacs-goodies-el)

;; floatbg
(defgroup floatbg nil
  "Slowly modify background color by moving through an HSV color model."
  :tag "Floating Background"
  :group 'frames
  :prefix "floatbg-"
  :link '(custom-manual "(emacs-goodies-el)floatbg")
  :load 'floatbg
;;:require 'floatbg
  :group 'emacs-goodies-el)


;; highlight-completion
(defgroup highlight-completion nil
  "Highlight completion mode: display completion as highlighted text."
  :tag "Highlight completion"
  :prefix "hc"
  :link '(url-link :tag "Home Page" "http://www.math.washington.edu/~palmieri/Emacs/hlc.html")
  :group 'abbrev
  :link '(custom-manual "(emacs-goodies-el)highlight-completion")
  :load 'highlight-completion
;;:require 'highlight-completion
  :group 'emacs-goodies-el)

;; highlight-current-line
(defgroup highlight-current-line nil
  "Highlight line where the cursor is."
  :load 'highlight-current-line
  :group 'faces
  :link '(custom-manual "(emacs-goodies-el)highlight-current-line")
  :load 'highlight-current-line
;;:require 'highlight-current-line
  :group 'emacs-goodies-el)

;; htmlize
(defgroup htmlize nil
  "HTMLize font-locked buffers."
  :group 'hypermedia
  :link '(custom-manual "(emacs-goodies-el)htmlize")
  :load 'htmlize
;;:require 'htmlize
  :group 'emacs-goodies-el)

;; ibuffer
(defgroup ibuffer nil
  "An advanced replacement for `buffer-menu'.

Ibuffer allows you to operate on buffers in a manner much like Dired.
Operations include sorting, marking by regular expression, and
selectable views (limits)."
  :link '(url-link "http://web.verbum.org/~walters")
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)ibuffer")
  :load 'ibuffer
;;:require 'ibuffer
  :group 'emacs-goodies-el)

;; initsplit
(defgroup initsplit nil
  "Code to split customizations into different files."
  :group 'initialization
;;:link '(custom-manual "(emacs-goodies-el)initsplit")
  :load 'initsplit
;;:require 'initsplit
  :group 'emacs-goodies-el)

;; keywiz
(defgroup keywiz nil
  "Emacs key sequence quiz."
  :version "21.2"
  :group 'games
  :group 'keyboard
  :link '(custom-manual "(emacs-goodies-el)keywiz")
  :load 'keywiz
;;:require 'keywiz
  :group 'emacs-goodies-el)

;; mutt-alias
(defgroup mutt-alias nil
  "Lookup mutt mail aliases."
  :group  'mail
  :prefix "mutt-alias-"
  :link '(custom-manual "(emacs-goodies-el)mutt-alias")
  :load 'mutt-alias
;;:require 'mutt-alias
  :group 'emacs-goodies-el)

;; muttrc-mode
(defgroup muttrc nil
  "Muttrc editing commands for Emacs."
  :group 'files
  :prefix "muttrc-"
  :link '(custom-manual "(emacs-goodies-el)muttrc-mode")
  :load 'muttrc-mode
;;:require 'muttrc-mode
  :group 'emacs-goodies-el)

;; newsticker
(defgroup newsticker nil
  "Newsticker settings. Some of these changes do not have an immediate
effect.  Therefore it is recommended to `newsticker-stop' and then
`newsticker-start' again after you have changed any of these settings."
  :link '(custom-manual "(emacs-goodies-el)newsticker")
  :load 'newsticker
;;:require 'newsticker
  :group 'emacs-goodies-extra-el)

;; table
(defgroup table nil
  "Text based table manipulation utilities.
See `table-insert' for examples about how to use."
  :tag "Table"
  :prefix "table-"
  :group 'editing
  :group 'wp
  :group 'paragraphs
  :group 'fill
;;:link '(custom-manual "(emacs-goodies-el)table")
  :load 'table
;;:require 'table
  :group 'emacs-goodies-el)

;; tail
(defgroup tail nil
  "Tail files or commands into Emacs buffers."
  :prefix "tail-"
  :group 'environment
;;:link '(custom-manual "(emacs-goodies-el)tail")
  :load 'tail
;;:require 'tail
  :group 'emacs-goodies-el)

;; tc
(defgroup tc nil "Insert cited text in a nice manner"
;;:link '(custom-manual "(emacs-goodies-el)tc")
  :load 'tc
;;:require 'tc
  :group 'emacs-goodies-el)

;; thinks
(defgroup thinks nil
  "Insert text in a think bubble."
  :group  'editing
  :prefix "thinks-"
;;:link '(custom-manual "(emacs-goodies-el)thinks")
  :load 'thinks
;;:require 'thinks
  :group 'emacs-goodies-el)

;; todoo
(defgroup todoo nil
  "Maintain a list of todo items."
  :group 'calendar
;;:link '(custom-manual "(emacs-goodies-el)todoo")
  :load 'todoo
;;:require 'todoo
  :group 'emacs-goodies-el)

;; toggle-buffer
(defgroup joc-toggle-buffer nil
  "toggle-buffer package customization"
  :group 'tools
;;:link '(custom-manual "(emacs-goodies-el)toggle-buffer")
  :load 'toggle-buffer
;;:require 'toggle-buffer
  :group 'emacs-goodies-el)

;; toggle-case
(defgroup joc-toggle-case nil
  "joc-toggle-case package customization"
  :group 'tools
;;:link '(custom-manual "(emacs-goodies-el)toggle-case")
  :load 'toggle-case
;;:require 'toggle-case
  :group 'emacs-goodies-el)

;; toggle-option
(defgroup toggle-option nil
  "Convenience library for toggling commonly toggled variables/functions."
  :group 'convenience
;;:link '(custom-manual "(emacs-goodies-el)toggle-option")
  :load 'toggle-option
;;:require 'toggle-option
  :group 'emacs-goodies-el)

;; wdired
(defgroup wdired nil
  "Mode to rename files by editing their names in dired buffers."
:group 'dired
;;:link '(custom-manual "(emacs-goodies-el)wdired")
  :load 'wdired
;;:require 'wdired
  :group 'emacs-goodies-el)

;; xrdb-mode
(defgroup xrdb nil
  "Support for editing X resource database files"
  :group 'languages
;;:link '(custom-manual "(emacs-goodies-el)xrdb-mode")
  :load 'xrdb-mode
;;:require 'xrdb-mode
  :group 'emacs-goodies-el)

(provide 'emacs-goodies-custom)
