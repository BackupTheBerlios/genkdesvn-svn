# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kde - merge this to pull in all kde packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~ppc ~sparc ~ppc64"
IUSE="accessibility"

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/kdeaddons-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeadmin-meta)
$(deprange $PV $MAXKDEVER kde-base/kdebase-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeedu-meta)
$(deprange $PV $MAXKDEVER kde-base/kdegames-meta)
$(deprange $PV $MAXKDEVER kde-base/kdegraphics-meta)
$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-meta)
$(deprange $PV $MAXKDEVER kde-base/kdenetwork-meta)
$(deprange $PV $MAXKDEVER kde-base/kdepim-meta)
$(deprange $PV $MAXKDEVER kde-base/kdesdk-meta)
$(deprange $PV $MAXKDEVER kde-base/kdetoys-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeutils-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeartwork-meta)
$(deprange $PV $MAXKDEVER kde-base/kdewebdev-meta)
accessibility? ( $(deprange $PV $MAXKDEVER kde-base/kdeaccessibility-meta) )"
