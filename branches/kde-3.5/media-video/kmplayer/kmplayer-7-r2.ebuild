# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kmplayer
inherit kdesvn kdesvn-source

DESCRIPTION="KMPlayer is a Video player plugin for Konqueror and basic MPlayer/Xine/ffmpeg/ffserver/VDR frontend for KDE."
HOMEPAGE="http://kmplayer.kde.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="gstreamer mplayer xine"

DEPEND="xine? ( >=media-libs/xine-lib-1.1.1 )
	gstreamer? ( || ( =media-libs/gst-plugins-base-0.10* =media-libs/gst-plugins-0.8* ) )"

RDEPEND="mplayer? ( >=media-video/mplayer-1.0 )
	xine? ( >=media-libs/xine-lib-1.1.1 )
	gstreamer? ( || ( =media-libs/gst-plugins-base-0.10*	=media-libs/gst-plugins-0.8* ) )"

need-kde 3

pkg_setup() {
	if ! use mplayer && ! use xine ; then
		echo
		ewarn "Neither mplayer nor xine use flag is set. Either one is needed."
		ewarn "You can install mplayer later, though.\n"
	fi
}

src_compile(){
	local myconf="$(use_with gstreamer) $(use_with xine)"
	kdesvn_src_compile
}
