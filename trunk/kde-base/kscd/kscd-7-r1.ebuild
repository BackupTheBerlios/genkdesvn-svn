# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE CD player"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkcddb)"

KMCOPYLIB="libkcddb libkcddb"
KMEXTRACTONLY="
	mpeglib_artsplug/configure.in.in"
KMTARGETSONLY=('libkcddb .ui .kcfgc')
