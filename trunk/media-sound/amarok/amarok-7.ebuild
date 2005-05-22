# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=amarok
inherit kde kde-source

IUSE="kde cdr cjk gstreamer xmms arts opengl xine libvisual noamazon mysql postgres sqlite"

DESCRIPTION="A user friendly IRC Client for KDE3.x"
HOMEPAGE="http://amarok.kde.org"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"

RDEPEND="kde? ( || ( ( kde-base/konqueror kdemultimedia-kioslaves ) 
		( kde-base/kdebase kde-base/kdemultimedia ) ) )
	arts? ( kde-base/arts
		|| ( ( kde-base/kdemultimedia-arts kde-base/akode )
		kde-base/kdemultimedia ) )
    gstreamer? ( >=media-libs/gst-plugins-0.8.1 )
    opengl? ( virtual/opengl )
    xmms? ( >=media-sound/xmms-1.2 )
    xine? ( >=media-libs/xine-lib-1_rc4 )
    libvisual? ( >=media-libs/libvisual-0.1.6 )
	mysql? ( >=dev-db/mysql-3 )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite )
	cdr? ( app-cdr/k3b )
	gstreamer? ( >=media-libs/gst-plugins-0.8.6
		mad? ( >=media-plugins/gst-plugins-mad-0.8.6 )
		oggvorbis? ( >=media-plugins/gst-plugins-ogg-0.8.6
			>=media-plugins/gst-plugins-vorbis-0.8.6 )
		flac? ( >=media-plugins/gst-plugins-flac-0.8.6 ) )
	visualization? ( media-libs/libsdl
		>=media-plugins/libvisual-plugins-0.2 )
	>=media-libs/tunepimp-0.3.0
	>=media-libs/taglib-1.3"
	
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0"
need-kde 3.2

pkg_setup() {

	if use arts && ! use xine && ! use gstreamer; then
		ewarn "aRts support is deprecated, if you have problems please consider"
		ewarn "enabling support for Xine or GStreamer"
		ewarn "(emerge amarok again with USE=\"xine\" or USE=\"gstreamer\")."
		ebeep 2
	fi

	if ! use arts && ! use xine && ! use gstreamer; then
		eerror "amaroK needs either aRts (deprecated), Xine or GStreamer to work,"
		eerror "please try again with USE=\"arts\", USE=\"xine\" or USE=\"gstreamer\"."
		die
	fi

	# check whether kdelibs was compiled with arts support
	kde_pkg_setup
}

src_compile() {

	# amarok does not respect kde coding standards, and makes a lot of
	# assuptions regarding its installation directory. For this reason,
	# it must be installed in the KDE install directory.
	PREFIX="`kde-config --prefix`"

	myconf="$(use_with arts) $(use_with xine) $(use_with gstreamer)
		$(use_with libvisual) $(use_with xmms) $(use_with opengl)
		$(use_enable mysql) $(use_enable postgres postgresql) $(use_with !sqlite included-sqlite)
		$(use_enable !noamazon amazon)"

	kde_src_compile

}

