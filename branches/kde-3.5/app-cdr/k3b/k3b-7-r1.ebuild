# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=$PN
inherit kde eutils flag-o-matic kde-source

DESCRIPTION="K3b, KDE CD Writing Software"
HOMEPAGE="http://www.k3b.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="css dvdr encode ffmpeg flac hal kde mp3 musepack vorbis"

DEPEND="kde? ( || ( kde-base/kdesu kde-base/kdebase ) )
	hal? ( >=sys-apps/dbus-0.23
		>=sys-apps/hal-0.4 )
	media-libs/libsndfile
	media-libs/libsamplerate
	media-libs/taglib
	media-libs/musicbrainz
	>=media-sound/cdparanoia-3.9.8
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac )
	mp3? ( media-libs/libmad )
	musepack? ( media-libs/libmpcdec )
	vorbis? ( media-libs/libvorbis )"

RDEPEND="${DEPEND}
	virtual/cdrtools
	>=app-cdr/cdrdao-1.1.7-r3
	media-sound/normalize
	dvdr? ( app-cdr/dvd+rw-tools )
	css? ( media-libs/libdvdcss )
	encode? ( media-sound/lame
		  media-sound/sox
		  media-video/transcode
		  media-video/vcdimager )"

need-kde 3.3

PATCHES="$FILESDIR/no_dvd+rw-tools_build.patch"

pkg_setup() {
	use hal && if ! built_with_use dbus qt ; then
		eerror "You are trying to compile ${CATEGORY}/${P} with the \"hal\" USE flag enabled,"
		eerror "but sys-apps/dbus is not built with Qt support."
		die
	fi

	kde-source_pkg_setup
}

src_compile() {

	local myconf="--enable-libsuffix= --with-external-libsamplerate \
			--without-resmgr --with-musicbrainz \
			$(use_with kde k3bsetup)	\
			$(use_with hal)			\
			$(use_with encode lame)		\
			$(use_with ffmpeg)		\
			$(use_with flac)		\
			$(use_with vorbis oggvorbis)	\
			$(use_with mp3 libmad)		\
			$(use_with musepack)"

	# Build process of K3B
	kde_src_compile

}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README

	# install menu entry
	dodir /usr/share/applications
	mv ${D}/usr/share/applnk/Multimedia/k3b.desktop ${D}/usr/share/applications
	if use kde; then
		mv ${D}/usr/share/applnk/Settings/System/k3bsetup2.desktop ${D}/usr/share/applications
	fi
	rm -fR ${D}/usr/share/applnk/
}

pkg_postinst() {
	echo
	einfo "Make sure you have proper read/write permissions on the cdrom device(s)."
	einfo "Usually, it is sufficient to be in the cdrom or cdrw group."
	echo
}

