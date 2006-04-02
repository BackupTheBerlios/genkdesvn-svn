# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=amarok
inherit kdesvn eutils flag-o-matic kdesvn-source

DESCRIPTION="amaroK - the audio player for KDE."
HOMEPAGE="http://amarok.kde.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aac akode arts exscalibar flac gstreamer ifp ipod kde mp3 musicbrainz mysql noamazon opengl postgres real ruby xine xmms visualization vorbis"

DEPEND="
	kde? ( ( || ( kde-base/konqueror kde-base/kdebase ) )
		( || ( kde-base/kdemultimedia-kioslaves kde-base/kdemultimedia ) ) )
	arts? ( kde-base/arts
		|| ( kde-base/kdemultimedia-arts kde-base/kode kde-base/kdemultimedia ) )
	xine? ( >=media-libs/xine-lib-1_rc4 )
	gstreamer? ( =media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-0.10* )
	musicbrainz? ( >=media-libs/tunepimp-0.3 )
	>=media-libs/taglib-1.4
	mysql? ( >=dev-db/mysql-4.0.16 )
	postgres? ( dev-db/postgresql )
	opengl? ( virtual/opengl )
	xmms? ( >=media-sound/xmms-1.2 )
	visualization? ( media-libs/libsdl
		>=media-plugins/libvisual-plugins-0.2 )
	ipod? ( media-libs/libgpod )
	akode? ( media-libs/akode )
	aac? ( media-libs/libmp4v2 )
	exscalibar? ( media-libs/exscalibar )
	real? ( media-video/realplayer )
	ifp? ( media-libs/libifp )"

RDEPEND="${DEPEND}
	ruby? ( dev-lang/ruby )"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9.0"

need-kde 3.3

pkg_setup() {
	if ! use akode && ! use xine && ! use gstreamer && ! use real; then
		eerror "amaroK needs either aRts (deprecated), Xine, GStreamer or Realaudio to work,"
		eerror "please try again with USE=\"akode\", USE=\"xine\", USE=\"gstreamer\" or USE=\"real\"."
		die
	fi

	if use ruby; then
		einfo "Ruby is used now for the lyrics tab in the context manager"
		einfo "If you dont need the lyrics tab, you dont need ruby."
		einfo
	else
		ewarn "Ruby is used for the lyrics tab. If you dont have ruby installed"
		ewarn "the lyrics tab will NOT work !"
		ewarn
	fi

	kdesvn-source_pkg_setup

	append-flags -fno-inline
}

src_compile() {
	# Extra, unsupported engines are forcefully disabled.
	local myconf="$(use_with arts) $(use_with xine)
                  $(use_with gstreamer gstreamer10)
                  $(use_enable mysql) $(use_enable postgres postgresql)
                  $(use_with opengl) $(use_with xmms)
                  $(use_with visualization libvisual)
                  $(use_enable !noamazon amazon)
                  $(use_with musicbrainz)
                  $(use_with exscalibar)
                  $(use_with ipod libgpod)
                  $(use_with akode)
                  $(use_with aac mp4v2)
                  $(use_with real helix)
                  $(use_with ifp)
                  --without-mas
                  --without-nmm"


	kdesvn_src_compile
}

#src_install() {
#	kdesvn_src_install
#
#	# move the desktop file in /usr/share
#	dodir /usr/share/applications/kde
#	mv ${D}${KDEDIR}/share/applications/kde/amarok.desktop \
#		${D}/usr/share/applications/kde/amarok.desktop || die
#}

