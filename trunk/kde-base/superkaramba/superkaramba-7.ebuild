# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="A tool to create interactive applets for the KDE desktop."
HOMEPAGE="http://netdragon.sourceforge.net/"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc xmms"

DEPEND="dev-lang/python
	xmms? ( media-sound/xmms )
	!x11-misc/superkaramba"

src_compile() {
	myconf="$myconf $(use_with xmms)"
	kde-meta_src_compile
}
