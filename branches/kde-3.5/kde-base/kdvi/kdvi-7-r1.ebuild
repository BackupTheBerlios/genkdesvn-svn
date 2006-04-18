# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE DVI viewer"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="tetex"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/kviewshell)
>=media-libs/freetype-2"

RDEPEND="${DEPEND}
	tetex? (
	|| ( >=app-text/tetex-2
	app-text/ptex
	app-text/cstetex
	app-text/dvipdfm )
	)"

KMCOMPILEONLY="kviewshell/"
