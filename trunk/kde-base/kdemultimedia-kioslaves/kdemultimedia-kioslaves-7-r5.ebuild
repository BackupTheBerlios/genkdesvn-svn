# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
KMMODULE=kioslave
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kioslaves from kdemultimedia package"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="encode flac mp3 vorbis"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcddb)
        media-sound/cdparanoia
        media-libs/taglib
        encode? ( vorbis? ( media-libs/libvorbis )
                  flac? ( >=media-libs/flac-1.1.2 ) )"
RDEPEND="${DEPEND}
        encode? ( mp3? ( media-sound/lame ) )"

KMCOPYLIB="libkcddb libkcddb"
KMEXTRACTONLY="akode/configure.in.in"
KMCOMPILEONLY="
        kscd
        kscd/libwm
        libkcddb"

src_compile() {
	myconf="--with-cdparanoia --enable-cdparanoia"
	if use encode; then
		myconf="$myconf $(use_with vorbis) $(use_with flac)"
	else
		myconf="$myconf --without-vorbis --without-flac"
	fi

	kdesvn-meta_src_compile
}
