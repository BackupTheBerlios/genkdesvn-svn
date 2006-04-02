# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESF_SUBDIR=kradio3
inherit kdesvn-sourceforge

DESCRIPTION="kradio is a radio tuner application for KDE"
HOMEPAGE="http://kradio.sourceforge.net/"
SRC_URI="http://download.berlios.de/genkdesvn/kradio-skel.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lirc encode vorbis ogg"

RDEPEND="lirc? ( app-misc/lirc )
	media-libs/libsndfile
	encode? ( media-sound/lame )
	vorbis? ( media-libs/libvorbis )
	ogg? ( media-libs/libogg )"

need-kde 3.2

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack $A
	kdesvn-sourceforge_src_unpack
	mv ${WORKDIR}/${ESF_SUBDIR} ${S}/
}

src_compile() {
	if ! use vorbis; then
		sed -e 's/\(ac_cv_lib_vorbisenc_vorbis_encode_init=\)yes$/\1no/' \
			-i configure.in.in
	fi
	if ! use encode; then
		sed -e 's/\(ac_cv_lib_mp3lame_lame_init=\)yes$/\1no/' \
			-i configure.in.in
	fi
	if ! use ogg; then
		sed -e 's/\(ac_cv_lib_ogg_ogg_stream_packetin=\)yes$/\1no/' \
			-i configure.in.in
	fi
	myconf="$myconf $(use_with arts)"
	kdesvn_src_compile
}
