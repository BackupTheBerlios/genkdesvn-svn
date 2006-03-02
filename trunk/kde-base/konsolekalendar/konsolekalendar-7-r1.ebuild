# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="A command line interface to KDE calendars"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)"

KMCOPYLIB="libkcal libkcal
	libkdepim libkdepim"
KMEXTRACTONLY="libkdepim/"
KMCOMPILEONLY="libkcal"

src_compile() {
	export DO_NOT_COMPILE="libkcal"
	kdesvn-meta_src_compile myconf configure
	cd $S/libkcal; make htmlexportsettings.h
	kdesvn-meta_src_compile make
}


