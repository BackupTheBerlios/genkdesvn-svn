# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

UNSERMAKE=no # libkcddb's Makefile is broken for unsermake
KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE library for CDDB"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
