;;; newsticker.el --- A Newsticker for Emacs.
;;
;;  Copyright (C) 2003 by Ulf Jasper
;;
;;  This file is NOT part of GNU Emacs.
;;
;;  Author:      Ulf Jasper <ulf.jasper@web.de>
;;  Filename:    newsticker.el
;;  Created:     17. June 2003
;;  Keywords:    News, RSS
;;  Time-stamp:  "26. September 2003, 22:20:38 (ulf)"
;;  CVS-Version: $Id: newsticker.el,v 1.1 2003/09/27 00:32:28 psg Exp $

(defconst newsticker-version "1.2" "Version number of newsticker.el.")

;; ======================================================================
;;
;;  This program is free software; you can redistribute it and/or
;;  modify it under the terms of the GNU General Public License as
;;  published by the Free Software Foundation; either version 2 of the
;;  License, or (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful, but
;;  WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  General Public License for more details.
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program; if not, write to the Free Software
;;  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
;;  USA
;;
;; ======================================================================
;;; Commentary:
;; 
;;  This package provides a newsticker for Emacs.  A newsticker is a
;;  thing that asynchronously retrieves a list of headlines (which are
;;  contained in RDF Site Summary (RSS) files) from a list of news
;;  sites, displays these headlines, and allows for loading the
;;  corresponding articles in a web browser.
;;
;;  This package should work with all RSS files that follow the "RDF
;;  Rich Site Summary (RSS) 1.0" specification (see
;;  http://purl.org/rss/1.0/spec).
;;  It may also work with other/older/alternative rss formats (like
;;  0.9<something> or such).
;;
;;  This package requires wget for retrieving headlines asynchronously.
;;
;;  Headlines can be displayed in the echo area, but they will show only
;;  if no other program is using the echo area (and minibuffer).
;;  Besides, headlines and their descriptions are collected in a buffer
;;  called *newsticker*.
;;
;; ======================================================================
;;; Usage:
;;
;;  Add the following line to your Emacs startup file (`~/.emacs'):
;;    (require 'newsticker)
;;  or
;;    (autoload 'newsticker-start "newsticker" "Emacs Newsticker" t)
;;
;;  Then say M-x `newsticker-start'.  This will retrieve headlines from
;;  each url in `newsticker-url-list-defaults' and `newsticker-url-list'
;;  every `newsticker-retrieval-interval' seconds.  All headlines are
;;  placed in the buffer `*newsticker*'.  Clicking mouse-button 2 or
;;  pressing RET in that buffer on a headline will call `browse-url' to
;;  load the corresponding news story in your favourite web browser.
;;
;;  Every `newsticker-display-interval' a headline is shown in the
;;  echo area (if `newsticker-display-interval' is positive).
;;
;;  In order to stop the newsticker say M-x `newsticker-stop'.  This
;;  will stop all timers.
;;
;;  The function `newsticker-show-news' will update the *newsticker*
;;  buffer, if necessary, and recreate it if you accidentally deleted
;;  it.  The modeline will indicate whether the *newsticker* buffer is
;;  up to date with the newsticker-cache.
;;
;;  Newsticker-mode extends `outline-mode' so that you can easily hide
;;  and show descriptions of feeds and news items.
;;
;;  Newsticker-mode supports imenu.  It allows for navigating with the
;;  help of a menu.  In order to use this feature you should add the
;;  following to you .emacs file:
;;
;;    (add-hook 'newsticker-mode-hook 'imenu-add-menubar-index)
;;
;;  All newsticker-options are customizable.  Say M-x customize-group RET
;;  newsticker RET in order to customize the newsticker settings.
;;
;;  Enjoy!
;;
;;  PS: This newsticker is designed do its job silently in the
;;      background without disturbing you.  However, it is probably
;;      impossible to prevent such a tool from slightly attenuating your
;;      Editor's responsiveness every once in a while.
;;
;;      Byte-compiling newsticker.el is recommended.
;;  
;;
;; ======================================================================
;;; History:
;;
;;  1.2  Peter S Galbraith <psg@debian.org>
;;       Added `newsticker-url-list-defaults', splitting the URLs into
;;         a customizable selection list, and a user add-on list.
;;       Minor checkdoc fixes.
;;
;;  1.1  Introduced optional feed-specific wget-arguments.
;;       Keep order of feeds as given in `newsticker-url-list' in
;;         *newsticker* buffer.
;;       Ignore unsupported coding systems.
;;
;;  1.0  Introduced feed-specific retrieval-timers.
;;       Removed dependency on 'cl (cddddr).
;;       Thanks to Kevin Rodgers and T.V.  Raman for their help.
;;       Use utf-8 for reading and writing cache data.
;;       Reported to work with Emacs 21.3.50.
;;
;;  0.99 Minor tweaks.
;;       Tested with Emacs 21.3.2
;;
;;  0.98 Check exit status of wget processes.  Keep cache data if
;;         something went wrong.  Throw error when old wget-processes are
;;         hanging around.
;;       Introduced newsticker-specific faces.
;;       Added `newsticker-show-descriptions-of-new-items'.
;;       Added `newsticker-hide-old-items-in-newsticker-buffer'.
;;       Added `newsticker-(hide|show)-old-items'.
;;
;;  0.97 Minor tweaks.
;;
;;  0.96 Added caching.
;;       newsticker-mode inherits outline-mode.
;;       newsticker-mode supports imenu.
;;       Easy buffer-navigation with newsticker-mode's keymap.
;;       Some bugs fixed.
;;       Thanks to Moritz Epple for documentation tips.
;;
;;  0.95 Added newsticker-mode -- Thanks to T.V.  Raman.
;;       Catch xml-parser errors -- Thanks to T.V.  Raman.
;;       Remove stupid newlines in titles (headlines) -- Thanks to Jeff
;;       Rancier.
;;
;;  0.94 Added clickerability and description for channel headings.
;;       Made it work for (at least some) rss 0.9<something> feeds.
;;
;;  0.93 Added some more sites.
;;       Do not flood the *Messages* buffer.
;;       First attempt at handling coding systems.
;;
;;  0.92 Added `newsticker-wget-name'.
;;       Try to display message only if minibuffer and echo area are not
;;         in use already.
;;       Dirty workaround for newer versions of xml.el: Remove whitespace
;;         in rdf.
;;       Tested with Emacs 21.3.2 and CVS-snapshot of 2003-06-21.
;;
;;  0.91 First bugfix: *newsticker* is read-only.
;;
;;  0.9  First release.
;;       Tested with Emacs 21.3.2 and wget 1.8.2.
;;
;; ======================================================================
;;; To Do:
;;
;;  * Documentation.
;;  * Make it faster!
;;  * Keep news items in original order.
;;  * Scramble news items for the ticker?
;;  * There are news feeds which send HTML-ized titles and descriptions...?!
;;
;; ======================================================================
;;; Code:

(require 'derived)
(require 'outline)
(require 'xml)

;; ======================================================================
;;; Customizables
;; ======================================================================
(defgroup newsticker nil
  "Newsticker settings. Some of these changes do not have an immediate
effect.  Therefore it is recommended to `newsticker-stop' and then
`newsticker-start' again after you have changed any of these settings.")

(defconst newsticker--raw-url-list-defaults
  '(("CNET News.com"
     "http://export.cnet.com/export/feeds/news/rss/1,11176,,00.xml")
    ("Debian Security Advisories"
    "http://www.debian.org/security/dsa.en.rdf")
    ("Debian Security Advisories - Long format"
    "http://www.debian.org/security/dsa-long.en.rdf")
    ("Emacs Wiki"
    "http://www.emacswiki.org/cgi-bin/wiki.pl?action=rss"
    nil
    3600)
    ("Freshmeat.net"
    "http://freshmeat.net/backend/fm.rdf")
    ("Kuro5hin.org"
    "http://www.kuro5hin.org/backend.rdf")
    ("LWN (Linux Weekly News)"
    "http://lwn.net/headlines/rss")
    ("NewsForge"
    "http://newsforge.com/index.rss")
    ("NY Times: Technology"
    "http://partners.userland.com/nytRss/technology.xml")
    ("NY Times"
    "http://partners.userland.com/nytRss/nytHomepage.xml")
    ("Quote of the day"
    "http://www.quotationspage.com/data/qotd.rss"
    "07:00"
    86400)
    ("The Register"
    "http://www.theregister.co.uk/tonys/slashdot.rdf")
    ("slashdot"
    "http://slashdot.org/index.rss"
    nil
    3600)			 ;/. will ban you if under 3600 seconds!
    ("Wired News"
    "http://www.wired.com/news_drop/netcenter/netcenter.rdf")
    ("Heise News (german)"
    "http://www.heise.de/newsticker/heise.rdf")
    ("Tagesschau (german)"
    "http://www.tagesschau.de/newsticker.rdf"
    nil
    1800)
    ("Telepolis (german)"
    "http://www.heise.de/tp/news.rdf"))
  "Default url list in raw form, used to feed it into defcustom.")

(defun newsticker--splicer (item)
  "Convert ITEM for splicing into `newsticker-url-list-defaults'."
  (let ((result (list 'list :tag (nth 0 item) (list 'const (nth 0 item))))
	(element (cdr item)))
    (while element
      (setq result (append result (list (list 'const (car element)))))
      (setq element (cdr element)))
    result))

(defcustom newsticker-url-list-defaults
 '(("Emacs Wiki"
    "http://www.emacswiki.org/cgi-bin/wiki.pl?action=rss" 
    nil 
    3600))
  "A customizable list of news feeds to select from.
These were mostly extracted from the Radio Community Server at
http://subhonker6.userland.com/rcsPublic/rssHotlist.

You may add other entries in `newsticker-url-list'."
  :type `(set ,@(mapcar `newsticker--splicer
			newsticker--raw-url-list-defaults))
  :group 'newsticker)


(defcustom newsticker-url-list nil
  "The news feeds which you like to watch.

This alist will be used in addition to selection made customizing
`newsticker-url-list-defaults'.

This is an alist.  Each element consists of two items: a LABEL and a URL,
optionally followed by a START-TIME and an INTERVAL specifier.

The LABEL gives the name of the news feed.  It can be an arbitrary string.

The URL gives the location of the newsfeed.  It must point to a valid
RSS file.  The RSS file is retrieved by calling wget, or whatever you
specify as `newsticker-wget-name'.

The START-TIME can be either a string, or nil.  If it is a string it
specifies a fixed time at which this feed shall be retrieved for the
first time.  (Examples: \"11:00pm\", \"23:00\").  If it is nil (or
unspecified), this feed will be retrieved immediately after calling
`newsticker-start'.

The INTERVAL specifies the time between retrievals for this feed.  If it
is nil (or unspecified) the default interval value as set in
`newsticker-retrieval-interval' is used.

\(newsticker.el calls `run-at-time'. The newsticker-parameters START-TIME
and INTERVAL correspond to the `run-at-time'-parameters TIME and REPEAT.)

If you changed the start-time or the retrieval interval you must
re-start the newsticker.  All other changes will take effect at the next
regular news-retrieval."
  :type '(repeat (list :tag "News feed"
                       (string :tag "Label   ");; FIXME? looks ugly with
                       (string :tag "URI     ");; proportional fonts!
                       (choice :tag "Start   "
                               (string  :tag "Fixed Time")
                               (const   :tag "Default   " nil))
                       (choice :tag "Interval"
                               (integer :tag "Interval")
                               (const   :tag "Default " nil))
                       (choice :tag "Wget Arguments"
                               (repeat :tag "Special arguments" string)
                               (const  :tag "Default arguments" nil))))
  :group 'newsticker)


(defcustom newsticker-scroll-smoothly
  t
  "Decides wether to flash or scroll news items.
If t the news headlines are scrolled (more-or-less) smoothly in the echo
area.  If nil one headline after another is displayed in the echo area.
The variable `newsticker-display-interval' determines how fast this
display moves/changes and whether headlines are shown in the echo area
at all.  If you change `newsticker-scroll-smoothly' you should also change
`newsticker-display-interval'."
  :type 'boolean
  :group 'newsticker)

(defcustom newsticker-display-interval
  0.3
  "Time interval for displaying news items (seconds).
If equal or less than 0 no messages are shown in the echo area.  For
smooth display (see `newsticker-scroll-smoothly') a value of 0.3 seems
reasonable.  For non-smooth display a value of 10 is a good starting
point.  You have to re-start the newsticker in order to make a new value
effective."
  :type 'number
  :group 'newsticker)

(defcustom newsticker-retrieval-interval
  3600
  "Time interval for retrieving new news items (seconds).
Slashdot will ban you if you make it less than 1800 seconds (30 minutes)!
You have to re-start the newsticker in order to make a new value
effective."
  :type 'integer
  :group 'newsticker)

(defcustom newsticker-wget-name
  "wget"
  "Name of the program which is called to retrieve news from the web.
The canonical choice is wget but you may take any other program which is
able to return the contents of a news feed file on stdout."
  :type 'string
  :group 'newsticker)

(defcustom newsticker-wget-arguments
  '("-q" "-O" "-")
  "Arguments which are passed to wget.
There is probably no reason to change the default settings, unless you
are living behind a firewall."
  :type '(repeat (string :tag "Argument"))
  :group 'newsticker)

(defcustom newsticker-automatically-mark-items-as-old
  t
  "Decides whether to automatically mark items as old.
If t a new item is considered as new only after its first retrieval.  As
soon as it is retrieved a second time, it becomes old.  If not t all
items stay new until you mark them as old.  This is done in the
*newsticker* buffer."
  :type 'boolean
  :group 'newsticker)

(defcustom newsticker-hide-old-items-in-echo-area
  t
  "Decides whether to show only the newest news items in the ticker.
If t the echo area will show only new items, i.e. only items which have
been added between the last two retrievals."
  :type 'boolean
  :group 'newsticker)

(defcustom newsticker-hide-old-items-in-newsticker-buffer
  nil
  "Decides whether to automatically hide old items in the *newsticker* buffer.
If set to t old items will be completely folded and only new items
will show up in the *newsticker* buffer.  Otherwise old as well as new
items will be visible."
  :type 'boolean
  :group 'newsticker)

(defcustom newsticker-show-descriptions-of-new-items
  t
  "Whether to automatically show descriptions of new items in *newsticker*.
If set to t old items will be folded and new items will be
unfolded.  Otherwise old as well as new items will be folded."
  :type 'boolean
  :group 'newsticker)


(defcustom newsticker-cache-filename
  "~/.newsticker-cache"
  "Name of the newsticker cache file."
  :type 'string
  :group 'newsticker)

(defcustom newsticker-debug
  nil
  "Toggles output of newsticker debug messages.
If set to t newsticker.el will print lots of debugging messages."
  :type 'boolean
  :group 'newsticker)

(defface newsticker-feed-face
  '((((class color) (background dark))
     (:family "helvetica" :height 160 :bold t :italic nil
              :foreground "misty rose"))
    (((class color) (background light))
     (:family "helvetica" :height 160 :bold t :italic nil
              :foreground "black")))
  "Face for news feeds."
  :group 'newsticker)

(defface newsticker-new-item-face
  '((((class color) (background dark))
     (:inherit default :bold t :foreground "orange"))
    (((class color) (background light))
     (:inherit default :bold t :foreground "blue")))
  "Face for old news items."
  :group 'newsticker)

(defface newsticker-old-item-face
  '((((class color) (background dark))
     (:inherit default :bold t))
    (((class color) (background light))
     (:inherit default :bold t)))
  "Face for old news items."
  :group 'newsticker)

(defface newsticker-default-face
  '((((class color) (background dark))
     (:inherit default))
    (((class color) (background light))
     (:inherit default)))
  "Face for the description of news items."
  :group 'newsticker)

;; ======================================================================
;;; Internal variables
;; ======================================================================
(defvar newsticker--display-timer nil
  "Timer for newsticker display.")
(defvar newsticker--retrieval-timer-list nil
  "List of timers for news retrieval.
This is an alist, each element consisting of (feed-name . timer)")
(defvar newsticker--item-list nil
  "List of newsticker items.")
(defvar newsticker--item-position 0
  "Actual position in list of newsticker items.")
(defvar newsticker--prev-message "There was no previous message yet!"
  "Last message that the newsticker displayed.")
(defvar newsticker--scrollable-text ""
  "The text which is scrolled smoothly in the echo area.")
(defvar newsticker--buffer-uptodate-p nil
  "Tells whether the newsticker buffer is up to date.")
(defvar newsticker--latest-update-time (current-time)
  "The time at which the wlates news arrived.")
(defvar newsticker--cache nil "Cached newsticker data.
This is a list of the form
 ((label1
   (item-title item-description item-link item-time item-marker) ...)
  (label2
   (item-title item-description item-link item-time item-marker) ...)
  ...)
where label is a symbol.  title, description, and link are strings.  Time
is a time value as returned by `current-time'.  Marker is a symbol: 'new,
'old, and 'obsolete denote ordinary news items, whereas 'feed denotes an
item which is not a headline but describes the feed itself.")

(defvar newsticker--font-lock-keywords
  '(("^\\*   \\(.*\\) ([^)]+)$" 1 'newsticker-feed-face)
    ("^\\*\\*  \\(.*\\) ([^)]+)$" 1 'newsticker-new-item-face)
    ("^\\*\\*\\* \\(.*\\) ([^)]+)$" 1 'newsticker-old-item-face)
    ("^    \\(.*\\)$" 1 'newsticker-default-face)))


;; ======================================================================
;;; Newsticker mode
;; ======================================================================
(define-derived-mode newsticker-mode outline-mode
  "NewsTicker"
  "Viewing RSS news feeds in Emacs."
  (set (make-local-variable 'imenu-sort-function) nil)
  (setq imenu-create-index-function 'newsticker--imenu-create-index)
  (setq buffer-read-only t)
  (setq newsticker--buffer-uptodate-p nil)
  (auto-fill-mode -1) ;; Turn auto-fill off!
  (set (make-local-variable 'font-lock-defaults)
       '(newsticker--font-lock-keywords t nil nil ))
  ;; we want the default outline-regexp
  (set (make-local-variable 'outline-regexp) "[*\f]+")
  (setq mode-name "Newsticker -- NEED UPDATE -- "))

;; refine its mode-map
(define-key newsticker-mode-map "\n"   'newsticker-browse-url)
(define-key newsticker-mode-map "\C-m" 'newsticker-browse-url)
(define-key newsticker-mode-map "sO"   'newsticker-show-old-items)
(define-key newsticker-mode-map "hO"   'newsticker-hide-old-items)
(define-key newsticker-mode-map "sa"   'newsticker-show-all-desc)
(define-key newsticker-mode-map "ha"   'newsticker-hide-all-desc)
(define-key newsticker-mode-map "sf"   'newsticker-show-feed-desc)
(define-key newsticker-mode-map "hf"   'newsticker-hide-feed-desc)
(define-key newsticker-mode-map "so"   'newsticker-show-old-item-desc)
(define-key newsticker-mode-map "ho"   'newsticker-hide-old-item-desc)
(define-key newsticker-mode-map "sn"   'newsticker-show-new-item-desc)
(define-key newsticker-mode-map "hn"   'newsticker-hide-new-item-desc)
(define-key newsticker-mode-map "se"   'show-entry)
(define-key newsticker-mode-map "he"   'hide-entry)

(define-key newsticker-mode-map " "  'scroll-up)
(define-key newsticker-mode-map "q"  'bury-buffer)
(define-key newsticker-mode-map "p"  'newsticker-previous-item)
(define-key newsticker-mode-map "\t" 'newsticker-next-item)
(define-key newsticker-mode-map "n"  'newsticker-next-item)
(define-key newsticker-mode-map "M"  'newsticker-mark-all-items-as-read)
(define-key newsticker-mode-map "m"  'newsticker-mark-items-at-point-as-read)
(define-key newsticker-mode-map "P"  'newsticker-previous-new-item)
(define-key newsticker-mode-map "N"  'newsticker-next-new-item)
(define-key newsticker-mode-map "G"  'newsticker-get-all-news)
(define-key newsticker-mode-map "g"  'newsticker-get-news-at-point)
(define-key newsticker-mode-map "u"  'newsticker-buffer-update)

;; map for the clickable portions
(defvar newsticker-click-map (make-sparse-keymap)
  "Keymap for clickable portions of the newsticker buffer.")
(define-key newsticker-click-map [mouse-2] 'newsticker-mouse-browse-url)

;; newsticker menu
(defvar newsticker-menu (make-sparse-keymap "Newsticker"))

(define-key newsticker-menu [newsticker-browse-url]
  '("Browse URL for item at point" . newsticker-browse-url))
(define-key newsticker-menu [newsticker-separator-1]
  '("--"))
(define-key newsticker-menu [newsticker-buffer-update]
  '("Update buffer" . newsticker-buffer-update))
(define-key newsticker-menu [newsticker-separator-2]
  '("--"))
(define-key newsticker-menu [newsticker-get-news-at-point]
  '("Get news from feed at point" . newsticker-get-news-at-point))
(define-key newsticker-menu [newsticker-get-all-news]
  '("Get news from all feeds" . newsticker-get-all-news))
(define-key newsticker-menu [newsticker-separator-3]
  '("--"))
(define-key newsticker-menu [newsticker-mark-items-at-point-as-read]
  '("Mark all items as read for feed at point" .
    newsticker-mark-items-at-point-as-read))
(define-key newsticker-menu [newsticker-mark-all-items-as-read]
  '("Mark all items as read" . newsticker-mark-all-items-as-read))
(define-key newsticker-menu [newsticker-separator-4]
  '("--"))
(define-key newsticker-menu [newsticker-show-old-items]
  '("Show old items" . newsticker-show-old-items))
(define-key newsticker-menu [newsticker-hide-old-items]
  '("Hide old items" . newsticker-hide-old-items))

;; bind menu to mouse
(define-key newsticker-mode-map [down-mouse-3] newsticker-menu)
;; Put menu in menu-bar
(define-key newsticker-mode-map [menu-bar Newsticker]
  (cons "Newsticker" newsticker-menu))

;; ======================================================================
;;; User fun
;; ======================================================================
(defun newsticker-start (&optional do-not-complain-if-running)
  "Start the newsticker.
Start the timers for display and retrieval.  If the newsticker, i.e. the
timers, are running already a warning message is printed unless
DO-NOT-COMPLAIN-IF-RUNNING is not nil."
  (interactive)
  (let ((running (> (length newsticker--retrieval-timer-list) 0)))
    ;; read old cache if it exists and newsticker is not running
    (unless running
      (let* ((coding-system 'utf-8)
             (b (find-file-noselect newsticker-cache-filename)))
        (when b
          (set-buffer b)
          (goto-char (point-min))
          (condition-case nil
              (setq newsticker--cache (read b))
            (error (setq newsticker--cache nil)))
          (kill-buffer b))))
    ;; start display timer (the actual ticker), if wanted and not
    ;; running already
    (if (and (> newsticker-display-interval 0)
             (not newsticker--display-timer))
        (setq newsticker--display-timer
              (run-at-time newsticker-display-interval
                           newsticker-display-interval
                           'newsticker--display-tick)))
    ;; start retrieval timers -- for sake of simplicity we will start
    ;; one timer for each feed
    (mapcar (lambda (item)
              (let* ((feed-name (car item))
                     (start-time (nth 2 item))
                     (interval (or (nth 3 item)
                                   newsticker-retrieval-interval))
                     (timer (assoc (car item)
                                   newsticker--retrieval-timer-list)))
                (if timer
                    (or do-not-complain-if-running
                        (message "Timer for %s is running already!" feed-name))
                  (if newsticker-debug
                      (message "Starting timer for %s: %s, %d" feed-name
                               start-time interval))
                  (setq timer (run-at-time start-time interval
                                           'newsticker-get-news feed-name))
                  (add-to-list 'newsticker--retrieval-timer-list
                               (cons feed-name timer)))))
            (append newsticker-url-list-defaults newsticker-url-list))
    (unless running
      (message "Newsticker started!"))))

(defun newsticker-stop ()
  "Stop the newsticker.
Cancel the timers for display and retrieval."
  (interactive)
  (when newsticker--display-timer
    (cancel-timer newsticker--display-timer)
    (setq newsticker--display-timer nil))
  (when (>(length newsticker--retrieval-timer-list) 0)
    (mapcar (lambda (name-and-timer)
              (cancel-timer (cdr name-and-timer)))
            newsticker--retrieval-timer-list)
    (setq newsticker--retrieval-timer-list nil)
    (message "Newsticker stopped!")))


;; the functions we need for retrieval and display
(defun newsticker-show-news ()
  "Switch to newsticker buffer.  You may want to bind this to a key."
  (interactive)
  (newsticker-start t) ;; will start only if not running
  (newsticker-buffer-update)
  (switch-to-buffer "*newsticker*")
  (if newsticker--buffer-uptodate-p
      (setq mode-name "Newsticker -- up to date -- ")
      (setq mode-name "Newsticker -- NEED UPDATE -- ")))

(defun newsticker-buffer-update ()
  "Update the newsticker buffer, if necessary."
  (interactive)
  (save-current-buffer
    (let ((b (get-buffer "*newsticker*")))
      (if b (set-buffer b)
        (set-buffer (get-buffer-create "*newsticker*"))
        (setq newsticker--buffer-uptodate-p nil)))
   (unless newsticker--buffer-uptodate-p
     (message "Preparing newsticker buffer...")
     (let ((inhibit-read-only t))
       (set-buffer-modified-p nil)
       (erase-buffer)
       (newsticker-mode)
       (newsticker--buffer-insert-all-items)
       (set-buffer-modified-p nil)
       (newsticker-hide-all-desc)
       (if newsticker-hide-old-items-in-newsticker-buffer
           (newsticker-hide-old-items))
       (if newsticker-show-descriptions-of-new-items
           (newsticker-show-new-item-desc)))
     (message ""))
   (setq newsticker--buffer-uptodate-p t)
   (setq mode-name "Newsticker -- up to date -- ")))

(defun newsticker-get-all-news ()
  "Launch retrieval of news from all configured newsticker sites.
This does NOT start the retrieval timers."
  (interactive)
  ;; launch retrieval of news
  (mapcar (lambda (item)
            (newsticker-get-news (car item)))
          (append newsticker-url-list-defaults newsticker-url-list)))

(defun newsticker-get-news-at-point ()
  "Launch retrieval of news for the feed point is in.
This does NOT start the retrieval timers."
  (interactive)
  ;; launch retrieval of news
  (let ((feed (get-text-property (point) 'feed)))
      (when feed
        (message "Getting news for %s" (symbol-name feed))
        (newsticker-get-news (symbol-name feed)))))


;; ======================================================================
;;; keymap stuff
;; ======================================================================
(defun newsticker-next-new-item ()
  "Go to next new news item."
  (interactive)
  (unless (newsticker--buffer-goto-mark 'new)
    (message "No more new items!")))

(defun newsticker-previous-new-item ()
  "Go to previous new news item."
  (interactive)
  (unless (newsticker--buffer-goto-mark 'new t)
    (message "No more new items!")))

(defun newsticker-next-item ()
  "Go to next news item or feed."
  (interactive)
  (while (and (re-search-forward "^\\*+ +" nil t)
              (newsticker--text-at-pos-is-invisible))))

(defun newsticker-previous-item ()
  "Go to previous news item or feed."
  (interactive)
  (beginning-of-line)
  (while (and (re-search-backward "^\\*+ +" nil t)
              (newsticker--text-at-pos-is-invisible)))
  (goto-char (match-end 0)))

(defun newsticker-mark-items-at-point-as-read ()
  "Mark all items as read and clear ticker contents."
  (interactive)
  (when (or newsticker--buffer-uptodate-p
            (y-or-n-p
             "Buffer is not up to date -- really mark items as read? "))
    (let ((feed (get-text-property (point) 'feed))
          (pos (point)))
      (when feed
        (message "Marking all items as read for %s" (symbol-name feed))
        (newsticker--cache-replace-mark newsticker--cache feed 'new 'old)
        (newsticker--cache-save)
        (setq newsticker--buffer-uptodate-p nil)
        (newsticker--ticker-text-setup)
        (newsticker-buffer-update)
        ;; go back to where we came frome
        (goto-char pos)
        (end-of-line)
        (newsticker--buffer-goto-mark 'feed t)))))

(defun newsticker-mark-all-items-as-read ()
  "Mark all items as read and clear ticker contents."
  (interactive)
  (when (or newsticker--buffer-uptodate-p
            (y-or-n-p
             "Buffer is not up to date -- really mark items as read? "))
    (newsticker--cache-replace-mark newsticker--cache 'any 'new 'old)
    (setq newsticker--buffer-uptodate-p nil)
    (newsticker--ticker-text-setup)
    (newsticker--cache-save)
    (newsticker-buffer-update)))

(defun newsticker-hide-old-item-desc ()
  "Hide the description of old items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'old nil))

(defun newsticker-show-old-item-desc ()
  "Show the description of old items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'old t))

(defun newsticker-hide-new-item-desc ()
  "Hide the description of new items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'new nil))

(defun newsticker-show-new-item-desc ()
  "Show the description of new items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'new t))

(defun newsticker-hide-feed-desc ()
  "Hide the description of feeds."
  (interactive)
  (newsticker--buffer-hideshow-mark 'feed nil))

(defun newsticker-show-feed-desc ()
  "Show the description of old items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'feed t))

(defun newsticker-hide-all-desc ()
  "Hide the descriptions of feeds and all items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'feed nil)
  (newsticker--buffer-hideshow-mark 'new  nil)
  (newsticker--buffer-hideshow-mark 'old  nil))

(defun newsticker-show-all-desc ()
  "Show the descriptions of feeds and all items."
  (interactive)
  (newsticker--buffer-hideshow-mark 'feed t)
  (newsticker--buffer-hideshow-mark 'new  t)
  (newsticker--buffer-hideshow-mark 'old  t))

(defun newsticker-hide-old-items ()
  "Hide old items."
  (interactive)
  (hide-sublevels 2))

(defun newsticker-show-old-items ()
  "Show old items."
  (interactive)
  (hide-sublevels 3))

;; ======================================================================
;;; helper
;; ======================================================================
(defun newsticker--text-at-pos-is-invisible ()
  "Return t if the text at point has an overlay with property 'invisible."
  (let ((invisible nil))
    (mapcar (lambda (o)
              (if (overlay-get o 'invisible)
                  (setq invisible t)))
            (overlays-in (point) (point)))
    invisible))

;; ======================================================================
;;; local stuff
;; ======================================================================
(defun newsticker-get-news (feed-name)
  "Get news from the news site FEED-NAME.
FEED-NAME must be a string which occurs as the label (i.e. the first element)
in an element of `newsticker-url-list' or `newsticker-url-list-defaults'."
  (if newsticker-debug
      (message "%s: Getting news for %s"
               (format-time-string "%A, %H:%M" (current-time))
               feed-name))
  (let* ((buffername (concat "*wget-newsticker-" feed-name "*"))
         (item (or (assoc feed-name newsticker-url-list)
                   (assoc feed-name newsticker-url-list-defaults)
                   (error
                    "Cannot get news for %s: Check newsticker-url-list")))
         (url (cadr item))
         (wget-arguments (or (car (cdr (cdr (cdr (cdr item)))))
                             newsticker-wget-arguments)))
    (save-current-buffer
      (set-buffer (get-buffer-create buffername))
      (erase-buffer)
      ;; throw an error if there is an old wget-process around
      (if (get-process feed-name)
          (error "Another wget-process is running for %s" feed-name))
      ;; start wget
      (let* ((args (append wget-arguments (list url)))
               (proc (apply 'start-process feed-name buffername
                            newsticker-wget-name args)))
        (set-process-coding-system proc 'no-conversion 'no-conversion)
        (set-process-sentinel proc 'newsticker--sentinel)))))
  
(defun newsticker-mouse-browse-url (event)
  "Call `browse-url' for the link of the item at which the EVENT occured."
  (interactive "e")
  (save-current-buffer
    (set-buffer (window-buffer (posn-window (event-end event))))
    (let ((url (get-text-property (posn-point (event-end event))
                                  'link)))
      (when url
        (browse-url url)))))

(defun newsticker-browse-url ()
  "Call `browse-url' for the link of the item at point."
  (interactive)
  (let ((url (get-text-property (point) 'link)))
    (when url
      (browse-url url))))

(defun newsticker--sentinel (process event)
  "Sentinel for extracting news titles from an RDF buffer.
Argument PROCESS is the process which has just changed its state.
Argument EVENT tells what has happened to the process."
  (let* ((p-status (process-status process))
         (exit-status (process-exit-status process))
         (time (current-time)))
    ;; catch known errors (zombie processes, rubbish-xml etc.
    ;; if an error occurs the news feed is not updated!
    (catch 'oops
      (unless (and (eq p-status 'exit)
                   (= exit-status 0))
        (message "%s: error while retrieving news from %s"
                 (format-time-string "%A, %H:%M" (current-time))
                 (process-name process))
        (throw 'oops nil))
      (let* ((coding-system nil)
             (node-list
              (save-current-buffer
                (set-buffer (process-buffer process))
                ;; a very very dirty workaround to overcome the
                ;; problems with the newest (20030621) xml.el:
                ;; remove all unnecessary whitespace
                (goto-char (point-min))
                (while (re-search-forward ">\\s-+<" nil t)
                  (replace-match "><" nil t))
                (goto-char (point-min))
                (if (re-search-forward "encoding=\"\\([^\"]+\\)\""
                                       nil t)
                    (setq coding-system (intern
                                         (downcase(match-string 1)))))
                (condition-case nil
                    ;; The xml parser might fail
                    ;; or the xml might be bugged
                    (xml-parse-region (point-min) (point-max))
                  (error (message "newsticker.el: Could not parse %s"
                                  (buffer-name))
                         (throw 'oops nil)))))
             (topnode (car node-list))
             (channelnode (car (xml-get-children topnode 'channel)))
             (name (process-name process))
             (name-symbol (intern name))
             (pos 0))
        ;; mark all items as obsolete
        (setq newsticker--cache
              (newsticker--cache-replace-mark newsticker--cache
                                              name-symbol
                                              'new 'obsolete-new))
        (setq newsticker--cache
              (newsticker--cache-replace-mark newsticker--cache
                                              name-symbol
                                              'old 'obsolete-old))
        ;; gather the news
        (if (eq (xml-node-name topnode) 'rss)
            ;; this is RSS 0.91 or something similar
            ;; all items are inside the channel node
            (setq topnode channelnode))
        
        (let ((title (or (car (xml-node-children (car (xml-get-children
                                                       channelnode 'title))))
                         "[untitled]"))
              (link (or (car (xml-node-children (car (xml-get-children
                                                      channelnode 'link))))
                        ""))
              (desc (or (car (xml-node-children (car (xml-get-children
                                                      channelnode
                                                      'description))))
                        "[No description available]"))
              (pos 0)
              (old-item nil))
          ;; handle the feed itself
          (setq newsticker--cache
                (newsticker--cache-add newsticker--cache name-symbol
                                       title desc link time
                                       'feed 'feed t))
          ;; gather all items
          (mapcar (lambda (node)
                    (when (eq (xml-node-name node) 'item)
                      (setq title (or (car (xml-node-children
                                            (car (xml-get-children
                                                  node 'title))))
                                      "[untitled]"))
                      (setq link (or (car (xml-node-children
                                           (car (xml-get-children
                                                 node 'link))))
                                     ""))
                      (setq desc (car (xml-node-children
                                       (car (xml-get-children
                                             node 'description)))))
                      ;; It happened that the title or description
                      ;; contained evil html code that confused the
                      ;; xml parser.  Therefore:
                      (unless (stringp title)
                        (setq title (prin1-to-string title)))
                      (unless (or (stringp desc) (not desc))
                        (setq title (prin1-to-string desc)))
                      ;; check coding system
                      (setq coding-system
                            (condition-case nil
                                (check-coding-system coding-system)
                              (coding-system-error
                               (message "newsticker.el: %s %s %s %s"
                                        "ignoring coding system "
                                        coding-system
                                        " for "
                                        name)
                               nil)))
                      ;; apply coding system
                      (when coding-system
                        (setq title
                              (decode-coding-string title coding-system t))
                        (if desc
                            (setq desc
                                  (decode-coding-string desc
                                                        coding-system t)))
                        (setq link
                              (decode-coding-string link coding-system t)))
                      ;; remove stupid superfluous silly newlines from title
                      (setq title (replace-regexp-in-string "\n" " " title))
                      ;; add data to cache
                      ;; do we have this item already?
                      (setq old-item
                            (newsticker--cache-contains newsticker--cache
                                                        name-symbol title))
                      ;; add this item, or mark it as old, or do nothing
                      (let ((mark1 'new)
                            (mark2 'old))
                        (if old-item
                            (let ((prev-mark (nth 4 old-item)))
                              (unless newsticker-automatically-mark-items-as-old
                                (if (eq prev-mark 'obsolete-old)
                                    (setq mark2 'old)
                                  (setq mark2 'new)))))
                        (setq newsticker--cache
                              (newsticker--cache-add
                               newsticker--cache name-symbol title desc link
                               time mark1 mark2)))))
                  (xml-get-children topnode 'item)))
        ;; remove old items from cache
        (newsticker--cache-replace-mark newsticker--cache
                                        name-symbol 'obsolete-old 'obsolete)
        (newsticker--cache-replace-mark newsticker--cache
                                        name-symbol 'obsolete-new 'obsolete)
        ;; bring cache data into proper order....
        (setq newsticker--cache
              (newsticker--cache-remove newsticker--cache name-symbol
                                        'obsolete))
        (newsticker--cache-sort))
      ;; setup scrollable text
      (newsticker--ticker-text-setup)
      (newsticker--cache-save)
      (setq newsticker--buffer-uptodate-p nil)
      (setq newsticker--latest-update-time (current-time))
      (save-current-buffer
        (when (get-buffer "*newsticker*")
        (set-buffer "*newsticker*")
        (setq mode-name "Newsticker -- NEED UPDATE -- "))))))
    
(defun newsticker--display-tick ()
  "Called from the display timer.
This function calls a display function, according to the variable
`newsticker-scroll-smoothly'."
  (if newsticker-scroll-smoothly
      (newsticker--display-scroll)
    (newsticker--display-jump)))

(defsubst newsticker--echo-area-clean-p ()
  "Check whether somebody is using the echo area / minibuffer.
Return t if echo area and minibuffer are unused."
  (not (or (active-minibuffer-window)
           (and (current-message)
                (not (string= (current-message)
                              newsticker--prev-message))))))

(defun newsticker--display-jump ()
  "Called from the display timer.
This function displays the next ticker item in the echo area, unless
there is another message displayed or the minibuffer is active."
  (let ((message-log-max nil));; prevents message text from being logged
    (when (newsticker--echo-area-clean-p)
      (setq newsticker--item-position (1+ newsticker--item-position))
      (when (>= newsticker--item-position (length newsticker--item-list))
        (setq newsticker--item-position 0))
      (setq newsticker--prev-message
            (nth newsticker--item-position newsticker--item-list))
      (message newsticker--prev-message))))

(defun newsticker--display-scroll ()
  "Called from the display timer.
This function scrolls the ticker items in the echo area, unless
there is another message displayed or the minibuffer is active."
  (when (newsticker--echo-area-clean-p)
    (let* ((width (- (frame-width) 1))
           (message-log-max nil);; prevents message text from being logged
           (i newsticker--item-position)
           subtext
           (s-text newsticker--scrollable-text)
           (l (length s-text)))
      ;; don't show anything if there is nothing to show
      (unless (< (length s-text) 1)
        (setq s-text
              (concat "+++ "
                      (format-time-string "%A, %H:%M"
                                          newsticker--latest-update-time)
                      " ++++++" s-text))
        (while (< (length s-text) width)
          (setq s-text (concat s-text s-text)))
        (setq l (length s-text))
        (cond ((< i (- l width))
               (setq subtext (substring s-text i (+ i width))))
              (t
               (setq subtext (concat
                              (substring s-text i l)
                              (substring s-text 0 (- width (- l i)))))))
        (message subtext)
        (setq newsticker--prev-message subtext)
        (setq newsticker--item-position (1+ i))
        (when (>= newsticker--item-position l)
          (setq newsticker--item-position 0))))))

;; ======================================================================
;;; imenu stuff
;; ======================================================================
(defun newsticker--imenu-create-index ()
  "Scan newsticker buffer and return an index for imenu."
  ;;(interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((index-alist nil))
      (while (re-search-forward "^\\*  \\(.*\\)" nil t)
        (let ((result (list (match-string-no-properties 1)))
              (max (save-excursion (re-search-forward "^*  " nil t))))
          (while (re-search-forward "\\*\\*+ \\(.*\\) ([^)]+)" max t)
            (add-to-list 'result (cons (match-string-no-properties 1)
                                       (match-beginning 0)) t))
          (add-to-list 'index-alist result t)))
      index-alist)))

;; ======================================================================
;;; buffer stuff
;; ======================================================================
(defun newsticker--buffer-insert-all-items ()
  "Insert all cached newsticker items into the current buffer.
Keeps order of feeds as given in `newsticker-url-list' and
`newsticker-url-list-defaults'."
  (goto-char (point-min))
  (mapcar (lambda (url-item)
            (let* ((feed-name-symbol (intern (car url-item)))
                   (feed (assoc feed-name-symbol newsticker--cache))
                   (items (cdr feed))
                   (pos (point))
                   (old-item-line-printed nil))
              (when feed
                ;; insert the feed description
                (mapcar (lambda (item)
                          (when (eq (nth 4 item) 'feed)
                            (newsticker--buffer-insert-item "*   " item t)))
                        items)
                ;;insert the new items
                (mapcar (lambda (item)
                          (if (eq (nth 4 item) 'new)
                              (newsticker--buffer-insert-item "**  " item)))
                        items)
                ;;insert the old items
                (mapcar (lambda (item)
                          (unless (or (eq (nth 4 item) 'feed)
                                      (eq (nth 4 item) 'new)
                                      (eq (nth 4 item) 'obsolete-old)
                                      (eq (nth 4 item) 'obsolete-new))
                            (newsticker--buffer-insert-item "*** " item)))
                        items)
                (add-text-properties pos (point) (list 'feed (car feed)))
                (insert "\n"))))
          (append newsticker-url-list newsticker-url-list-defaults))
  (goto-char (point-min)))

(defun newsticker--buffer-insert-item (prefix item &optional is-feed)
  "Insert a news item in the current buffer.
Insert the string PREFIX and a formatted representation of the ITEM.  The
optional parameter IS-FEED determines how the item is formatted and
whether the item-retrieval time is added as well."
  (let ((pos (point))
        (map newsticker-click-map)
        (mark (nth 4 item)))
    (insert prefix)
    (setq pos (point))
    (insert (car item))
    (set-left-margin pos (point) 3)
    (add-text-properties pos (point) '(mouse-face highlight))
    (add-text-properties pos (point) (list 'link (nth 2 item)))
    (add-text-properties pos (point) (list 'help-echo (nth 2 item)))
    (add-text-properties pos (point) (list 'keymap map))
    (add-text-properties pos (point) (list 'mark mark))
    (insert " (" (format-time-string "%A, %H:%M" (nth 3 item)) ")")
    ;;(fill-region pos (point) 'left nil t)
    ;; insert the description
    (insert "\n")
    (setq pos (point))
    (let ((desc (nth 1 item)))
      (when desc
        (insert desc)
        (set-left-margin pos (point) 4)
        (insert "\n")
        (fill-region pos (point) 'left nil t)
        (add-text-properties pos (point)
                             '(face newsticker-description-face))))))

(defun newsticker--buffer-goto-mark (mark &optional backwards)
  "Search next occurence of MARK in current buffer.
If MARK is found point is moved, if not point is left unchanged.  If
optional parameter BACKWARDS is t, search backwards."
  (interactive)
  (let ((pos (save-excursion
               (catch 'found
                 (let (next-pos)
                   (while (setq next-pos
                                (if backwards
                                    (previous-single-property-change
                                     (point) 'mark)
                                  (next-single-property-change (point)
                                                               'mark)))
                     (goto-char next-pos)
                     (if (eq (get-text-property (point) 'mark) mark)
                         (throw 'found (point)))))))))
    (if pos
        (goto-char pos))))


(defun newsticker--buffer-hideshow-mark (hide-mark onoff)
  "Hide or show items with mark HIDE-MARK.
If ONOFF is nil the item is hidden, otherwise it is shown."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (newsticker--buffer-goto-mark hide-mark)
      (if onoff
          (show-entry)
        (hide-entry)))))

;; ======================================================================
;;; manipulation of ticker text
;; ======================================================================
(defun newsticker--ticker-text-setup ()
  "Builds the ticker text which is scrolled or flashed in the echo area."
  ;; reset scrollable text
  (setq newsticker--scrollable-text "")
  (setq newsticker--item-list nil)
  (setq newsticker--item-position 0)
  ;; build scrollable text from cache data
  (mapcar
   (lambda (feed)
     (let ((feed-name (symbol-name (car feed))))
       (mapcar (lambda (item)
                 (let ((title (nth 0 item))
                       (mark (nth 4 item)))
                   (unless (or (eq mark 'feed)
                               (and newsticker-hide-old-items-in-echo-area
                                    (eq mark 'old)))
                     ;; add to flash list
                     (add-to-list 'newsticker--item-list
                                  (concat feed-name ": " title) t)
                     ;; and to the scrollable text
                     (setq newsticker--scrollable-text
                           (concat newsticker--scrollable-text
                                   " " feed-name ": " title " +++")))))
               (cdr feed))))
   newsticker--cache))

;; ======================================================================
;;; manipulation of cached data
;; ======================================================================
(defun newsticker--cache-replace-mark (data feed old-mark new-mark)
  "Mark all items in DATA in FEED which carry mark OLD-MARK with NEW-MARK.
If FEED is 'any it applies to all feeds.  If OLD-MARK is 'any,
all marks are replaced by new-mark."
  (mapcar (lambda (a-feed)
            (when (or (eq feed 'any)
                      (eq (car a-feed) feed))
              (let ((items (cdr a-feed)))
                (mapcar (lambda (item)
                          (if (or (eq old-mark 'any)
                                  (eq (nth 4 item) old-mark))
                              (setcar (nthcdr 4 item) new-mark)))
                        items))))
          data)
  data)

(defun newsticker--cache-contains (data feed-symbol title)
  "Check DATA whether the feed FEED-SYMBOL contains an item with TITLE.
Return the item"
  (condition-case nil
      (catch 'found
        (mapcar (lambda (this-feed-symbol)
                  (when (eq (car this-feed-symbol) feed-symbol)
                    (mapcar (lambda (anitem)
                              (when (string= (car anitem) title)
                                (throw 'found anitem)))
                            (cdr this-feed-symbol))))
                data)
        nil)
    (error nil)))

(defun newsticker--cache-add (data feed title desc link time
                                         &optional mark old-mark update-time)
  "Add another item to cache data.
Add to DATA in the FEED an item with TITLE, DESC, LINK, and TIME and an
optional MARK.  If this item is contained already, its mark is set to
OLD-MARK and its time is set to UPDATE-TIME.
Returns the mark which the item got."
  (let ((item (newsticker--cache-contains data feed title)))
    (if item
        (progn    ;; does exist already -- change mark, update time
          (setcar (nthcdr 4 item) old-mark)
          (if update-time
              (setcar (nthcdr 3 item) time)))
      ;; did not exist
      (catch 'found
        (mapcar (lambda (this-feed)
                  (when (eq (car this-feed) feed)
                    ;;(setcdr afeed (cons (list title desc link time mark)
                      ;;                  (cdr afeed)))
                    ;;(message title)
                    (setcdr this-feed (nconc (cdr this-feed)
                                             (list (list title desc link
                                                         time mark))))
                    (throw 'found this-feed)))
                data)
        ;; the feed is not contained
        (add-to-list 'data (list feed (list title desc link time mark))
                     t))))
  data)

(defun newsticker--cache-remove (data feed-symbol mark)
  "Remove all entries from DATA in the feed FEED-SYMBOL with MARK.
FEED-SYMBOL may be 'any.  Entries from old feeds, which are no longer in
`newsticker-url-list' or `newsticker-url-list-defaults', are removed as
well."
  ;; does not really remove but creates a new list and copies only the
  ;; requested items
  (let ((newdata nil))
    (mapcar
     (lambda (this-feed)
       (let ((name (car this-feed)))
         ;; copy only active feeds
         (if (or (assoc (symbol-name name) newsticker-url-list)
                 (assoc (symbol-name name) newsticker-url-list-defaults))
             (mapcar (lambda (anitem)
                       (unless (and (or (eq feed-symbol 'any)
                                               (eq feed-symbol name))
                                    (eq mark (nth 4 anitem)))
                         (setq newdata
                               (newsticker--cache-add
                                newdata
                                name
                                (nth 0 anitem);title
                                (nth 1 anitem);desc
                                (nth 2 anitem);link
                                (nth 3 anitem);time
                                (nth 4 anitem);mark
                                (nth 4 anitem);mark
                                ))))
                     (cdr this-feed)))))
     data)
    newdata))

(defun newsticker--cache-item-compare (item1 item2)
  "Compare two news items ITEM1 and ITEM2 by comparing their time values."
  (let* ((time1 (nth 3 item1))
         (time2 (nth 3 item2))
         (result (cond ((< (nth 0 time1) (nth 0 time2))
                        nil)
                       ((> (nth 0 time1) (nth 0 time2))
                        t)
                       ((< (nth 1 time1) (nth 1 time2))
                        nil)
                       ((> (nth 1 time1) (nth 1 time2))
                        t)
                       ((< (nth 2 time1) (nth 2 time2))
                        nil)
                       ((> (nth 2 time1) (nth 2 time2))
                        t)
                       (t
                        nil))))
    result))

(defun newsticker--cache-sort ()
  "Sort the newsticker cache data."
  (mapcar (lambda (feed-list)
            (setcdr feed-list (sort (cdr feed-list)
                                    'newsticker--cache-item-compare)))
          newsticker--cache))
  
(defun newsticker--cache-save ()
  "Save cache data."
  ;; FIXME: prevent from printing "Wrote ..." message?!
  (let ((coding-system-for-write 'utf-8))
    (write-region (prin1-to-string newsticker--cache) nil
                  newsticker-cache-filename))
  ;; clear echo area from write-region's output
  (message ""))

(provide 'newsticker)
;;; newsticker.el ends here
