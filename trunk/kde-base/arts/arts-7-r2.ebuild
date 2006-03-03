# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESCM_EXTERNALS="branches/KDE/3.5/kdelibs/libltdl"
inherit kdesvn flag-o-matic eutils kdesvn-source
set-kdesvndir 7

KSCM_ROOT=branches/arts/1.5
DESCRIPTION="aRts, the KDE sound (and all-around multimedia) server/output manager"
HOMEPAGE="http://multimedia.kde.org/"
SRC_URI=""

LICENSE="GPL-2 LGPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa esd artswrappersuid jack mp3 nas vorbis"

RDEPEND="$(qt-copy_min_version 3.3)
	>=dev-libs/glib-2
	alsa? ( media-libs/alsa-lib )
	vorbis? ( media-libs/libvorbis 
			  media-libs/libogg )
	esd? ( media-sound/esound )
	jack? ( >=media-sound/jack-audio-connection-kit-0.90 )
	mp3? ( media-libs/libmad )
	nas? ( media-libs/nas )
	media-libs/audiofile"

PATCHES="${FILESDIR}/arts-1.3.2-alsa-bigendian.patch
    ${FILESDIR}/arts-1.5.0-bindnow.patch"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	myconf="$(use_enable alsa) $(use_enable vorbis)
   			$(use_enable mp3 libmad) $(use_with jack)
			$(use_with esd) $(use_with nas)
			--with-audiofile --without-mas"

	#fix bug 13453
	filter-flags -foptimize-sibling-calls

	# breaks otherwise <gustavoz>
	use sparc && export CFLAGS="-O1" && export CXXFLAGS="-O1"

	export BINDNOW_FLAGS="$(bindnow-flags)"

	kdesvn_src_compile
}

src_install() {
	kdesvn_src_install
	dodoc ${S}/doc/{NEWS,README,TODO}

	# moved here from kdelibs so that when arts is installed
	# without kdelibs it's still in the path.
	# List all the multilib libdirs
	local libdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${libdirs}:${PREFIX}/${libdir}"
	done

	dodir /etc/env.d
echo "PATH=${PREFIX}/bin
ROOTPATH=${PREFIX}/sbin:${PREFIX}/bin
LDPATH=${PREFIX}/lib
CONFIG_PROTECT=\"${PREFIX}/share/config ${PREFIX}/env ${PREFIX}/shutdown\"" > ${D}/etc/env.d/30kdepaths-5.0 # number goes down with version upgrade

	# used for realtime priority, but off by default as it is a security hazard
	use artswrappersuid && chmod u+s ${D}/${PREFIX}/bin/artswrapper
}

pkg_postinst() {
	subversion_pkg_postinst
	if ! use artswrappersuid ; then
		einfo "Run chmod u+s ${PREFIX}/bin/artswrapper to let artsd use realtime priority"
		einfo "and so avoid possible skips in sound. However, on untrusted systems this"
		einfo "creates the possibility of a DoS attack that'll use 100% cpu at realtime"
		einfo "priority, and so is off by default. See bug #7883."
		einfo "Or, you can set the local artswrappersuid USE flag to make the ebuild do this."
	fi
}
