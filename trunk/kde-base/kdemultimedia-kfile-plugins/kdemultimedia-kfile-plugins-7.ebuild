# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdemultimedia
KMMODULE=kfile-plugins
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="kfile plugins from kdemultimedia package"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="oggvorbis theora"
DEPEND="media-libs/taglib
	oggvorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )"

src_compile() {
	myconf="$myconf $(use_with oggvorbis vorbis)"
	kde-meta_src_compile
}
