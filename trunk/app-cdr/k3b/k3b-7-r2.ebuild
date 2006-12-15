# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=$PN
inherit kdesvn eutils flag-o-matic kdesvn-source

DESCRIPTION="K3b, KDE CD Writing Software"
HOMEPAGE="http://www.k3b.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa css dvdr dvdread encode ffmpeg flac hal kde mp3 musepack musicbrainz
        sndfile vcd vorbis emovix"

DEPEND="kde? ( || ( kde-base/kdesu kde-base/kdebase ) )
        hal? ( || ( dev-libs/dbus-qt3-old
                                ( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.30 ) )
                sys-apps/hal )
        media-libs/libsamplerate
        media-libs/taglib
        >=media-sound/cdparanoia-3.9.8
        sndfile? ( media-libs/libsndfile )
        ffmpeg? ( media-video/ffmpeg )
        flac? ( media-libs/flac )
        mp3? ( media-libs/libmad )
        musepack? ( media-libs/libmpcdec )
        vorbis? ( media-libs/libvorbis )
        musicbrainz? ( media-libs/musicbrainz )
        encode? ( media-sound/lame )
        alsa? ( media-libs/alsa-lib )
        dvdread? ( media-libs/libdvdread )"

RDEPEND="${DEPEND}
        virtual/cdrtools
        >=app-cdr/cdrdao-1.1.7-r3
        media-sound/normalize
        dvdr? ( >=app-cdr/dvd+rw-tools-7.0 )
        css? ( media-libs/libdvdcss )
        encode? ( media-sound/sox
                          media-video/transcode )
        vcd? ( media-video/vcdimager )
        emovix? ( media-video/emovix )"

DEPEND="${DEPEND}
	dev-util/pkgconfig"

need-kde 3.4

pkg_setup() {
	if use hal && has_version '<sys-apps/dbus-0.91' && ! built_with_use sys-apps/dbus qt3; then
		eerror "You are trying to compile ${CATEGORY}/${PF} with the \"hal\" USE flag enabled,"
		eerror "but sys-apps/dbus is not built with Qt3 support."
		die "Please, rebuild sys-apps/dbus with the \"qt3\" USE flag."
	fi
	if use encode && ! built_with_use media-video/transcode dvdread; then
		eerror "You are trying to compile ${CATEGORY}/${PF} with the \"encode\""
		eerror "USE flag enabled, however media-video/transcode was not built"
		eerror "with libdvdread support. Also keep in mind that enabling"
		eerror "the dvdread USE flag will cause k3b to use libdvdread as well."
		die "Please, rebuild media-video/transcode with the \"dvdread\" USE flag."
	fi

	kdesvn-source_pkg_setup
}

src_compile() {
	local myconf="--enable-libsuffix= 		\
			--with-external-libsamplerate	\
			--without-resmgr				\
			$(use_with kde k3bsetup)		\
			$(use_with hal)					\
			$(use_with encode lame)			\
			$(use_with ffmpeg)				\
			$(use_with flac)				\
			$(use_with vorbis oggvorbis)	\
			$(use_with sndfile)				\
			$(use_with mp3 libmad)			\
			$(use_with musepack)			\
			$(use_with musicbrainz)			\
			$(use_with alsa)"

	# Build process of K3b
	kdesvn_src_compile

}

src_install() {
	kdesvn_src_install
	dodoc FAQ KNOWNBUGS PERMISSIONS

	# Move menu entry
	if use kde; then
		mv ${D}/usr/share/applnk/Settings/System/k3bsetup2.desktop ${D}/usr/share/applications/kde/
	fi
	rm -fR ${D}/usr/share/applnk/
}

pkg_postinst() {
	echo
	einfo "Make sure you have proper read/write permissions on the cdrom device(s)."
	einfo "Usually, it is sufficient to be in the cdrom group."
	echo
}

