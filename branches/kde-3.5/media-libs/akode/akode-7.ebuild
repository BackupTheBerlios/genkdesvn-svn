# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/akode/akode-2.0_rc1.ebuild,v 1.1 2005/11/29 19:41:26 greg_g Exp $

KSCM_ROOT=trunk
KSCM_MODULE=kdesupport
KSCM_SUBDIR=${PN}
inherit kde-source

#MY_P="${P/_/}"
#S="${WORKDIR}/${MY_P}"

DESCRIPTION="A simple framework to decode the most common audio formats."
HOMEPAGE="http://www.carewolf.com/akode/"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa jack flac mp3 oss speex vorbis"

DEPEND="media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	flac? ( media-libs/flac )
	mp3? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	speex? ( media-libs/speex )"

src_compile() {
	make -f Makefile.cvs || die
	local myconf="--with-libsamplerate
	              $(use_with oss) $(use_with alsa) $(use_with jack)
	              $(use_with flac) $(use_with mp3 libmad)
	              $(use_with vorbis) $(use_with speex)
	              --without-polypaudio"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}
