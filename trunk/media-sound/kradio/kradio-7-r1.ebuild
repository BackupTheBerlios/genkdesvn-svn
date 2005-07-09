# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde sourceforge

DESCRIPTION="kradio is a radio tuner application for KDE"
HOMEPAGE="http://kradio.sourceforge.net/"
SRC_URI="http://download.berlios.de/genkdesvn/admin.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="lirc encode vorbis ogg"

RDEPEND="lirc? ( app-misc/lirc )
	media-libs/libsndfile
	encode? ( media-sound/lame )
	vorbis? ( media-libs/libvorbis )
	ogg? ( media-libs/libogg )"

DEPEND="${RDEPEND}
	>=kde-base/unsermake-7-r1"

need-kde 3.2

src_unpack() {
	cvs_src_unpack
	cd $S
	rm -r admin
	unpack $A
}

src_compile() {
	make -f Makefile.dist
	if ! use vorbis; then
		sed -e 's/\(ac_cv_lib_vorbisenc_vorbis_encode_init=\)yes$/\1no/' \
			-i configure
	fi
	if ! use encode; then
		sed -e 's/\(ac_cv_lib_mp3lame_lame_init=\)yes$/\1no/' \
			-i configure
	fi
	if ! use ogg; then
		sed -e 's/\(ac_cv_lib_ogg_ogg_stream_packetin=\)yes$/\1no/' \
			-i configure
	fi
	myconf="$myconf $(use_with arts)"
	kde_src_compile
}
