# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMMODULE=kscreensaver
KMNAME=kdeartwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="Extra screensavers for kde"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="opengl xscreensaver"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kscreensaver)
    media-libs/libart_lgpl
	opengl? ( virtual/opengl )
	xscreensaver? ( x11-misc/xscreensaver )"


src_compile() {
	local myconf="$myconf --with-dpms --with-libart
	                  $(use_with opengl gl) $(use_with xscreensaver)"
	kdesvn-meta_src_compile
}
