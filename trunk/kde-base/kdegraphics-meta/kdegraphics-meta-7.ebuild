# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="gphoto2 scanner povray"

RDEPEND="gphoto2? ( $(deprange $PV $MAXKDEVER kde-base/kamera) )
	$(deprange $PV $MAXKDEVER kde-base/kcoloredit)
	$(deprange $PV $MAXKDEVER kde-base/kdegraphics-kfile-plugins)
	$(deprange $PV $MAXKDEVER kde-base/kdvi)
	$(deprange $PV $MAXKDEVER kde-base/kfax)
	$(deprange $PV $MAXKDEVER kde-base/kgamma)
	$(deprange $PV $MAXKDEVER kde-base/kghostview)
	$(deprange $PV $MAXKDEVER kde-base/kiconedit)
	$(deprange $PV $MAXKDEVER kde-base/kmrml)
	$(deprange $PV $MAXKDEVER kde-base/kolourpaint)
	scanner? ( $(deprange $PV $MAXKDEVER kde-base/kooka)
	    $(deprange $PV $MAXKDEVER kde-base/libkscan) )
	$(deprange $PV $MAXKDEVER kde-base/kpdf)
	povray? ( $(deprange $PV $MAXKDEVER kde-base/kpovmodeler) )
	$(deprange $PV $MAXKDEVER kde-base/kruler)
	$(deprange $PV $MAXKDEVER kde-base/ksnapshot)
	$(deprange $PV $MAXKDEVER kde-base/ksvg)
	$(deprange $PV $MAXKDEVER kde-base/kuickshow)
	$(deprange $PV $MAXKDEVER kde-base/kview)
	$(deprange $PV $MAXKDEVER kde-base/kviewshell)"
