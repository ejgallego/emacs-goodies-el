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

#tar cvzfC ../${SOURCE}_$UPSTREAM_VERSION.orig.tar.gz ../ \
#    --exclude=$THISDIR/debian --exclude=$SOURCE/$THIS --exclude=CVS \
#    $THISDIR
rm -fR ../${SOURCE}-${UPSTREAM_VERSION}
mkdir ../${SOURCE}-${UPSTREAM_VERSION}
tar cf - --exclude=CVS --exclude=elisp/vm-bonus-el elisp | ( cd ../${SOURCE}-${UPSTREAM_VERSION} ; tar xf -)
(cd .. ; tar zcf ${SOURCE}_$UPSTREAM_VERSION.orig.tar.gz ${SOURCE}-${UPSTREAM_VERSION})
rm -fR ../${SOURCE}-${UPSTREAM_VERSION}
mkdir ../${SOURCE}-${UPSTREAM_VERSION}
tar cf - --exclude=CVS debian make-orig.sh | ( cd ../${SOURCE}-${UPSTREAM_VERSION} ; tar xf -)
(cd .. ; tar zcf debian-${UPSTREAM_VERSION}-${DEBIAN_VERSION}.tar.gz ${SOURCE}-${UPSTREAM_VERSION})
rm -fR ../${SOURCE}-${UPSTREAM_VERSION}

(cd .. ; mkdir build_${UPSTREAM_VERSION}-${DEBIAN_VERSION})
(cd .. ; mv ${SOURCE}_$UPSTREAM_VERSION.orig.tar.gz debian-${UPSTREAM_VERSION}-${DEBIAN_VERSION}.tar.gz build_${UPSTREAM_VERSION}-${DEBIAN_VERSION})
(cd ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION} ; tar zxf ${SOURCE}_$UPSTREAM_VERSION.orig.tar.gz)
(cd ../build_${UPSTREAM_VERSION}-${DEBIAN_VERSION} ; tar zxf debian-${UPSTREAM_VERSION}-${DEBIAN_VERSION}.tar.gz)
