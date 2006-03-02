# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE sound recorder"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="encode mp3 vorbis"

DEPEND="$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)
    encode? ( mp3? ( media-sound/lame )
              vorbis? ( media-libs/libvorbis ) )"

KMCOMPILEONLY="arts"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
	kdesvn-source_pkg_setup
}

src_compile() {
	if use encode; then
		myconf="$(use_with mp3 lame) $(use_with vorbis)"
	else
		myconf="--without-lame --without-vorbis"
	fi

	kdesvn-meta_src_compile
}
								
