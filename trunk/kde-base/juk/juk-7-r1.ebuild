# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="Jukebox and music manager for KDE"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="flac gstreamer mp3 vorbis musicbrainz"

DEPEND="media-libs/taglib
    musicbrainz? (  media-libs/tunepimp
	            media-libs/musicbrainz )
	gstreamer? ( =media-libs/gstreamer-0.8*
				 =media-libs/gst-plugins-0.8* )
	$(deprange $PV $MAXKDEVER media-libs/akode)"

RDEPEND="${DEPEND}
    gstreamer? ( mp3? ( =media-plugins/gst-plugins-mad-0.8* )
             vorbis? ( =media-plugins/gst-plugins-ogg-0.8*
                  =media-plugins/gst-plugins-vorbis-0.8* )
             flac? ( =media-plugins/gst-plugins-flac-0.8* ) )"

#KMCOPYLIB="libakode akode/lib/"

KMEXTRACTONLY="arts/configure.in.in"

pkg_setup() {
	if ! useq arts && ! useq gstreamer; then
		eerror "${PN} needs USE=\"arts\" (and kdelibs compiled with USE=\"arts\") or USE=\"gstreamer\""
		die
	fi
	kdesvn-source_pkg_setup
}

src_compile() {
	local myconf="--with-akode $(use_with gstreamer)
                  $(use_with musicbrainz)"

	kdesvn-meta_src_compile
}

