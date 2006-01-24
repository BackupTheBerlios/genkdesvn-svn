# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=amarok
inherit kde eutils kde-source

DESCRIPTION="amaroK - the audio player for KDE."
HOMEPAGE="http://amarok.kde.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc -sparc ~x86"
IUSE="arts cdr flac gstreamer helix ipod kde mp3 mysql noamazon opengl postgres ruby sqlite xine xmms visualization vorbis"

DEPEND="kde? ( ( || ( kde-base/konqueror kde-base/kdebase ) )
               ( || ( kde-base/kdemultimedia-kioslaves kde-base/kdemultimedia ) ) )
	 arts? ( kde-base/arts
		 || ( ( kde-base/kdemultimedia-arts kde-base/akode )
		 	kde-base/kdemultimedia ) )
	 xine? ( >=media-libs/xine-lib-1_rc4 )
	 gstreamer? ( >=media-libs/gstreamer-0.8.8
	              >=media-libs/gst-plugins-0.8.6 )
	 >=media-libs/tunepimp-0.3.0
	 >=media-libs/taglib-1.3.1
	 mysql? ( >=dev-db/mysql-4 )
	 postgres? ( dev-db/postgresql )
	 sqlite? ( dev-db/sqlite )
	 opengl? ( virtual/opengl )
	 xmms? ( >=media-sound/xmms-1.2 )
     cdr? ( >=app-cdr/k3b-0.11 )
	 ipod? ( media-libs/libgpod )
	 visualization? ( media-libs/libsdl
			  >=media-plugins/libvisual-plugins-0.2 )"

RDEPEND="${DEPEND}
	gstreamer? ( mp3? ( >=media-plugins/gst-plugins-mad-0.8.6 )
	             vorbis? ( >=media-plugins/gst-plugins-ogg-0.8.6
	                       >=media-plugins/gst-plugins-vorbis-0.8.6 )
	             flac? ( >=media-plugins/gst-plugins-flac-0.8.6 ) )
	ruby? ( dev-lang/ruby )
	helix? ( || ( media-video/helixplayer >=media-video/realplayer-10 ) )"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9.0"

need-kde 3.3

pkg_setup() {
	if use arts && ! use xine && ! use gstreamer && ! use helix; then
		ewarn "aRts support is deprecated, if you have problems please consider"
		ewarn "enabling support for Xine, GStreamer or Helix"
		ewarn "(emerge amarok again with USE=\"xine\", USE=\"gstreamer\" or USE=\"helix\")."
		ebeep 2
	fi

	if ! use arts && ! use xine && ! use gstreamer && ! use helix; then
		eerror "amaroK needs either aRts (deprecated), Xine, GStreamer or Helix to work,"
		eerror "please try again with USE=\"arts\", USE=\"xine\", USE=\"gstreamer\" or USE=\"helix\"."
		die
	fi

	if use ruby; then
		einfo Ruby is used now for the lyrics tab in the context manager
		einfo If you dont need the lyrics tab, you dont need ruby
		einfo
	fi

	kde-source_pkg_setup
}

#src_unpack() {
#	kde-source_src_unpack
#
#	epatch "${FILESDIR}/${P}-random_album_mode.patch"
#}

src_compile() {
	# amarok does not respect kde coding standards, and makes a lot of
	# assuptions regarding its installation directory. For this reason,
	# it must be installed in the KDE install directory.
	PREFIX="`kde-config --prefix`"

	local myconf="$(use_with arts) $(use_with xine) $(use_with gstreamer) $(use_with helix)
	              $(use_enable mysql) $(use_enable postgres postgresql) $(use_with !sqlite included-sqlite)
	              $(use_with opengl) $(use_with xmms)
	              $(use_with visualization libvisual)
	              $(use_enable !noamazon amazon)
				  $(use_with ipod libgpod)"

	kde_src_compile
}

src_install() {
	kde_src_install

	# move the desktop file in /usr/share
	dodir /usr/share/applications/kde
	mv ${D}${KDEDIR}/share/applications/kde/amarok.desktop \
		${D}/usr/share/applications/kde/amarok.desktop || die
}

