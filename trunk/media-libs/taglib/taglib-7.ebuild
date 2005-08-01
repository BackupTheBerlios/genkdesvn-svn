# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit flag-o-matic

KSCM_ROOT="trunk/"
KSCM_MODULE="kdesupport"
ESCM_SHALLOWITEMS="$KSCM_ROOT$KSCM_MODULE"
ESCM_DEEPITEMS="branches/KDE/3.5/kde-common/admin $KSCM_ROOT$KSCM_MODULE/$PN"
KSCM_SUBDIR="$PN"
#KSCM_SUBDIR_NODOC=1
inherit kde-source

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/index.html"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=sys-devel/autoconf-2.58"
RDEPEND=""

src_unpack() {

	subversion_src_unpack
	mv $WORKDIR/branches/KDE/3.5/kde-common/admin $S/

}

src_compile() {

	cd ${S}
	make -f Makefile.cvs
	rm -rf autom4te.cache
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7
	aclocal && autoconf && automake || die "autotools failed"
	replace-flags -O3 -O2
	econf `use_enable debug` || die
	emake || die

}

src_install() {

	make install DESTDIR=${D} destdir=${D} || die

}

