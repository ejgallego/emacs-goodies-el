;;; emacs-goodies-custom.el --- Automatically harvested defgroups
;;
;;  Peter S Galbraith <psg@debian.org>
;;  License of copied code applies to this combined work (GPL V2)
;;
;;; Code:

(defgroup apache-mode nil
  "Major mode for editing Apache configuration files."
  :group 'programming
  :link '(custom-manual "(emacs-goodies-el)apache-mode")
  :load 'apache-mode
;;:require 'apache-mode
  :group 'emacs-goodies-el)

(defgroup ascii nil
  "ASCII code display"
  :link '(emacs-library-link :tag "Source Lisp File" "ascii.el")
  :prefix "ascii-"
  :group 'data
  :link '(custom-manual "(emacs-goodies-el)ascii")
  :load 'ascii
  :group 'emacs-goodies-el)

;; bar-cursor
(defgroup bar-cursor nil
  "switch block cursor to a bar."
  :link '(custom-manual "(emacs-goodies-el)bar-cursor")
  :group 'convenience
  :load 'bar-cursor
;;:require 'bar-cursor
  :group 'emacs-goodies-el)

(defgroup bm nil
  "Visible, buffer local bookmarks."
  :link '(emacs-library-link :tag "Source Lisp File" "bm.el")
  :group 'faces
  :group 'editing
  :prefix "bm-"
  :link '(custom-manual "(emacs-goodies-el)bm")
  :load 'bm
  :group 'emacs-goodies-el)

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

;; color-theme
(defgroup color-theme nil
  "Color Themes for Emacs.
A color theme consists of frame parameter settings, variable settings,
and face definitions."
  :version "20.6"
  :group 'faces
  :link '(custom-manual "(emacs-goodies-el)color-theme")
  :load 'color-theme
  :group 'emacs-goodies-el)

(defvar color-themes
  '((color-theme-aalto-dark "Aalto Dark" "Jari Aalto <jari.aalto@poboxes.com>")
    (color-theme-aalto-light "Aalto Light" "Jari Aalto <jari.aalto@poboxes.com>")
    (color-theme-aliceblue "Alice Blue" "Girish Bharadwaj <girishb@gbvsoft.com>")
    (color-theme-andreas "Andreas" "Andreas Busch <Andreas.Busch@politics.ox.ac.uk>")
    (color-theme-arjen "Arjen" "Arjen Wiersma <arjen@wiersma.org>")
    (color-theme-beige-diff "Beige Diff" "Alex Schroeder <alex@gnu.org>" t)
    (color-theme-bharadwaj "Bharadwaj" "Girish Bharadwaj <girishb@gbvsoft.com>")
    (color-theme-bharadwaj-slate "Bharadwaj Slate" "Girish Bharadwaj <girishb@gbvsoft.com>")
    (color-theme-billw "Billw" "Bill White <billw@wolfram.com>")
    (color-theme-black-on-gray "BlackOnGray" "Sudhir Bhojwani <sbhojwani@altoweb.com>")
    (color-theme-blippblopp "Blipp Blopp" "Thomas Sicheritz-Ponten<thomas@biopython.org>")
    (color-theme-simple-1 "Black" "Jonadab <jonadab@bright.net>")
    (color-theme-blue-erc "Blue ERC" "Alex Schroeder <alex@gnu.org>" t)
    (color-theme-blue-gnus "Blue Gnus" "Alex Schroeder <alex@gnu.org>" t)
    (color-theme-blue-mood "Blue Mood" "Nelson Loyola <nloyola@yahoo.com>")
    (color-theme-blue-sea "Blue Sea" "Alex Schroeder <alex@gnu.org>")
    (color-theme-calm-forest "Calm Forest" "Artur Hefczyc <kobit@plusnet.pl>")
    (color-theme-charcoal-black "Charcoal Black" "Lars Chr. Hausmann <jazz@zqz.dk>")
    (color-theme-goldenrod "Cheap Goldenrod" "Alex Schroeder <alex@gnu.org>")
    (color-theme-clarity "Clarity and Beauty" "Richard Wellum <rwellum@cisco.com>")
    (color-theme-classic "Classic" "Frederic Giroud <postcard@worldonline.fr>")
    (color-theme-comidia "Comidia" "Marcelo Dias de Toledo <mtole@ig.com.br>")
    (color-theme-jsc-dark "Cooper Dark" "John S Cooper <John.Cooper@eu.citrix.com>")
    (color-theme-jsc-light "Cooper Light" "John S Cooper <John.Cooper@eu.citrix.com>")
    (color-theme-jsc-light2 "Cooper Light 2" "John S Cooper <John.Cooper@eu.citrix.com>")
    (color-theme-dark-blue "Dark Blue" "Chris McMahan <cmcmahan@one.net>")
    (color-theme-dark-blue2 "Dark Blue 2" "Chris McMahan <cmcmahan@one.net>")
    (color-theme-dark-green "Dark Green" "eddy_woody@hotmail.com")
    (color-theme-dark-laptop "Dark Laptop" "Laurent Michel <ldm@cs.brown.edu>")
    (color-theme-deep-blue "Deep Blue" "Tomas Cerha <cerha@brailcom.org>")
    (color-theme-digital-ofs1 "Digital OFS1" "Gareth Owen <gowen@gwowen.freeserve.co.uk>")
    (color-theme-euphoria "Euphoria" "oGLOWo@oGLOWo.cjb.net")
    (color-theme-feng-shui "Feng Shui" "Walter Higgins <walterh@rocketmail.com>")
    (color-theme-fischmeister "Fischmeister"
			      "Sebastian Fischmeister <sfischme@nexus.lzk.tuwien.ac.at>")
    (color-theme-gnome "Gnome" "Jonadab <jonadab@bright.net>")
    (color-theme-gnome2 "Gnome 2" "Alex Schroeder <alex@gnu.org>")
    (color-theme-gray1 "Gray1" "Paul Pulli <P.Pulli@motorola.com>")
    (color-theme-gray30 "Gray30" "Girish Bharadwaj <girishb@gbvsoft.com>")
    (color-theme-kingsajz "Green Kingsajz" "Olgierd `Kingsajz' Ziolko <kingsajz@rpg.pl>")
    (color-theme-greiner "Greiner" "Kevin Greiner <kgreiner@mapquest.com>")
    (color-theme-gtk-ide "GTK IDE" "Gordon Messmer <gordon@dragonsdawn.net>")
    (color-theme-high-contrast "High Contrast" "Alex Schroeder <alex@gnu.org>")
    (color-theme-hober "Hober" "Edward O'Connor <ted@oconnor.cx>")
    (color-theme-infodoc "Infodoc" "Frederic Giroud <postcard@worldonline.fr>")
    (color-theme-jb-simple "JB Simple" "jeff@dvns.com")
    (color-theme-jedit-grey "Jedit Grey" "Gordon Messmer <gordon@dragonsdawn.net>")
    (color-theme-jonadabian "Jonadab" "Jonadab <jonadab@bright.net>")
    (color-theme-jonadabian-slate "Jonadabian Slate" "Jonadab <jonadab@bright.net>")
    (color-theme-katester "Katester" "Higgins_Walter@emc.com")
    (color-theme-late-night "Late Night" "Alex Schroeder <alex@gnu.org>")
    (color-theme-lawrence "Lawrence" "lawrence mitchell <wence@gmx.li>")
    (color-theme-lethe "Lethe" "Ivica Loncar <ivica.loncar@srk.fer.hr>")
    (color-theme-ld-dark "Linh Dang Dark" "Linh Dang <linhd@nortelnetworks.com>")
    (color-theme-marine "Marine" "Girish Bharadwaj <girishb@gbvsoft.com>")
    (color-theme-matrix "Matrix" "Walter Higgins <walterh@rocketmail.com>")
    (color-theme-marquardt "Marquardt" "Colin Marquardt <colin@marquardt-home.de>")
    (color-theme-midnight "Midnight" "Gordon Messmer <gordon@dragonsdawn.net>")
    (color-theme-mistyday "Misty Day" "Hari Kumar <Hari.Kumar@mtm.kuleuven.ac.be>")
    (color-theme-montz "Montz" "Brady Montz <bradym@becomm.com>")
    (color-theme-oswald "Oswald" "Tom Oswald <toswald@sharplabs.com>")
    (color-theme-parus "Parus" "Jon K Hellan <hellan@acm.org>")
    (color-theme-pierson "Pierson" "Dan L. Pierson <dan@sol.control.com>")
    (color-theme-ramangalahy "Ramangalahy" "Solofo Ramangalahy <solofo@irisa.fr>")
    (color-theme-raspopovic "Raspopovic" "Pedja Raspopovic <pedja@lsil.com>")
    (color-theme-renegade "Renegade" "Dave Benjamin <ramen@ramenfest.com>")
    (color-theme-resolve "Resolve" "Damien Elmes <resolve@repose.cx>")
    (color-theme-retro-green "Retro Green" "Alex Schroeder <alex@gnu.org>")
    (color-theme-retro-orange "Retro Orange" "Alex Schroeder <alex@gnu.org>")
    (color-theme-robin-hood "Robin Hood" "Alex Schroeder <alex@gnu.org>")
    (color-theme-rotor "Rotor" "Jinwei Shen <shenjw@wam.umd.edu>")
    (color-theme-ryerson "Ryerson" "Luis Fernandes <elf@ee.ryerson.ca>")
    (color-theme-salmon-diff "Salmon Diff" "Alex Schroeder <alex@gnu.org>" t)
    (color-theme-salmon-font-lock "Salmon Font-Lock" "Alex Schroeder <alex@gnu.org>" t)
    (color-theme-scintilla "Scintilla" "Gordon Messmer <gordon@dragonsdawn.net>")
    (color-theme-shaman "Shaman" "shaman@interdon.net")
    (color-theme-sitaramv-nt "Sitaram NT"
			     "Sitaram Venkatraman <sitaramv@loc251.tandem.com>")
    (color-theme-sitaramv-solaris "Sitaram Solaris"
				  "Sitaram Venkatraman <sitaramv@loc251.tandem.com>")
    (color-theme-snow "Snow" "Nicolas Rist <Nicolas.Rist@alcatel.de>")
    (color-theme-snowish "Snowish" "Girish Bharadwaj <girishb@gbvsoft.com>")
    (color-theme-standard-ediff "Standard Ediff" "Emacs Team, added by Alex Schroeder <alex@gnu.org>" t)
    (color-theme-standard "Standard Emacs 20" "Emacs Team, added by Alex Schroeder <alex@gnu.org>")
    (color-theme-emacs-21 "Standard Emacs 21" "Emacs Team, added by Alex Schroeder <alex@gnu.org>")
    (color-theme-emacs-nw "Standard Emacs 21 No Window" "Emacs Team, added by D. Goel <deego@gnufans.org>")
    (color-theme-xemacs "Standard XEmacs" "XEmacs Team, added by Alex Schroeder <alex@gnu.org>")
    (color-theme-subtle-blue "Subtle Blue" "Chris McMahan <cmcmahan@one.net>")
    (color-theme-subtle-hacker "Subtle Hacker" "Colin Walters <levanti@verbum.org>")
    (color-theme-taming-mr-arneson "Taming Mr Arneson" "Erik Arneson <erik@aarg.net>")
    (color-theme-taylor "Taylor" "Art Taylor <reeses@hemisphere.org>")
    (color-theme-tty-dark "TTY Dark" "O Polite <m2@plusseven.com>")
    (color-theme-vim-colors "Vim Colors" "Michael Soulier <msoulier@biryani.nssg.mitel.com>")
    (color-theme-whateveryouwant "Whateveryouwant" "Fabien Penso <penso@linuxfr.org>, color by Scott Jaderholm <scott@jaderholm.com>")
    (color-theme-wheat "Wheat" "Alex Schroeder <alex@gnu.org>")
    (color-theme-pok-wob "White On Black" "S. Pokrovsky <pok@nbsp.nsk.su>")
    (color-theme-pok-wog "White On Grey" "S. Pokrovsky <pok@nbsp.nsk.su>")
    (color-theme-word-perfect "WordPerfect" "Thomas Gehrlein <Thomas.Gehrlein@t-online.de>")
    (color-theme-xp "XP" "Girish Bharadwaj <girishb@gbvsoft.com>"))
  "List of color themes.

Each THEME is itself a three element list (FUNC NAME MAINTAINER &optional LIBRARY).

FUNC is a color theme function which does the setup.  The function
FUNC may call `color-theme-install'.  The color theme function may be
interactive.

NAME is the name of the theme and MAINTAINER is the name and/or email of
the maintainer of the theme.

If LIBRARY is non-nil, the color theme will be considered a library and
may not be shown in the default menu.

If you defined your own color theme and want to add it to this list,
use something like this:

  (add-to-list 'color-themes '(color-theme-gnome2 \"Gnome2\" \"Alex\"))")

;; Added by Peter S Galbraith <psg@debian.org>, 2005-10-25
;;
;; A color-theme can can selected and enabled for future sessions by
;; customizing this instead of calling `color-theme-select'
(defcustom color-theme-selection nil
  "Color theme selection.
Select and save to enable your choice in future sessions.
There is very limited undo capability to the previous state only."
  :type (progn
          (setq color-themes (delq (assq 'color-theme-snapshot color-themes)
                                   color-themes)
                color-themes (delq (assq 'bury-buffer color-themes)
                                   color-themes))
          (append
           '(radio)
           (cons '(const :tag "Undo" nil)
                 (mapcar (function (lambda (arg) `(const ,arg)))
                         (mapcar '(lambda (x) (elt x 1)) color-themes)))))
  :set (lambda (symbol value)
         (set-default symbol value)
         (unless color-theme-initialized (color-theme-initialize))
         (cond
          (value             
           (fset 'color-theme-snapshot (color-theme-make-snapshot))
           (eval
            (delq nil
                  (mapcar
                   '(lambda (x) (if (string-equal (elt x 1) value)
                                    (car x)))
                   color-themes))))
          ((fboundp 'color-theme-snapshot)
           (color-theme-snapshot))))
  :group 'color-theme
  :require 'color-theme)

;; csv-mode
(defgroup CSV nil
  "Major mode for editing files of comma-separated value type."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)csv-mode")
  :load 'csv-mode
  :group 'emacs-goodies-el)

;; ctypes
(defgroup ctypes nil
  "Enhanced Font lock support for custom defined types."
  :group 'programming
  :link '(custom-manual "(emacs-goodies-el)ctypes")
  :load 'ctypes
  :group 'emacs-goodies-el)

;; cwebm
(defgroup CWEBm nil
  "Major mode for editing CWEB and WEB programs"
  :prefix "cwebm-"
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)cwebm")
  :load 'cwebm
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
  :group 'external
  :link '(custom-manual "(emacs-goodies-el)dict")
  :load 'dict
;;:require 'dict
  :group 'emacs-goodies-el)

;; diminish
(defgroup diminish nil
  "Diminished modes are minor modes with no modeline display."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)diminish")
  :load 'diminish
;;:require 'diminish
  :group 'emacs-goodies-el)

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

;; folding
(defgroup folding nil
  "Managing buffers with Folds."
  :group 'tools
  :link '(custom-manual "(emacs-goodies-el)folding")
  :load 'folding
;;:require 'folding
  :group 'emacs-goodies-el)

;; framepop
(defgroup framepop nil
  "Display temporary buffers in a dedicated frame."
  :group 'frames
  :link '(custom-manual "(emacs-goodies-el)framepop")
  :load 'framepop
;;:require 'framepop
  :group 'emacs-goodies-el)

;; highlight-beyond-fill-column
(defgroup highlight-beyond-fill-column nil
  "Fontify beyond the fill-column."
  :group 'fill
  :link '(custom-manual "(emacs-goodies-el)highlight-beyond-fill-column")
  :load 'highlight-beyond-fill-column
;;:require 'highlight-beyond-fill-column
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

;; initsplit
(defgroup initsplit nil
  "Code to split customizations into different files."
  :group 'initialization
;;:link '(custom-manual "(emacs-goodies-el)initsplit")
  :load 'initsplit
;;:require 'initsplit
  :group 'emacs-goodies-el)

(defgroup joc-toggle-buffer nil
  "toggle-buffer package customization"
  :group 'tools
  :link '(custom-manual "(emacs-goodies-el)joc-toggle-buffer")
  :load 'joc-toggle-buffer
  :group 'emacs-goodies-el)

(defgroup joc-toggle-case nil
  "joc-toggle-case package customization"
  :group 'tools
  :link '(custom-manual "(emacs-goodies-el)joc-toggle-case")
  :load 'joc-toggle-case
  :group 'emacs-goodies-el)

;; keywiz
(defgroup keywiz nil
  "Emacs key sequence quiz."
  :version "21.2"
  :group 'games
  :group 'keyboard
  :link '(emacs-commentary-link "keywiz.el")
  :link '(custom-manual "(emacs-goodies-el)keywiz")
  :load 'keywiz
;;:require 'keywiz
  :group 'emacs-goodies-el)

;; lcomp
(defgroup lcomp nil
  "list-completion hacks."
  :group 'completion
  :link '(custom-manual "(emacs-goodies-el)lcomp")
  :load 'lcomp
  :group 'emacs-goodies-el)

;; maplev
(defgroup maplev nil
  "Major mode for editing Maple source in Emacs"
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)maplev")
  :load 'maplev
  :group 'emacs-goodies-el)

;; matlab
(defgroup matlab nil
  "Matlab mode."
  :prefix "matlab-"
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)matlab")
  :load 'matlab
  :group 'emacs-goodies-el)

;; markdown
(defgroup markdown nil
  "Markdown mode."
  :prefix "markdown-"
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)markdown-mode")
  :load 'markdown-mode
  :group 'emacs-goodies-el)

;; minibuffer-complete-cycle
(defgroup minibuffer-complete-cycle nil
  "Cycle through the *Completions* buffer."
  :group 'completion
  :link '(custom-manual "(emacs-goodies-el)minibuffer-complete-cycle")
  :load 'minibuffer-complete-cycle
;;:require 'minibuffer-complete-cycle
  :group 'emacs-goodies-el)

(defgroup miniedit nil
  "Miniedit"
  :group 'applications
  :link '(custom-manual "(emacs-goodies-el)miniedit")
  :load 'miniedit
;;:require 'miniedit
  :group 'emacs-goodies-el)

(defcustom miniedit-install nil
  "Whether to setup miniedit for use."
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (when value
           (if (string-match "XEmacs" emacs-version)
               (miniedit-install-for-xemacs)
             (miniedit-install))))
  :require 'miniedit
  :group 'miniedit)

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

;; pack-windows
(defgroup pack-windows nil
  "Resize all windows to display as much info as possible."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)pack-windows")
  :load 'pack-windows
  :group 'emacs-goodies-el)

;; perldoc
(defgroup perldoc nil
  "Show help for Perl functions, builtins, and modules."
  :group  'help
  :link '(custom-manual "(emacs-goodies-el)perldoc")
  :load 'perldoc
;;:require 'perldoc
  :group 'emacs-goodies-el)

;; projects
(defgroup projects nil
  "Project-based buffer name management."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)projects")
  :load 'projects
;;:require 'projects
  :group 'emacs-goodies-el)

;; protbuf
(defgroup protect-buffer nil
  "Protect buffers from accidental killing."
  :group 'killing
  :link '(custom-manual "(emacs-goodies-el)protbuf")
  :load 'protbuf
;;:require 'protbuf
  :group 'emacs-goodies-el)

;; quack
(defgroup quack nil
  "Enhanced support for editing and running Scheme code."
  :group  'scheme
  :prefix "quack-"
  :link   '(url-link "http://www.neilvandyke.org/quack/")
  :load 'quack
  :link '(custom-manual "(emacs-goodies-el)quack")
  :group 'emacs-goodies-el)

(defcustom quack-install nil
  "Whether to setup quack for use."
  :type 'boolean
  :set (lambda (symbol value)
         (set-default symbol value)
         (when value
           (quack-install)))
  :require 'quack
  :group 'quack)

;; rfcview
(defgroup rfcview nil
  "View IETF RFC files with formatting."
  :group  'hypermedia
  :prefix "rfcview-"
  :link '(custom-manual "(emacs-goodies-el)rfcview")
  :load 'rfcview
  :group 'emacs-goodies-el)

;; session
(defgroup session nil
  "Use variables, registers and buffer places across sessions."
  :group 'data
  :link '(emacs-commentary-link "session.el")
  :link '(url-link "http://emacs-session.sourceforge.net/")
  :prefix "session-"
  :link '(custom-manual "(emacs-goodies-el)session")
  :load 'session
;;:require 'session
  :group 'emacs-goodies-el)

;; setnu
(defgroup setnu nil
  "vi-style line number mode for Emacs."
  :link '(custom-manual "(emacs-goodies-el)setnu")
  :load 'setnu
  :group 'emacs-goodies-el)

;; shell-command
(defgroup shell-command nil
  "Enable Tab completions for `shell-command' and related commands."
  :group 'shell
  :link '(custom-manual "(emacs-goodies-el)shell-command")
  :load 'shell-command
  :group 'emacs-goodies-el)

;; show-wspace
(defgroup Show-Whitespace nil
  "Highlight whitespace of various kinds."
  :prefix "show-ws-"
  :group 'convenience :group 'matching
  :link `(url-link :tag "Send Bug Report"
          ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
show-wspace.el bug: \
&body=Describe bug here, starting with `emacs -q'.  \
Don't forget to mention your Emacs and library versions."))
  :link '(url-link :tag "Other Libraries by Drew"
          "http://www.emacswiki.org/cgi-bin/wiki/DrewsElispLibraries")
  :link '(url-link :tag "Download"
          "http://www.emacswiki.org/cgi-bin/wiki/show-wspace.el")
  :link '(url-link :tag "Description"
          "http://www.emacswiki.org/cgi-bin/wiki/ShowWhiteSpace#ShowWspace")
  :link '(emacs-commentary-link :tag "Commentary" "show-wspace")
  :load 'show-wspace
  :group 'emacs-goodies-el
  )

;; slang-mode
(defgroup slang nil
  "Major mode for editing slang code."
  :prefix "slang-"
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)slang-mode")
  :load 'slang-mode
  :group 'emacs-goodies-el)

(defgroup silly-mail nil
  "Generate bozotic mail headers."
  :group 'mail
  :group 'mh
  :group 'sendmail
  :link '(custom-manual "(emacs-goodies-el)silly-mail")
  :load 'silly-mail
  :group 'emacs-goodies-el)

(defgroup tabbar nil
  "Display a tab bar in the header line."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)tabbar")
  :load 'tabbar
  :group 'emacs-goodies-el)

;; tail
(defgroup tail nil
  "Tail files or commands into Emacs buffers."
  :prefix "tail-"
  :group 'environment
  :link '(custom-manual "(emacs-goodies-el)tail")
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
  :link '(custom-manual "(emacs-goodies-el)thinks")
  :load 'thinks
;;:require 'thinks
  :group 'emacs-goodies-el)

;;tlc
(defgroup tlc nil
  "Major mode for editing tlc files."
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)tlc")
  :load 'tlc
  :group 'emacs-goodies-el)

;; todoo
(when (not (featurep 'xemacs))
  (defgroup todoo nil
    "Maintain a list of todo items."
    :group 'calendar
    :link '(custom-manual "(emacs-goodies-el)todoo")
    :load 'todoo
  ;;:require 'todoo
    :group 'emacs-goodies-el))

;; toggle-option
(defgroup toggle-option nil
  "Convenience library for toggling commonly toggled variables/functions."
  :group 'convenience
  :link '(custom-manual "(emacs-goodies-el)toggle-option")
  :load 'toggle-option
;;:require 'toggle-option
  :group 'emacs-goodies-el)

;; xrdb-mode
(defgroup xrdb nil
  "Support for editing X resource database files"
  :group 'languages
  :link '(custom-manual "(emacs-goodies-el)xrdb-mode")
  :load 'xrdb-mode
;;:require 'xrdb-mode
  :group 'emacs-goodies-el)

(provide 'emacs-goodies-custom)
