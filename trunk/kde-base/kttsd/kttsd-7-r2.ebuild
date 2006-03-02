# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdeaccessibility
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE text-to-speech subsystem"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa gstreamer"
DEPEND="media-libs/akode
    alsa? ( media-libs/alsa-lib )
    gstreamer? ( =media-libs/gstreamer-0.8*
                 =media-libs/gst-plugins-0.8* )
    $(deprange-dual $PV $MAXKDEVER kde-base/kcontrol)"

RDEPEND="${DEPEND}
    || ( app-accessibility/festival
         app-accessibility/epos
         app-accessibility/flite
         app-accessibility/freetts )"

DEPEND="${DEPEND}
    dev-util/pkgconfig"

src_compile() {
	local myconf="--with-akode
                  $(use_with alsa) $(use_with gstreamer)"

	kdesvn-meta_src_compile
}

