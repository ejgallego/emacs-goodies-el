;;; dpkg-dev-el.el --- startup file for the debian-el package

;;; Commentary:
;; 
;; This file is loaded from /etc/emacs/site-start.d/50dpkg-dev-el.el 

;;; History:
;;
;; 2003-11-03 - Peter Galbraith
;;  - Created.

;;; Code:

(defgroup dpkg-dev-el nil
  "Emacs helpers specific to Debian development."
  :group 'convenience)

(require 'dpkg-dev-el-loaddefs)

;; debian-bts-control
(defgroup debian-bts-control nil
  "Create messages for Debian BTS control interface"
  :group 'debian-bug
;;:link '(custom-manual "(dpkg-dev-el)debian-bts-control")
  :load 'debian-bts-control
  :group 'dpkg-dev-el)

;; debian-changelog-mode
(defgroup debian-changelog nil "Debian changelog maintenance"
  :group 'tools
  :prefix "debian-changelog-"
;;:link '(custom-manual "(dpkg-dev-el)debian-changelog-mode")
  :load 'debian-changelog-mode
  :group 'dpkg-dev-el)

;; debian-control-mode
(defgroup debian-control nil "Debian control file maintenance"
  :link '(url-link "http://cvs.verbum.org/debian/debian-control-mode")
  :group 'tools
;;:link '(custom-manual "(dpkg-dev-el)debian-control-mode")
  :load 'debian-control-mode
  :group 'dpkg-dev-el)

;; debian-copyright
(defgroup debian-copyright nil "Debian copyright mode"
  :group 'tools
  :prefix "debian-copyright-"
;;:link '(custom-manual "(dpkg-dev-el)debian-copyright")
  :load 'debian-copyright
  :group 'dpkg-dev-el)

;; readme-debian
(defgroup readme-debian nil "Readme Debian (mode)"
  :group 'tools
  :prefix "readme-debian-"
;;:link '(custom-manual "(dpkg-dev-el)readme-debian")
  :load 'readme-debian
  :group 'dpkg-dev-el)

(provide 'dpkg-dev-el)

;;; dpkg-dev-el.el ends here
