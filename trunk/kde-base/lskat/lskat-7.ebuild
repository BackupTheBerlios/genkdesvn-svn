# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegames
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE card game"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdegames)"
OLDDEPEND="~kde-base/libkdegames-$PV"

KMEXTRACTONLY=libkdegames
KMCOPYLIB="libkdegames libkdegames"
