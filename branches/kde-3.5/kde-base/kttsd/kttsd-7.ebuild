# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeaccessibility
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE text-to-speech subsystem"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="gstreamer"
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/kcontrol)
	$(deprange $PV $MAXKDEVER kde-base/arts)
	gstreamer? ( >=media-libs/gstreamer-0.8.7 )
	>=dev-util/pkgconfig-0.9.0"

RDEPEND="
|| ( app-accessibility/festival
app-accessibility/epos
app-accessibility/flite
app-accessibility/freetts
)"

myconf="$(use_enable gstreamer kttsd-gstreamer)"

