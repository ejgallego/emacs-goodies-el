;;; debian-bug.el --- report a bug to Debian's bug tracking system

;; Copyright (C) 1998, 1999 Free Software Foundation, Inc.
;; Copyright (C) 2001, 2002, 2003 Peter S Galbraith <psg@debian.org>

;; Author (Up to version 1.7):           Francesco Potort� <pot@gnu.org>
;; Maintainer from version 1.8 onwards:  Peter S Galbraith <psg@debian.org>
;; Keywords: debian, bug, reporter

;; debian-bug.el is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; debian-bug.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;; ----------------------------------------------------------------------------
;;; Commentary:
;;
;; Useful commands provided by this mode:
;;
;; debian-bug         - submit a bug report concerning a Debian package
;; debian-bug-web-bug - view a bug report on a web browser (via browse-url)
;; debian-bug-wnpp    - submit a Work Needed on Prospective Package bug report
;; debian-bug-request-for-package
;;                    - shortcut for a WNPP bug type.
;; debian-bug-ITP     - shortcut for a WNPP bug type
;;
;; debian-bug depends on either the bug package or the reportbug (>1.21)
;; package for best results.
;;
;; ----------------------------------------------------------------------------
;;; Change log:
;;
;; V1.5 23sep99 Francesco Potort� <pot@gnu.org>
;;  - V1.1 -> 1.5 versions had no changelogs; starting one now.
;; V1.5 and V1.7 by Francesco Potort� <pot@gnu.org> were unreleased.
;; V1.8 04aug01 Peter S Galbraith <psg@debian.org>
;;  - WNPP interface code added.  I'm unsure whether the functions useful
;;    only to Debian developpers should be in here.  Perhaps split into a
;;    second .el file bundled in dpkg-dev-el?
;; V1.9 10aug01 Peter S Galbraith <psg@debian.org>
;;  - gratuitous changes (sorry Francesco) while going through the code base:
;;    document defvars, s/debian-bug-program/debian-bug-helper-program/,
;;    s/debian-bug-init-program/debian-bug-helper-program-init/,
;;  - updated list of pseudo-packages
;; V1.10 11aug01 Peter S Galbraith <psg@debian.org>
;;   Apply most of patch (made against v1.4!) from
;;   Kim-Minh Kaplan <kmkaplan@vocatex.fr>, Dated 03 Oct 1999.
;;   (mostly, it inserts the package version numbers in the completion obarray
;;    eliminating the need to parse the status file later).
;; V1.11 11aug01 Peter S Galbraith <psg@debian.org>
;;  - Don't use external bug command when package name does not exist locally
;;    (fixes an old bug).
;;  - Add font-lock support (e.g. release-critical severities in red)
;; V1.12 13aug01 Peter S Galbraith <psg@debian.org>
;;  - generalize debian-bug-wnpp-email to debian-bug-use-From-address
;;  - debian-bug-ITP and debian-bug-request-for-package shortcuts.
;;  - Add menubar via minor-mode
;;    -> set address to send to (submit, quiet, maintonly)
;;    -> set/unset custom From header line.
;;    -> set/unset X-Debbugs-CC header line.
;;    -> change bug severity
;;    -> add/change Tags
;;    -> browse-url web interface to BTS
;;    -> various help texts
;;    -> customize
;; V1.13 14aug01 Peter S Galbraith <psg@debian.org>
;;  - Confirm when package is not in status file.
;;  - Fix for reportbug >= 1.22
;; V1.14 15aug01 Peter S Galbraith <psg@debian.org>
;;  - merge in wget BTS code from debian-changelog.el
;;  - clarify help texts about maintonly and ftp.debian.org
;;  - defaliases for -ITP and -RFP (closes: #108808)
;;  - Add menu option for X-Debbugs-CC to myself.
;;  - small format fixes.
;; V1.15 15aug01 Peter S Galbraith <psg@debian.org>
;;  - Change all address related menu comands to toggling radio switches.
;; V1.16 21sep01 Peter S Galbraith <psg@debian.org>
;;  - Temporary fix for XEmacs' lack of font-lock-add-keywords.
;;  - Add template as done by reportbug for ITP and RFP wnpp bugs.
;;    (closes: #111615)
;; V1.17 20oct01 Peter S Galbraith <psg@debian.org>
;;  - load poe for match-string-no-properties if using XEmacs.
;;  - Use only one arg with format-time-string for XEmacs compatibility.
;;  - After generating the bug list menu in XEmacs, remove both menus and add
;;    them again.  Otherwise the menu is not refreshed. (Closes: #111332)
;; V1.18 11nov01 Peter S Galbraith <psg@debian.org>
;;  - customize debian-bug-helper-program so bug isn't necessarily used first.
;; V1.19 11nov01 Peter S Galbraith <psg@debian.org>
;;  - debian-bug: change from "Package; title" from reporter-submit-bug-report
;;    into "Package: title" (closes: #117976).
;;  - debian-bug-From-address-init: recognize all env vars used by reportbug
;;    and bug to set the From line.
;;  - debian-bug-use-From-address: default to t if any of the above env vars
;;    are set.  I could also try to detect is debian-bug-From-address is
;;    customized, but that's for another day. (closes #117855).
;;  - debian-bug-prefill-report: don't add superfluous line at the beginning
;;    of the bug report body (closes #117842).
;; V1.20 11dec01 Peter S Galbraith <psg@debian.org>
;;  - debian-bug: display message that we are fetching system info (which can
;;    take a while). (Closes: #122033)
;;  - debian-bug: fix function doc string (Closes: #121932 if Roland fixes
;;    the corresponding autoload).
;; V1.21 11dec01 Peter S Galbraith <psg@debian.org>
;;  - debian-bug, debian-bug-wnpp: Use simpler 'reporter-compose-outgoing'
;;    instead of 'reporter-submit-bug-report'
;;  - debian-bug, debian-bug-wnpp: reset buffer to "*mail*" if mail-user-agent
;;    is gnus-user-agent (Closes: #121532).
;; V1.22 11dec01 Peter S Galbraith <psg@debian.org>
;;  - menu: Implement most of Bill Wohler's excellent suggestions to improve
;;    the main menu (Closes: #123476)
;; V1.23 12dec01 Peter S Galbraith <psg@debian.org>
;;  - use new option --template with reportbug for garanteed non-interactive
;;    use of reportbug.  The package must depend on reportbug >= 1.41.1
;;    (Closes: #122032)
;; V1.24 24Jan02 Peter S Galbraith <psg@debian.org>
;;    debian-bug-web-bugs: return all bugs for the source package.
;; V1.25 07Feb02 Peter S Galbraith <psg@debian.org>
;;    debian-bug-build-bug-menu: return all bugs for the source package.
;; V1.26 08Feb02 Peter S Galbraith <psg@debian.org>
;;    debian-bug-help-tags-text and debian-bug-help-severity-text: updated
;;    debian-bug-tags-alist: Added "upstream" to list
;; V1.27 11Jul02 Peter S Galbraith <psg@debian.org>
;;    reset buffer to "*mail*" only when in buffer " *nttpd*" (Closes: #151717)
;; V1.28 30Jul02 Peter S Galbraith <psg@debian.org>
;;    added debian-bug-filename (Closes: 117036)
;; V1.29 02Augl02 Peter S Galbraith <psg@debian.org>
;;    Add a few functions from debian-changelog, since we are taking over
;;    its duplicate commands.
;;     New: debian-bug-web-this-bug
;;     New: debian-bug-web-this-bug-under-mouse
;; V1.30 15Aug02 Peter S Galbraith <psg@debian.org>
;;    Kalle Olavi Niemitalo <kon@iki.fi> suggested the use of "toggle" buttons
;;    instead of "radio" buttons, where appropriate (Closes: #156297).
;; V1.31 15Aug02 Peter S Galbraith <psg@debian.org>
;;    Remove erroneous [] brackets around WNPP tags (Closes: #156391).
;; V1.32 13Sep02 Peter S Galbraith <psg@debian.org>
;;  - Deal with reportbug 1.99.54 (or so) that adds MIME stuff to mail headers.
;;    Patch from Brian Warner <warner@lothar.com> (Closes: #160750)
;;  - debian-bug-prefill-report: Don't pass desired severity to reportbug
;;    because it is interactive when high settings are passed.  Set after
;;    reportbug template is entered instead.  (Closes: #159625)
;; V1.33 27Sep02 Peter S Galbraith <psg@debian.org>
;;    Split long bug menus, first into categories, then into number ranges.
;;    (Closes: #161155)
;; V1.34 20Nov02 Peter S Galbraith <psg@debian.org>
;;    debian-bug-build-bug-menu: removed one character from the regexp for
;;    the bug menu.  I don't know if the web format changed, but
;;    debian-bug-alist was short by the last number in its bug numbers.
;; V1.35 19Mar03 Peter S Galbraith <psg@debian.org>
;;    debian-bug-build-bug-menu:  Adapted to change in BTS web page format.
;;    Bugs were no longer found by the old regexp.
;; V1.36 19Mar03 Peter S Galbraith <psg@debian.org>
;;    debian-bug: Call proper debian-bug--set-custom-From, which will delete
;;     an existing From line before inserting a new one.  Closes: #184954.
;;    debian-bug-prefill-report: Don't flake out on search if "\n\n" not
;;     found.  This might help with bug #165290, but I should really check
;;     that reportbug doesn't fail.
;;    debian-bug: Check if empty Subject field has trailing space.  Should
;;     fix bug #173040 and part of #177259.
;; V1.37 10Apr2003 Peter S Galbraith <psg@debian.org>
;;  - Switch priority of reportbug and bug, preferring reportbug. 
;;  - send to maintonly if priority wishlist or minor.  Closes: #176429.
;; ----------------------------------------------------------------------------

;;; Todo (Peter's list):
;;
;; - Add extra prompt for release-critical severities (e.g. "This indicates
;;   the package is not suitable for release.  Proceed?")
;; - Possibly add a pre-send-mail hook to check that all entries are
;;   validated.
;; - Help texts need a top-level general one (say where to look them up,
;;   and how to search by package, bug submitter, maintainer, etc)
;; - debian-bug-control command/minor-mode to send messages to control@bugs,
;;   with a menubar of it's own with all possible commands.
;; - debian-bug-wnpp accepts empty package name!
;; - debian-bug-wnpp doesn't get a Bugs menu or web lookup.
;;   -> should lookup specified package to [O] and [ITO] ?
;;   -> or list all bugs for wnpp?
;; - add debian-bug-pseudo-package (with completion on those only, possibly
;;   with description)

;;; Todo (Francesco's list):
;;
;; - -f does not work (at least with bug)
;; [Done by psg] - apply contributed patch
;; [Done by psg] - error conditions: nonexistent package
;; - add doc strings and commentary
;; [Done by psg] - Help on menu of pseudo packages and severity levels (how???)
;; [Yes, psg] - we assume sed, uname, date are there; is that ok?

;;; User customizable variables:

(defgroup debian-bug nil "Debian Bug report helper"
  :group 'tools
  :prefix "debian-bug-")

(defcustom debian-bug-helper-program nil
  "Helper program to use to generate bug report background info.
Possible values are 'bug, 'reportbug or nil (for neither).
If not customized, it will get set to at runtime to 'bug if the command
exists, or else to 'reportbug if that command exists, or else simply parse
the status file."
  :group 'debian-bug
  :type '(choice (const :tag "reportbug" reportbug)
                 (const :tag "bug" bug)
                 (const :tag "set at runtime" nil)))

(defcustom debian-bug-use-From-address
  (or (getenv "DEBEMAIL")               ; reportbug
      (getenv "REPORTBUGEMAIL")         ; reportbug
      (getenv "EMAIL"))                 ; reportbug and bug
  "Insert a custom From line in the bug report header.
Use it to specify what email your bugs will be archived under."
  :group 'debian-bug
  :type 'boolean)

(if (not (fboundp 'match-string-no-properties))
    (load "poe" t t))                   ;XEmacs21.1 doesn't autoload this

;;; Guess From address initial value (if not set via customize)
(defun debian-bug-From-address-init ()
  "Return email to use for the From: line of the BTS email
The full name is from the environment variable DEBFULLNAME or else the
user-full-name variable.
The email address is from the environment variable DEBEMAIL or EMAIL,
or else the user-mail-address variable."
  (let ((fullname (or (getenv "DEBFULLNAME")
                      (getenv "DEBNAME") ; reportbug
                      (getenv "NAME")   ;  reportbug
		      (user-full-name)))
	(mailing-address
	 (or (getenv "DEBEMAIL")        ;  reportbug
	     (getenv "REPORTBUGEMAIL")  ;  reportbug
	     (getenv "EMAIL")           ;  reportbug and bug
	     (and (boundp 'user-mail-address) user-mail-address)
	     (and (fboundp 'user-mail-address) (user-mail-address)))))
    (cond
     ((and fullname mailing-address)
      (format "%s <%s>" fullname mailing-address))
     (mailing-address
      mailing-address)
     (t
      nil))))

(defcustom debian-bug-From-address (debian-bug-From-address-init)
  "Email address to use for the From: and CC: lines of Debian bug reports.
The default value is obtained from the function debian-bug-From-address-init."
  :group 'debian-bug
  :type 'string)

(defcustom debian-bug-always-CC-myself t
  "Insert a CC line to myself in the bug report header.
Will only actually do it if the variable debian-bug-From-address is set."
  :group 'debian-bug
  :type 'boolean)

;;; Internal variables:

(defvar debian-bug-mail-address
  "Debian Bug Tracking System <submit@bugs.debian.org>"
  "Email address that bugs are sent to.")

(defvar debian-bug-mail-quiet-address
  "Debian Bug Tracking System <quiet@bugs.debian.org>"
  "Address to use to send to the BTS but not forward to the maintainer.")

(defvar debian-bug-mail-maintonly-address
  "Debian Bug Tracking System <maintonly@bugs.debian.org>"
  "Address to use to send to the maintainer but not forward to the BTS.")

(defvar debian-bug-status-file "/var/lib/dpkg/status"
  "Debian installed package status file.
Used to get list of packages for prompt completion, and for report generation
when the shell commands \"bug\" and \"reportbug\" are not available")

(defvar debian-bug-severity-alist
  '(("critical") ("grave") ("serious") ("important")
    ("normal") ("minor") ("wishlist"))
  "Alist of possible bug severities used for prompt completion.")

(defvar debian-bug-tags-alist
  '(("patch") ("security") ("upstream"))
;;'(("patch") ("security") ("upstream") ("potato") ("woody") ("sid"))
  "alist of valid Tags.")

(defvar debian-bug-pseudo-packages
  '("base" "boot-floppy" "bugs.debian.org" "cdimage.debian.org" "cdrom"
    "ftp.debian.org" "general" "install" "installation" "kernel" "listarchives"
    "lists.debian.org" "mirrors" "nonus.debian.org" "potato-cd" "press"
    "project" "qa.debian.org" "security.debian.org" "tech-ctte" "wnpp"
    "www.debian.org")
  "List of Debian pseudo packages added (to packages-obarray) for completion
from http://www.debian.org/Bugs/pseudo-packages")

(defvar debian-bug-help-pseudo-packages-text
  "List of Debian pseudo packages
from http://www.debian.org/Bugs/pseudo-packages
Aug 10th 2001, checked Feb 8th 2002.

 base -- Base system (baseX_Y.tgz) general bugs
 boot-floppy -- Installation system
 bugs.debian.org -- The bug tracking system, @bugs.debian.org
 cdimage.debian.org -- CD Image issues
 cdrom -- Installation system
 ftp.debian.org -- Problems with the FTP site or Debian archive
                  (e.g. to have a package removed from testing or unstable)
 general -- General problems (e.g. \"many manpages are mode 755\")
 install -- Installation system
 installation -- Installation system
 kernel -- Problems with the Linux kernel, or that shipped with Debian
 listarchives -- Problems with the WWW mailiing list archives
 lists.debian.org -- The mailing lists, debian-*@lists.debian.org
 mirrors -- Problems with the official mirrors
 nonus.debian.org -- Problems with the non-US FTP site
 potato-cd -- Potato CD
 press -- Press release issues
 project -- Problems related to project administration
 qa.debian.org -- The Quality Assurance group
 security.debian.org -- The Debian Security Team
 tech-ctte -- The Debian Technical Committee (see the Constitution)
 wnpp -- Work-Needing and Prospective Packages list
 www.debian.org -- Problems with the WWW site")

(defvar debian-bug-packages-obarray nil
  "List of Debian packages from status file used for completion.")

(defvar debian-bug-packages-date nil
  "Last modification time of status file used for internal package list.
Used to determine if internal list is uptodate.")

(defvar debian-bug-package-name nil
  "Buffer-local variable holding the package name for this submission")
(make-variable-buffer-local 'debian-bug-package-name)

(defalias 'report-debian-bug 'debian-bug)

;;; Help texts:

(defvar debian-bug-help-severity-text
 "Info from http://www.debian.org/Bugs/Developer#severities
Feb 8th 2002

 Severity levels

 The bug system records a severity level with each bug report. This is set to
 normal by default, but can be overridden either by supplying a Severity line
 in the pseudo-header when the bug is submitted (see the instructions for
 reporting bugs), or by using the severity command with the control request
 server.

 The severity levels are:

 critical
      makes unrelated software on the system (or the whole system) break, or
      causes serious data loss, or introduces a security hole on systems
      where you install the package.
 grave
      makes the package in question unuseable or mostly so, or causes data
      loss, or introduces a security hole allowing access to the accounts of
      users who use the package.
 serious
      is a severe violation of Debian policy (that is, it violates a \"must\"
      or \"required\" directive), or, in the package maintainer's opinion,
      makes the package unsuitable for release.
 important
      a bug which has a major effect on the usability of a package, without
      rendering it completely unusable to everyone.
 normal
      the default value, applicable to most bugs.
 minor
      a problem which doesn't affect the package's usefulness, and is
      presumably trivial to fix.
 wishlist
      for any feature request, and also for any bugs that are very difficult
      to fix due to major design considerations.
 fixed
      for bugs that are fixed but should not yet be closed. This is an
      exception for bugs fixed by non-maintainer uploads. Note: the \"fixed\"
      tag should be used instead.

Certain severities are considered release-critical, meaning the bug will
have an impact on releasing the package with the stable release of
Debian.  Currently, these are critical, grave and serious.")

(defvar debian-bug-help-tags-text
 "Info from http://www.debian.org/Bugs/Developer#severities
Feb 8th 2002

 Tags for bug reports

 Each bug can have zero or more of a set of given tags. These tags are
 displayed in the list of bugs when you look at a package's page, and when
 you look at the full bug log.

 Tags can be set by supplying a Tags line in the pseudo-header when the bug
 is submitted (see the instructions for reporting bugs), or by using the tags
 command with the control request server.

 The current bug tags are:

 patch
      A patch or some other easy procedure for fixing the bug is included in
      the bug logs. If there's a patch, but it doesn't resolve the bug
      adequately or causes some other problems, this tag should not be used.
 wontfix
      This bug won't be fixed. Possibly because this is a choice between two
      arbitrary ways of doing things and the maintainer and submitter prefer
      different ways of doing things, possibly because changing the behaviour
      will cause other, worse, problems for others, or possibly for other
      reasons.
 moreinfo
      This bug can't be addressed until more information is provided by the
      submitter. The bug will be closed if the submitter doesn't provide more
      information in a reasonable (few months) timeframe. This is for bugs
      like \"It doesn't work\". What doesn't work?
 unreproducible
      This bug can't be reproduced on the maintainer's system. Assistance
      from third parties is needed in diagnosing the cause of the problem.
 help
      The maintainer is requesting help with dealing with this bug.
 pending
      The problem described in the bug is being actively worked on, i.e.
      a solution is pending.
 fixed
      This bug is fixed or worked around (by a non-maintainer upload, for
      example), but there's still an issue that needs to be resolved. This
      tag replaces the old \"fixed\" severity.
 security
      This bug describes a security problem in a package (e.g., bad
      permissions allowing access to data that shouldn't be accessible;
      buffer overruns allowing people to control a system in ways they
      shouldn't be able to; denial of service attacks that should be fixed,
      etc). Most security bugs should also be set at critical or grave
      severity.
 upstream
      This bug applies to the upstream part of the package.
 potato
      This bug particularly applies to the potato release of Debian.
 woody
      This bug particularly applies to the (unreleased) woody distribution.
 sid
      This bug particularly applies to an architecture that is currently
      unreleased (that is, in the sid distribution).

 The latter three tags are intended to be used mainly for release critical
 bugs, for which it's important to know which distributions are affected to
 make sure fixes (or removals) happen in the right place.")

(defvar debian-bug-help-email-text
  "Info from http://www.debian.org/Bugs/Reporting
Aug 10th 2001

 If a bug report is minor, for example, a documentation typo or a
 trivial build problem, please adjust the severity appropriately and
 send it to maintonly@bugs instead of submit@bugs. maintonly will
 forward the report to the package maintainer only, it won't forward it
 to the BTS mailing lists.

 If wish to report a bug to the bug tracking system that's already been
 sent to the maintainer, you can use quiet@bugs. Bugs sent to
 quiet@bugs will not be forwarded anywhere, only filed.

 Bugs sent to maintonly@bugs or to quiet@bugs are *still* posted to
 the Debian Bug Trcaking System web site (--psg).")

;;; Functions:

(defun debian-bug-intern (pair)
  (set (intern (car pair) debian-bug-packages-obarray) (cdr pair)))

(defun debian-bug-fill-packages-obarray ()
  "Build `debian-bug-packages-obarray' and return it.
The obarray associates each package with the installed version of the package."
  (if (not (and (vectorp debian-bug-packages-obarray)
		(equal debian-bug-packages-date
		       (nth 5 (file-attributes debian-bug-status-file)))))
      (let ((case-fold-search t)
	    (packages (length debian-bug-pseudo-packages))
	    (real-pkgs '())
	    this-pkg this-ver)
	(message "Building list of installed packages...")
	(with-temp-buffer
	  (insert-file-contents-literally debian-bug-status-file)
	  (while (not (eobp))
	    (cond ((looking-at "$")
		   (if (and this-pkg this-ver)
		       (setq real-pkgs (cons (cons this-pkg this-ver) real-pkgs)
			     packages (1+ packages)))
		   (setq this-pkg nil
			 this-ver nil))
		  ((looking-at "Package *: *\\([^ ]*\\)$")
		   (setq this-pkg (match-string 1)))
                  ((looking-at "Version *: *\\([^ ]*\\)$")
		   (setq this-ver (match-string 1))))
            (forward-line)))
	(setq debian-bug-packages-obarray
	      (make-vector (1- (ash 4 (logb packages))) 0)
	      debian-bug-packages-date
	      (nth 5 (file-attributes debian-bug-status-file)))
	(mapcar 'debian-bug-intern (mapcar 'list debian-bug-pseudo-packages))
	(mapcar 'debian-bug-intern real-pkgs)
	(message "Building list of installed packages...  Done.")))
  debian-bug-packages-obarray)

(defun debian-bug-helper-program-init ()
  (or debian-bug-helper-program
      (setq debian-bug-helper-program
	    (cond
	     ((zerop (call-process "which" nil nil nil "reportbug"))
	      'reportbug)
	     ((zerop (call-process "which" nil nil nil "bug"))
	      'bug)
	     (t
	      'none)))))

(defun debian-bug-prefill-report (package severity)
  (debian-bug-helper-program-init)
  (cond

   ;; bug
   ((and (eq debian-bug-helper-program 'bug)
	 (intern-soft package debian-bug-packages-obarray))
    (save-excursion
      (call-process "bug" nil '(t t) nil "-p" "-s" "" "-S" severity package))
    (forward-line 4))

   ;; reportbug
   ((eq debian-bug-helper-program 'reportbug)
    (save-excursion
      (call-process "reportbug" nil '(t t) nil
		    "--template" "-T" "none" "-s" "none" "-S" "normal" "-b"
                    "-q" package)
      (debian-bug--set-severity severity))
    ;; delete the mail headers, leaving only the BTS pseudo-headers
    (delete-region (point) (search-forward "\n\n" nil t))
    ;; and skip forward to them
    (search-forward "\n\n" nil t)
    )

   ;; neither reportbug nor bug
   (t
    (insert
     "\nPackage: " package
     "\nVersion: " (let ((sym (intern-soft package debian-bug-packages-obarray)))
		     (or (if (boundp sym) (symbol-value sym))
			 (format-time-string "+N/A; reported %Y-%m-%d")))
     "\nSeverity: " severity
     "\n\n\n\n-- System Information"
     "\nDebian Release: ")

    (if (file-readable-p "/etc/debian_version")
	(forward-char (cadr
		       (insert-file-contents-literally "/etc/debian_version")))
      (insert "unknwown\n"))

    (insert "Kernel Version: ")
    (call-process "uname" nil '(t t) nil "-a")
    (forward-line -5))))

(defun debian-bug (&optional package)
  "Submit a Debian bug report."
  (interactive (list (completing-read
                      "Package name: "
                      (debian-bug-fill-packages-obarray)
                      nil nil nil nil (current-word))))
    (if (string= package "wnpp")
	(debian-bug-wnpp)
      (if (and (not (intern-soft package debian-bug-packages-obarray))
               (not (y-or-n-p
                     "Package does not appear to be installed. Continue? ")))
          (error "Quitting."))
      (let ((severity (completing-read "Severity (default normal): "
                                       debian-bug-severity-alist
                                       nil t nil nil "normal"))
            (subject (read-string "(Very) brief summary of problem: ")))
	(require 'reporter)
	(reporter-compose-outgoing)
        (if (and (equal mail-user-agent 'gnus-user-agent)
                 (string-equal " *nntpd*" (buffer-name)))
            (set-buffer "*mail*"))   ; Bug in emacs21.1?  Moves to " *nntpd*"
        (goto-char (point-min))
        (cond
         ((re-search-forward "To: " nil t)
          (insert debian-bug-mail-address))
         ((re-search-forward "To:" nil t)
          (insert " " debian-bug-mail-address))
         (t
          (insert "To: " debian-bug-mail-address)))
        (if (or (string-equal severity "wishlist")
                (string-equal severity "minor"))
            (debian-bug--set-bts-address "maintonly@bugs.debian.org"))
        (goto-char (point-min))
        (cond
         ((re-search-forward "Subject: " nil t)
          (insert package ": " subject))
         ((re-search-forward "Subject:" nil t)
          (insert " " package ": " subject))
         (t
          (insert "Subject: " package ": " subject)))
        (require 'sendmail)
        (goto-char (mail-header-end))
        (forward-line 1)
        (message "Getting package information from system...")
	(debian-bug-prefill-report package severity)
        (message "Getting package information from system...done")
	(if debian-bug-use-From-address
            (debian-bug--set-custom-From))
	(if debian-bug-always-CC-myself
            (debian-bug--set-X-Debbugs-CC debian-bug-From-address))
	(set-window-start (selected-window) (point-min) t)
	(setq debian-bug-package-name package)
	(debian-bug-minor-mode 1)
	(set-buffer-modified-p nil))))

;;; ---------
;;; WNPP interface by Peter S Galbraith <psg@debian.org>, August 4th 2001
(defvar debian-bug-wnpp-alist
  '(("Intent to Package [ITP]" . "ITP")
    ("Orphaned [O]". "O")
    ("Request for Adoption [RFA]" . "RFA")
    ("Request For Package [RFP]" . "RFP"))
  "alist of WNPP possible bug reports")

(defvar debian-bug-wnpp-severities
  '(("ITP" . "wishlist")
    ("O". "normal")
    ("RFA" . "normal")
    ("RFP" . "wishlist"))
  "Bug severeties for each WNPP bug type.")

(defun debian-bug-wnpp (&optional action)
  "Submit a WNPP bug report to Debian."
  (interactive
   (list (completing-read
	  "Action: (Press TAB) "  debian-bug-wnpp-alist nil t nil)))
  (if (or (not action) (string= action ""))
      (setq action (completing-read
                    "Action: (Press TAB) "  debian-bug-wnpp-alist nil t nil)))
  (if (or (not action) (string= action ""))
      (error "Nothing to do"))
  (require 'reporter)
  (debian-bug-fill-packages-obarray)
  (let* ((tag (cdr (assoc action debian-bug-wnpp-alist)))
	 (severity (cdr (assoc tag debian-bug-wnpp-severities)))
	 (package
	  (completing-read
	   (cond ((string-equal action "Intent to Package [ITP]")
                  "Proposed package name: ")
                 ((string-equal action "Request For Package [RFP]")
                  "Requested package name: ")
                 (t
                  "package name: "))
           debian-bug-packages-obarray nil nil nil))
         ;;FIXME: Should fetch description from system for "[O]" and "[ITO]"
	 (description (read-string "Very short package description: "))
	 (CC-devel (y-or-n-p "CC bug report to debian-devel? ")))
    (require 'reporter)
    (reporter-compose-outgoing)
    (if (and (equal mail-user-agent 'gnus-user-agent)
             (string-equal " *nntpd*" (buffer-name)))
        (set-buffer "*mail*"))   ; Bug in emacs21.1?  Moves to " *nntpd*"
    (goto-char (point-min))
    (if (re-search-forward "To:" nil t)
        (insert " " debian-bug-mail-address)
      (insert "To: " debian-bug-mail-address))
    (require 'sendmail)
    (goto-char (mail-header-end))
    (forward-line 1)
    (save-excursion
      (goto-char (point-min))
      (if debian-bug-use-From-address
          (debian-bug--set-custom-From))
      (if debian-bug-always-CC-myself
          (debian-bug--set-X-Debbugs-CC debian-bug-From-address))
      (if (re-search-forward "Subject: " nil t)
          (insert (format "%s: %s -- %s" tag package description))
        (re-search-forward "Subject:" nil t)
        (insert (format " %s: %s -- %s" tag package description)))
      (if CC-devel
          (debian-bug--set-X-Debbugs-CC "debian-devel@lists.debian.org")))
    (insert "Package: wnpp\n"
	    (format "Severity: %s\n\n" severity))
    (when (or (string-equal tag "ITP")
	      (string-equal tag "RFP"))
      (insert
;;;    "< Enter some information about the package, upstream URL and license here. >\n"
       "* Package name    : " package "\n"
       "  Version         : \n"
       "  Upstream Author : \n"
       "* URL or Web page : \n"
       "* License         : \n"
       "  Description     : " description "\n")
      (forward-line -1))
    (set-window-start (selected-window) (point-min) t)
    (debian-bug-wnpp-minor-mode 1)
    (set-buffer-modified-p nil)))

(defun debian-bug-request-for-package ()
  "Shortcut for debian-bug-wnpp with RFP action"
  (interactive)
  (debian-bug-wnpp "Request For Package [RFP]"))
(defalias 'debian-bug-RFP 'debian-bug-request-for-package)

(defun debian-bug-intent-to-package ()
  "Shortcut for debian-bug-wnpp with ITP action (for Debian developers)"
  (interactive)
  (debian-bug-wnpp "Intent to Package [ITP]"))
(defalias 'debian-bug-ITP 'debian-bug-intent-to-package)

;;; font-lock by Peter S Galbraith <psg@debian.org>, August 11th 2001
(defvar debian-bug-font-lock-keywords
  '(("^ *\\(Package:\\) *\\([^ ]+\n\\)?"
     (1 font-lock-keyword-face)
     (2 font-lock-type-face nil t))
    ("^ *\\(Version:\\) *\\([^ \n]+\n\\)?"
     (1 font-lock-keyword-face)
     (2 font-lock-type-face nil t))
    ("^ *\\(Tags:\\).*\\(patch\\)"
     (1 font-lock-keyword-face)
     (2 font-lock-type-face nil t))
    ("^ *\\(Tags:\\).*\\(security\\)"
     (1 font-lock-keyword-face)
     (2 font-lock-warning-face nil t))
    ("^ *\\(Severity:\\) *\\(\\(critical\\|grave\\|serious\\)\\|\\(important\\)\\|\\(normal\\)\\|\\(\\(minor\\)\\|\\(wishlist\\)\\)\\)"
     (1 font-lock-keyword-face)
     (3 font-lock-warning-face nil t)
     (4 font-lock-function-name-face nil t)
     (5 font-lock-type-face nil t)
     (6 font-lock-string-face nil t))
    ("^Subject: \\[\\(ITP\\|O\\|RFA\\|RFP\\)\\]"
     (1 font-lock-warning-face t t)))
  "Regexp keywords to fontify debian-bug reports.")

;;; ---------
;;; Menu-bar via minor-mode
;;  Peter S Galbraith <psg@debian.org>, August 12th 2001

(defun debian-bug--is-custom-From ()
  (save-excursion
    (goto-char (point-min))
    (looking-at "^From:")))

(defun debian-bug--unset-custom-From ()
  "Remove From line in the mail header."
  (save-excursion
    (goto-char (point-min))
    (let ((header-end (re-search-forward "^-*$" nil t)))
      (goto-char (point-min))
      (when (re-search-forward "^From:" header-end t)
	(delete-region (progn (beginning-of-line)(point))
                       (progn (forward-line 1)(point)))))))

(defun debian-bug--set-custom-From ()
  "Set a From line using the debian-bug-From-address variable"
  (if (not debian-bug-From-address)
      (error "Variable debian-bug-From-address is unset, please customize it.")
    (save-excursion
      (goto-char (point-min))
      (debian-bug--unset-custom-From)
      (insert "From: " debian-bug-From-address "\n"))))

(defun debian-bug--toggle-custom-From ()
  "Toggle the From line using the debian-bug-From-address variable."
  (interactive)
  (if (debian-bug--is-custom-From)
      (debian-bug--unset-custom-From)
    (debian-bug--set-custom-From)))

(defun debian-bug--is-X-Debbugs-CC (address)
  (save-excursion
    (goto-char (point-min))
    (re-search-forward
     (concat "^X-Debbugs-CC:.*" (regexp-quote address)) nil t)))

(defun debian-bug--remove-X-Debbugs-CC (address &optional nocleanup)
  "Remove an Address, and by default cleanup empty line."
  (save-excursion
    (goto-char (point-min))
    (if (or (re-search-forward (concat "^X-Debbugs-CC:.*\\("
				       (regexp-quote address) ", \\)") nil t)
	    (re-search-forward (concat "^X-Debbugs-CC:.*\\(, "
				       (regexp-quote address) "\\)") nil t)
	    (re-search-forward (concat "^X-Debbugs-CC:.*\\("
				       (regexp-quote address) "\\)") nil t))
	(delete-region (match-beginning 1)(match-end 1)))
    (goto-char (point-min))
    (if (and (not nocleanup)
	     (re-search-forward "^ *X-Debbugs-CC: *\n" nil t))
	(delete-region (match-beginning 0)(match-end 0)))))

(defun debian-bug--set-X-Debbugs-CC (address)
  "Set/Change X-Debbugs-CC. ARG is address to use."
  (debian-bug--remove-X-Debbugs-CC address t)
  (save-excursion
    (goto-char (point-min))
    (cond
     ((re-search-forward "^X-Debbugs-CC: *$" nil t) ; Empty  X-Debbugs-CC:
      (insert address))
     ((re-search-forward "^X-Debbugs-CC:.*$" nil t) ; Existing X-Debbugs-CC:
      (insert ", " address))
     ((re-search-forward "^Subject:.*\n" nil t)
      (insert "X-Debbugs-CC: " address "\n"))
     ((re-search-forward "^To: .*\n" nil t)
      (insert "X-Debbugs-CC: " address "\n"))
     (t
      (insert "X-Debbugs-CC: " address "\n")))))

(defun debian-bug--toggle-X-Debbugs-CC (address)
  "Toggle a X-Debbugs-CC header line"
  (if (debian-bug--is-X-Debbugs-CC address)
      (debian-bug--remove-X-Debbugs-CC address)
    (debian-bug--set-X-Debbugs-CC address)))

(defun debian-bug--toggle-CC-myself ()
  "Toggle X-Debbugs-CC: line for myself in the mail header."
  (interactive)
  (if debian-bug-From-address
    (debian-bug--toggle-X-Debbugs-CC debian-bug-From-address)))

(defun debian-bug--toggle-CC-devel ()
  "Toggle X-Debbugs-CC: line for myself in the mail header."
  (interactive)
  (debian-bug--toggle-X-Debbugs-CC "debian-devel@lists.debian.org"))

(defun debian-bug--is-severity (severity)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^ *Severity: +\\([a-zA-Z]+\\)" nil t)
	(let ((actualSeverity (match-string-no-properties 1)))
	  (string= actualSeverity severity)))))

(defun debian-bug--set-severity (severity)
  "Set/Change bug severity level."
  (interactive (list (completing-read "Severity: " debian-bug-severity-alist
				      nil t nil nil)))
  (if (not severity)
      nil				; We're done!
    (save-excursion
      (goto-char (point-min))
      (cond
       ((re-search-forward "^ *Severity: \\([a-zA-Z]+\\)" nil t)
	(goto-char (match-beginning 1))
	(delete-region (match-beginning 1)(match-end 1))
	(insert severity))
       ((re-search-forward "^ *Version: .*\n" nil t)
	(insert "Severity: " severity))
       ((re-search-forward "^ *Package: .*\n" nil t)
	(insert "Severity: " severity))
       (t
	(forward-line 6)
	(insert "\nSeverity: " severity "\n"))))))


(defun debian-bug--is-tags (tag)
  (save-excursion
    (goto-char (point-min))
    (re-search-forward (concat "^ *Tags:.*" tag) nil t)))

(defun debian-bug--remove-tags (tag &optional nocleanup)
  "Remove a Tag"
  (save-excursion
    (goto-char (point-min))
    (if (or (re-search-forward (concat "^ *Tags:.*\\(" tag ", \\)") nil t)
	    (re-search-forward (concat "^ *Tags:.*\\(, " tag "\\)") nil t)
	    (re-search-forward (concat "^ *Tags:.*\\(" tag "\\)") nil t))
	(delete-region (match-beginning 1)(match-end 1)))
    (goto-char (point-min))
    (if (and (not nocleanup)
	     (re-search-forward "^ *Tags: *\n" nil t))
	(delete-region (match-beginning 0)(match-end 0)))))

(defun debian-bug--set-tags (tag)
  "Set/Change Tags"
  (debian-bug--remove-tags tag t)
  (save-excursion
    (goto-char (point-min))
    (cond 
     ((re-search-forward "^ *Tags: *$" nil t) ; Empty "Tags: "
      (insert tag))
     ((re-search-forward "^ *Tags:.*$" nil t) ; Existing "Tags: "
      (insert ", " tag))
     ((re-search-forward "^ *Severity: .*\n" nil t)	
      (insert "Tags: " tag "\n"))
     ((re-search-forward "^ *Version: .*\n" nil t)	
      (insert "Tags: " tag "\n"))
     ((re-search-forward "^ *Package: .*\n" nil t)	
      (insert "Tags: " tag "\n"))
     (t
      (forward-line 6)
      (insert "\nTags: " tag "\n")))))
	
(defun debian-bug--toggle-tags (tag)
  "Toggle a Tag"
  (interactive (list (completing-read "Tag: " debian-bug-tags-alist
				      nil t nil nil)))
  (if (not tag)
      nil				; We're done!
    (if (debian-bug--is-tags tag)
	(debian-bug--remove-tags tag)
      (debian-bug--set-tags tag))))

(defun debian-bug--is-bts-address (address)
  (save-excursion
    (goto-char (point-min))
    (re-search-forward (concat "^To:.*" (regexp-quote address)) nil t)))

(defun debian-bug--set-bts-address (address)
  "Set/Change \"To\" header line."
  (interactive (list (completing-read "To: " 
				      '(("submit@bugs.debian.org")
					("quiet@bugs.debian.org")
					("maintonly@bugs.debian.org"))
				      nil t nil nil)))
  (cond
   ((string= "submit@bugs.debian.org" address)
    (setq address debian-bug-mail-address))
   ((string= "quiet@bugs.debian.org" address)
    (setq address debian-bug-mail-quiet-address))
   ((string= "maintonly@bugs.debian.org" address)
    (setq address debian-bug-mail-maintonly-address)))
  (if (not address)
      nil				; We're done!
    (save-excursion
      (goto-char (point-min))
      (cond 
       ((re-search-forward "^To: \\(.*\\)" nil t)	
	(goto-char (match-beginning 1))
	(delete-region (match-beginning 1)(match-end 1))
	(insert address))
       (t
	(insert "To: " address "\n"))))))


(defun debian-bug-help-severity ()
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ debian-bug-help-severity-text)))

(defun debian-bug-help-tags ()
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ debian-bug-help-tags-text)))

(defun debian-bug-help-pseudo-packages ()
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ debian-bug-help-pseudo-packages-text)))

(defun debian-bug-help-email ()
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ debian-bug-help-email-text)))

(defvar debian-bug-minor-mode nil)
(defvar debian-bug-minor-mode-map nil
  "Keymap for debian-bug minor mode.")
(if debian-bug-minor-mode-map
    nil
  (setq debian-bug-minor-mode-map (make-sparse-keymap)))

(easy-menu-define debian-bug-menu debian-bug-minor-mode-map 
  "Debian Bug Mode Menu"
  '("Debian-Bug"
    ("Header"
     ["Custom From Address" (debian-bug--toggle-custom-From)
      :style toggle :active debian-bug-From-address
      :selected (debian-bug--is-custom-From)]
     "--"
     ["To BTS, Maintainer and Mailing Lists" 
      (debian-bug--set-bts-address "submit@bugs.debian.org")
      :style radio 
      :selected (debian-bug--is-bts-address debian-bug-mail-address)]
     ["To BTS and Maintainer Only" 
     (debian-bug--set-bts-address "maintonly@bugs.debian.org")
     :style radio 
     :selected (debian-bug--is-bts-address debian-bug-mail-maintonly-address)]
     ["To BTS Only" 
      (debian-bug--set-bts-address "quiet@bugs.debian.org")
      :style radio 
      :selected (debian-bug--is-bts-address debian-bug-mail-quiet-address)]
     "--"
     ["CC debian-devel" (debian-bug--toggle-CC-devel)
      :style toggle
      :selected (debian-bug--is-X-Debbugs-CC "debian-devel@lists.debian.org")]
     ["CC me" (debian-bug--toggle-CC-myself)
      :style toggle :active debian-bug-From-address
      :selected (debian-bug--is-X-Debbugs-CC debian-bug-From-address)]
     )
    ("Severity"
     ["critical" (debian-bug--set-severity "critical") 
      :style radio :selected (debian-bug--is-severity "critical")]
     ["grave" (debian-bug--set-severity "grave") 
      :style radio :selected (debian-bug--is-severity "grave")]
     ["serious" (debian-bug--set-severity "serious") 
      :style radio :selected (debian-bug--is-severity "serious")]
     ["important" (debian-bug--set-severity "important") 
      :style radio :selected (debian-bug--is-severity "important")]
     ["normal" (debian-bug--set-severity "normal") 
      :style radio :selected (debian-bug--is-severity "normal")]
     ["minor" (debian-bug--set-severity "minor") 
      :style radio :selected (debian-bug--is-severity "minor")]
     ["wishlist" (debian-bug--set-severity "wishlist") 
      :style radio :selected (debian-bug--is-severity "wishlist")]
     )
    ("Tags"
     ["Patch Included" (debian-bug--toggle-tags "patch") 
      :style toggle :selected (debian-bug--is-tags "patch")]
     ["Security Issue!" (debian-bug--toggle-tags "security") 
      :style toggle :selected (debian-bug--is-tags "security")]
     )
    ("Web View"
     ["Bugs for This Package" (debian-bug-web-bugs) t]
     ["Bug Number..." (debian-bug-web-bug) t]
     ["Package Info" (debian-bug-web-packages) t]
;;   ("Info for This Package" 
;;    ["Stable" (debian-bug-web-package "stable") t]
;;    ["Testing" (debian-bug-web-package "testing") t]
;;    ["Unstable" (debian-bug-web-package "unstable") t]
;;    )
     )
    ["Customize" 
     (customize-group "debian-bug") (fboundp 'customize-group)]
    ("Help"
     ["Severities" (debian-bug-help-severity) t]
     ["Tags" (debian-bug-help-tags) t]
     ["Pseudo-Packages" (debian-bug-help-pseudo-packages) t]
     ["Addresses" (debian-bug-help-email) t]
     )
    ))

(defun debian-bug-minor-mode (arg)
  "Toggle debian-bug mode."
  (interactive "P")
  (set (make-local-variable 'debian-bug-minor-mode)
       (if arg
           (> (prefix-numeric-value arg) 0)
         (not debian-bug-minor-mode)))
  (cond 
   (debian-bug-minor-mode                 ;Setup the minor-mode
    (if (fboundp 'font-lock-add-keywords)
        (font-lock-add-keywords nil debian-bug-font-lock-keywords t))
    (debian-bug-bug-menu-init debian-bug-minor-mode-map)
    (easy-menu-add debian-bug-menu))))

;; Install ourselves:
(or (assq 'debian-bug-minor-mode minor-mode-alist)
    (setq minor-mode-alist 
          (cons '(debian-bug-minor-mode " DBug") minor-mode-alist)))
(or (assq 'debian-bug-minor-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
          (cons (cons 'debian-bug-minor-mode debian-bug-minor-mode-map) 
                minor-mode-map-alist)))

;;; ---------
;;; wnpp-minor-mode - like debian-bug-minor-mode but with limited menu

(defvar debian-bug-wnpp-minor-mode nil)
(defvar debian-bug-wnpp-minor-mode-map nil
  "Keymap for debian-bug minor mode.")
(if debian-bug-wnpp-minor-mode-map
    nil
  (setq debian-bug-wnpp-minor-mode-map (make-sparse-keymap)))

(easy-menu-define debian-bug-wnpp-menu debian-bug-wnpp-minor-mode-map 
  "Debian Bug Mode Menu"
  '("Debian-Bug"
    ["Custom From address" (debian-bug--toggle-custom-From)
     :style radio :active debian-bug-From-address
     :selected (debian-bug--is-custom-From)]
    ["CC to debian-devel header line" (debian-bug--toggle-CC-devel)
     :style radio
     :selected (debian-bug--is-X-Debbugs-CC "debian-devel@lists.debian.org")]
    ["CC to myself header line" (debian-bug--toggle-CC-myself)
     :style radio :active debian-bug-From-address
     :selected (debian-bug--is-X-Debbugs-CC debian-bug-From-address)]
    ["Customize debian-bug" 
     (customize-group "debian-bug") (fboundp 'customize-group)]
    ))

(defun debian-bug-wnpp-minor-mode (arg)
  "Toggle debian-bug mode."
  (interactive "P")
  (set (make-local-variable 'debian-bug-wnpp-minor-mode)
       (if arg
           (> (prefix-numeric-value arg) 0)
         (not debian-bug-wnpp-minor-mode)))
  (cond 
   (debian-bug-wnpp-minor-mode                 ;Setup the minor-mode
    (if (fboundp 'font-lock-add-keywords)
        (font-lock-add-keywords nil debian-bug-font-lock-keywords t))
    (easy-menu-add debian-bug-wnpp-menu))))

;; Install ourselves:
(or (assq 'debian-bug-wnpp-minor-mode minor-mode-alist)
    (setq minor-mode-alist 
          (cons '(debian-bug-wnpp-minor-mode " WNPPBug") minor-mode-alist)))
(or (assq 'debian-bug-wnpp-minor-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
          (cons (cons 'debian-bug-wnpp-minor-mode debian-bug-wnpp-minor-mode-map) 
                minor-mode-map-alist)))

;;; ---------
;;; browse-url interfaces from debian-changelog-mode.el
;;  by Peter Galbraith, Feb 23 2001

(defun debian-bug-web-bugs ()
  "Browse the BTS for this package via browse-url"
  (interactive)
  (if (not (featurep 'browse-url))
      (progn
        (load "browse-url" nil t)
        (if (not (featurep 'browse-url))
            (error "This function requires the browse-url elisp package"))))
  (let ((pkg-name (or debian-bug-package-name
                      (and (fboundp 'debian-changelog-suggest-package-name)
                           (debian-changelog-suggest-package-name))
		      (read-string "Package name: "))))
    (if (string-equal "" pkg-name)
        (message "No package name to look up.")
      (browse-url (concat "http://bugs.debian.org/cgi-bin/pkgreport.cgi?src="
                          pkg-name))
      (message "Looking up bugs for source package %s via browse-url"
               pkg-name))))

(defun debian-bug-web-bug (&optional bug-number)
  "Browse the BTS for a bug report number via browse-url"
  (interactive (list (completing-read "Bug number to lookup: " 
                                      debian-bug-alist nil nil)))
  (if (not (featurep 'browse-url))
      (progn
        (load "browse-url" nil t)
        (if (not (featurep 'browse-url))
            (error "This function requires the browse-url elisp package"))))
  (if (or (not bug-number) (string-equal bug-number "none"))
      (setq bug-number (completing-read "Bug number to lookup: " 
                                      debian-bug-alist nil nil)))
  (if (string-equal bug-number "")
      (message "No bug number to look up.")
    (browse-url
     (concat "http://bugs.debian.org/cgi-bin/bugreport.cgi?archive=yes&bug="
             bug-number))
    (message "Looking up bug number %s via browse-url" bug-number)))

(defun debian-bug-web-this-bug ()
  "Browse the BTS via browse-url for the bug report number under point."
  (interactive)
  (if (not (looking-at "[0-9]"))
      (error "Not a number under point/mouse"))
  (save-excursion
    (skip-chars-backward "0123456789")
    (if (looking-at "[0-9]+")
        (let ((bug-number (match-string 0)))
          (debian-bug-web-bug bug-number)))))

(defun debian-bug-web-this-bug-under-mouse (EVENT)
  "Browse the BTS via browse-url for the bug report number under mouse."
  (interactive "e")
  (mouse-set-point EVENT)
  (debian-bug-web-this-bug))

(defun debian-bug-web-packages ()
  "Search Debian web page for this package via browse-url"
  (interactive)
  (if (not (featurep 'browse-url))
      (progn
        (load "browse-url" nil t)
        (if (not (featurep 'browse-url))
            (error "This function requires the browse-url elisp package"))))
  (let ((pkg-name (or debian-bug-package-name
                      (and (fboundp 'debian-changelog-suggest-package-name)
                           (debian-changelog-suggest-package-name))
		      (read-string "Package name: "))))
    (if (string-equal "" pkg-name)
        (message "No package name to look up.")
      (browse-url 
       (concat 
        "http://packages.debian.org/cgi-bin/search_packages.pl?keywords="
        pkg-name
        "&searchon=names&version=all&release=all"))
      (message "Looking up web pages for package %s via browse-url" 
               pkg-name))))

(defvar debian-bug-archive-alist
  '(("stable") ("testing") ("unstable"))
  "alist of valid Debian archives for web interface (excludes experimental).")

(defvar debian-bug-archive-list
  '("stable" "testing" "unstable")
  "list of valid Debian archives.")

(defun debian-bug-web-package (archive)
  "Search Debian web page in ARCHIVE for this package via browse-url"
  (interactive "P")
  (if (not (featurep 'browse-url))
      (progn
        (load "browse-url" nil t)
        (if (not (featurep 'browse-url))
            (error "This function requires the browse-url elisp package"))))
  (let ((pkg-name (or debian-bug-package-name
                      (and (fboundp 'debian-changelog-suggest-package-name)
                           (debian-changelog-suggest-package-name))
		      (read-string "Package name: ")))
        (archiv))
    (if (string-equal "" pkg-name)
        (message "No package name to look up.")
      (if (not (member (list archive) debian-bug-archive-alist))
          (setq archive
                (completing-read "Debian archive: "
                                 debian-bug-archive-alist nil t nil)))
      (if (string-equal "" archive)
          (message "No archive name to look up.")
        (browse-url 
         (concat 
          "http://packages.debian.org/cgi-bin/search_packages.pl?keywords="
          pkg-name
          "&searchon=names&release=all&version=" archive))
        (message "Looking up %s web page for package %s via browse-url"
                 archive pkg-name)))))

;;;-------------
;;; wget bug from BTS stuff - Peter Galbraith, August 2001
;;; from debian-changelog-mode.el

(defun debian-bug-menucount ()
  "Return the number of bugs after wget process."
;; Or simply count number of lines minus 5
  (save-excursion
    (goto-char (point-min))
    (let ((count 0))
      (while (re-search-forward "^\[\"[0-9]+:" nil t)
        (setq count (1+ count)))
      count)))

(defun debian-bug-menusplit-p (submenu)
  "return t if we should split the menu, comparing bug numbers to frame size.
If SUBMENU is t, then check for current sexp submenu only."
  (let* ((menu-count (if submenu
                         (save-excursion 
                           (count-lines (point)
                                        (progn (forward-sexp 1)(point))))
                       (debian-bug-menucount)))
         (frame-lines (cond ((< 60 (frame-height)) ;Big frames
                             (- (frame-height) 17))
                            ((< 40 (frame-height)) ;Med frames
                             (- (frame-height) 10))
                            (t
                             (- (frame-height) 6))))) ;Smaller frames
    (if (>= frame-lines menu-count)
        nil                    ; No split at all
      t)))

(defun debian-bug-submenusplit ()
  "Split this submenu, located in sexp."
  (save-excursion
    (save-restriction
      ;; First, narrow to submenu
      (narrow-to-region (point)
                        (progn (forward-sexp 1)(forward-char -2)(point)))
      (goto-char (point-min))      
      (forward-line 1)
      ;; Now on first bug...
      (let ((lines (cond ((< 60 (frame-height)) ;Big frames
                          (- (frame-height) 25))
                         ((< 40 (frame-height)) ;Med frames
                          (- (frame-height) 20))
                         (t
                          (- (frame-height) 6)))) ;Smaller frames
            (start (point))
            (bugn-end)(bugn-beg))
        (while (< (point) (point-max)) 
          (forward-line lines)
          (beginning-of-line)
          (looking-at "^\\[\"\\([0-9]+\\):")
          (setq bugn-end (match-string 1))
          (end-of-line)
          (insert ")")
          (goto-char start)
          (looking-at "^\\[\"\\([0-9]+\\):")
          (setq bugn-beg (match-string 1))
          (insert (format "(\"%s-%s\"\n" bugn-beg bugn-end))
          (forward-line -1)
          (forward-sexp 1)
          (forward-line 1)
          (setq start (point))))))
  (forward-sexp 1)
  (beginning-of-line))
          
(defvar debian-bug-alist nil
  "Buffer local alist of bug numbers (and description) for this package")
(make-variable-buffer-local 'debian-bug-alist)

(defun debian-bug-build-bug-menu (package)
  "Build a menu listing the bugs for this package"
  (setq debian-bug-alist nil)
  (let ((debian-bug-tmp-buffer 
         (get-buffer-create "*debian-bug-tmp-buffer*"))
        (bug-alist)
        (debian-bug-menu-var))
    (save-excursion
      (set-buffer debian-bug-tmp-buffer)
      (insert "(setq debian-bug-menu-var\n'(\"Bugs\"\n")
      (insert "[\"* Regenerate list *\" (debian-bug-build-bug-this-menu) t]\n\"--\"\n")
      (with-temp-buffer
	(call-process "wget" nil '(t t) nil "--quiet" "-O" "-" 
		      (concat 
                       "http://bugs.debian.org/cgi-bin/pkgreport.cgi?src="
                       package))
	(goto-char (point-min))
        (while 
            (re-search-forward
             "\\(<H2>\\(.+\\)</H2>\\)\\|\\(<li><a href=\"\\(bugreport.cgi\\?bug=\\([0-9]+\\)\\)\">#\\(.+\\)</a>\\)"
             nil t)
          (let ((type (match-string 2))
                (URL (match-string 4))
                (bugnumber (match-string 5))
                (description (match-string 6)))
            (cond
             (type
              (save-excursion
                (set-buffer debian-bug-tmp-buffer)
                (insert "\"" type "\"\n")))
             (t
              (setq bug-alist (cons (list bugnumber description) bug-alist))
              (save-excursion
                (set-buffer debian-bug-tmp-buffer)
                (insert 
                 "[\"" (if (< 60 (length description))
                           (substring description 0 60)
                         description)
                 "\" (debian-bug-web-bug \"" bugnumber "\") t]\n")))))))
      (set-buffer debian-bug-tmp-buffer) ;Make sure we're here
      (insert "))")
      (when (debian-bug-menusplit-p nil)
        (goto-char (point-min))
        ;; First split on bug severities
        (when (and (re-search-forward "^\"--" nil t)
                   (re-search-forward "^\"" nil t))
          (when (search-forward " to upstream software authors"
                                (save-excursion (progn (end-of-line)(point)))
                                t)
            (replace-match " upstream"))
          (beginning-of-line)
          (insert "(")
          (while (re-search-forward "^\"" nil t)
            (when (search-forward " to upstream software authors"
                                  (save-excursion (progn (end-of-line)(point)))
                                  t)
              (replace-match " upstream"))
            (beginning-of-line)
            (insert ")("))
          (goto-char (point-max))
          (insert ")")
          ;; Next check for long menus, and split those again
          (goto-char (point-min))
          (while (re-search-forward "^)?(\"" nil t)
            (forward-char -2)
            (if (debian-bug-menusplit-p t)
                (debian-bug-submenusplit)
              (end-of-line)))
          ))
      (eval-buffer debian-bug-tmp-buffer)
      (kill-buffer nil)
      )
    (setq debian-bug-alist bug-alist)
    (cond
     ((equal major-mode 'debian-changelog-mode)
      (easy-menu-define
        debian-bug-bugs-menu 
        debian-changelog-mode-map "Debian Bug Mode Bugs Menu"
        debian-bug-menu-var)
      (cond
       ((string-match "XEmacs" emacs-version)
        (easy-menu-remove debian-bug-bugs-menu)
        (easy-menu-remove debian-changelog-menu)
        (easy-menu-add debian-bug-bugs-menu)
        (easy-menu-add debian-changelog-menu))))
     (t
      (easy-menu-define
        debian-bug-bugs-menu 
        debian-bug-minor-mode-map "Debian Bug Mode Bugs Menu"
        debian-bug-menu-var)
      (cond
       ((string-match "XEmacs" emacs-version)
        (easy-menu-remove debian-bug-bugs-menu)
        (easy-menu-remove debian-bug-menu)
        (easy-menu-add debian-bug-bugs-menu)
        (easy-menu-add debian-bug-menu)))))))

(defun debian-bug-build-bug-this-menu ()
  "Regenerate Bugs list menu for this buffer's package"
  (let ((package (or (and (fboundp 'debian-changelog-suggest-package-name)
			  (debian-changelog-suggest-package-name))
		     (and (boundp 'debian-bug-package-name)
			  debian-bug-package-name)
		     (read-string "Package name: "))))
    (debian-bug-build-bug-menu package)))

(defun debian-bug-bug-menu-init (minor-mode-map)
  "Initialize menu -- before it gets filled-in on request.
Add this function to the calling major-mode function."
  (easy-menu-define debian-bug-bugs-menu minor-mode-map 
    "Debian Bug Mode Bugs Menu"
    '("Bugs"
      ["* Generate menu *" (debian-bug-build-bug-this-menu) 
       (zerop (call-process "which" nil nil nil "wget"))]))
  (easy-menu-add debian-bug-bugs-menu))

;;;-------------
;;; debian-bug-filename - Peter Galbraith, July 2002.
;;;

(defun debian-bug-search-file (filename)
  "Search for FILENAME returning which package name it belongs to."
  (save-excursion
    (let ((tmp-buffer (get-buffer-create " *debian-bug-tmp*")))
      (set-buffer tmp-buffer)
      (unwind-protect
          (progn
            (call-process "dpkg" nil '(t nil) nil "-S" 
                          (expand-file-name filename))
            (goto-char (point-min))
            (cond 
             ((re-search-forward "not found.$" nil t)
              (message "%s not found in package list." filename)
              nil)
             ((re-search-forward "^\\(.*, .*\\): " nil t)
              (with-output-to-temp-buffer "*Help*"
                (princ (format "Please refine your search,\nthere is more than one matched package:\n\n%s" (match-string 1))))
              nil)
             ((re-search-forward "^\\(.*\\): " nil t)
              (match-string 1))
             (t
              (message "%s not found in package list." filename)
              nil)))
        (kill-buffer tmp-buffer)))))

(defun debian-bug-filename ()
  "Submit a Debian bug report for a given filename's package."
  (interactive)
  (let ((filename (read-file-name "Filename: " "/" nil t nil)))
    (cond
     ((string-equal "" filename)
      (message "Giving up."))
     (t
      (let ((package (debian-bug-search-file filename)))
        (if package
            (let ((answer (y-or-n-p (format "File is in package %s; continue? "
                                            package))))
              (if answer
                  (debian-bug package)))))))))


(provide 'debian-bug)
