# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kmplayer
inherit kdesvn kdesvn-source

DESCRIPTION="MPlayer frontend for KDE"
HOMEPAGE="http://www.xs4all.nl/~jjvrieze/kmplayer.html"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="gstreamer mplayer xine"

DEPEND="xine? ( >=media-libs/xine-lib-1_beta12 )
    gstreamer? ( =media-libs/gst-plugins-0.8* )"
RDEPEND="mplayer? ( >=media-video/mplayer-0.90 )
    xine? ( >=media-libs/xine-lib-1_beta12 )
    gstreamer? ( =media-libs/gst-plugins-0.8* )"

need-kde 3.1

pkg_setup() {
	if ! use mplayer && ! use xine ; then
		echo
		ewarn "Neither mplayer nor xine use flag is set. Either one is needed."
		ewarn "You can install mplayer later, though.\n"
	fi
}

src_compile() {
	local myconf="$(use_with gstreamer) $(use_with xine)"
	kdesvn_src_compile
}

src_install() {
	kdesvn_src_install
	mv ${D}/usr/share/mimelnk/application/x-mplayer2.desktop ${D}/usr/share/mimelnk/application/x-mplayer3.desktop
}

