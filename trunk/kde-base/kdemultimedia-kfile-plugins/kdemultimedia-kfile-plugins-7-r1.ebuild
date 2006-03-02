# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdemultimedia
KMMODULE=kfile-plugins
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kfile plugins from kdemultimedia package"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="vorbis theora"
DEPEND="media-libs/taglib
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )"

src_compile() {
	myconf="$myconf $(use_with vorbis)"
	kdesvn-meta_src_compile
}
