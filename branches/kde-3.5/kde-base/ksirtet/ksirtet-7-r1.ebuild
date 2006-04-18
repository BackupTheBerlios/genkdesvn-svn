# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegames
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KSirtet is an adaptation of the well-known Tetris game"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdegames)"

KMEXTRACTONLY=libkdegames
KMCOMPILEONLY=libksirtet
KMCOPYLIB="libkdegames libkdegames"
