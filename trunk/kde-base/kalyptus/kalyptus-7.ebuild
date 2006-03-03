# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebindings
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE bindings generator for C, ObjC and Java"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="dev-lang/perl"
PATCHES="$FILESDIR/no-gtk-glib-check.diff"

# Weird build system, weirder errors.
# You're welcome to fix this in a better way --danarmak
src_compile () {
	export S=$S/kalyptus
	kde-meta_src_compile
}

src_install() {
	cd $S/kalyptus
	make install DESTDIR=$D
}
