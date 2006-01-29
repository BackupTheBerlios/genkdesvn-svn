# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdeaccessibility
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE text-to-speech subsystem"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa gstreamer"
DEPEND="alsa? ( media-sound/alsaplayer )
	arts? ( $(deprange $PV $MAXKDEVER kde-base/arts) )
	$(deprange-dual $PV $MAXKDEVER kde-base/kcontrol)
	gstreamer? ( >=media-libs/gstreamer-0.8.7 )
	>=dev-util/pkgconfig-0.9.0"

RDEPEND="${DEPEND}
	alsa? ( || ( app-accessibility/festival
		     app-accessibility/epos
		     app-accessibility/flite ) )

	arts? ( || ( app-accessibility/festival
		     app-accessibility/epos
		     app-accessibility/flite
		     app-accessibility/freetts ) )

	gstreamer? ( || ( app-accessibility/festival
		     app-accessibility/epos
		     app-accessibility/flite ) )"

pkg_setup() {

	if ! use arts && ! use gstreamer && ! use alsa
	then
		
		eerror 'kttsd needs either alsaplayer, aRts or Gstreamer to work,'
		eerror 'please try again with USE="alsa", USE="arts" or USE="gstreamer".'
		die

	fi

	kde-source_pkg_setup

	myconf="${myconf} $(use_with alsa) $(use_with gstreamer)"

}
