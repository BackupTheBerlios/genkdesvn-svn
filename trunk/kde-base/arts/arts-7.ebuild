# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit kde flag-o-matic eutils kde-source
set-kdedir 7

DESCRIPTION="aRts, the KDE sound (and all-around multimedia) server/output manager"
HOMEPAGE="http://multimedia.kde.org/"
SRC_URI=""

LICENSE="GPL-2 LGPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~sparc ~ppc ~ppc64"
IUSE="alsa oggvorbis esd artswrappersuid jack mad hardened"

DEPEND="alsa? ( media-libs/alsa-lib virtual/alsa )
	oggvorbis? ( media-libs/libvorbis media-libs/libogg )
	esd? ( media-sound/esound )
	jack? ( media-sound/jack-audio-connection-kit )
	mad? ( media-libs/libmad media-libs/libid3tag )
	media-libs/audiofile
	>=dev-libs/glib-2
	>=x11-libs/qt-3.3"

KMCOMPILEONLY="KDE/kdelibs/libltdl"

src_compile() {

	# Allow for choice between 3 and 7, depending on what's installed
	has_version '>=x11-libs/qt-7' && export QTDIR="/usr/qt/devel" || export QTDIR="/usr/qt/3"

	if (is-flag -fstack-protector || is-flag -fstack-protector-all || use hardened); then
		epatch ${FILESDIR}/arts-1.4-mcopidl.patch
	fi

	#fix bug 13453
	filter-flags -foptimize-sibling-calls

	#fix bug 41980
	use sparc && filter-flags -fomit-frame-pointer

	myconf="$myconf $(use_enable alsa) $(use_enable oggvorbis vorbis) $(use_enable mad libmad) $(use_enable jack)"

	kde_src_compile
}

src_install() {
	kde_src_install
	dodoc ${S}/doc/{NEWS,README,TODO}

	# moved here from kdelibs so that when arts is installed
	# without kdelibs it's still in the path.
	dodir /etc/env.d
echo "PATH=${PREFIX}/bin
ROOTPATH=${PREFIX}/sbin:${PREFIX}/bin
LDPATH=${PREFIX}/lib
CONFIG_PROTECT=\"${PREFIX}/share/config ${PREFIX}/env ${PREFIX}/shutdown\"" > ${D}/etc/env.d/30kdepaths-5.0 # number goes down with version upgrade

	# used for realtime priority, but off by default as it is a security hazard
	use artswrappersuid && chmod u+s ${D}/${PREFIX}/bin/artswrapper
}

pkg_postinst() {
	if ! use artswrappersuid ; then
		einfo "Run chmod u+s ${PREFIX}/bin/artswrapper to let artsd use realtime priority"
		einfo "and so avoid possible skips in sound. However, on untrusted systems this"
		einfo "creates the possibility of a DoS attack that'll use 100% cpu at realtime"
		einfo "priority, and so is off by default. See bug #7883."
		einfo "Or, you can set the local artswrappersuid USE flag to make the ebuild do this."
	fi
}
