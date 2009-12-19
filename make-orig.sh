#! /bin/sh

set -e

dh_testdir
dh_clean
rm -f `find . -name "*~"`
rm -f `find . -name "#*"`
rm -f `find . -name ".#*"`
rm -fR elisp/emacs-goodies-el/info
rm -fR elisp/debian-el/info

SOURCE=$(dpkg-parsechangelog | awk '/^Source:/ { print $2 }')
FULLVERSION=$(dpkg-parsechangelog | awk '/^Version:/ { print $2 }')
UPSTREAM_VERSION=${FULLVERSION%-*}
DEBIAN_VERSION=${FULLVERSION##*-}
THIS=$(basename $0)
THISDIR=$(basename $PWD)

(cd .. ; install -d build_${UPSTREAM_VERSION}-${DEBIAN_VERSION})
rm -fR ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION}/*
(cd ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION} ; install -d ${SOURCE}-${UPSTREAM_VERSION})
tar cf - --exclude=CVS elisp debian 00AddingFiles COPYING-GPL-v2 COPYING-GPL-v3 | ( cd ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION}/${SOURCE}-${UPSTREAM_VERSION} ; tar xf -)
(cd ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION} ; tar cf ${SOURCE}_$UPSTREAM_VERSION.orig.tar ${SOURCE}-${UPSTREAM_VERSION})
(cd ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION} ; gzip --best ${SOURCE}_$UPSTREAM_VERSION.orig.tar)
