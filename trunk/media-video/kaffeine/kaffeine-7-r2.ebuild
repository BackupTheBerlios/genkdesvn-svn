# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kaffeine
inherit kdesvn eutils kdesvn-source

DESCRIPTION="Media player for KDE"
HOMEPAGE="http://kaffeine.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="dvb encode gstreamer vorbis xinerama"

RDEPEND="|| ( x11-base/xorg-server
          >=x11-base/xorg-x11-6.8.0-r4 )
    >=media-libs/xine-lib-1
    gstreamer? ( =media-libs/gstreamer-0.8*
        =media-libs/gst-plugins-0.8* )
    media-sound/cdparanoia
    encode? ( media-sound/lame )
    vorbis? ( media-libs/libvorbis )
    || ( (
            x11-libs/libXtst
            xinerama? ( x11-libs/libXinerama )
        ) virtual/x11 )"

DEPEND="${RDEPEND}
    || ( (
            x11-proto/xproto
            x11-proto/xextproto
            xinerama? ( x11-proto/xineramaproto )
        ) virtual/x11 )
    dvb? ( >=sys-kernel/linux-headers-2.6 )
    dev-util/pkgconfig"

# the dependency on xorg-x11 is meant to avoid gentoo bug #59746

#PATCHES="${FILESDIR}/${PN}-xinerama.patch
#    ${FILESDIR}/${PN}-respectflags.patch
#    ${FILESDIR}/${PN}-closedev.patch"

PATCHES="${FILESDIR}/${PN}-headers.patch"

need-kde 3.2

src_compile() {
	rm -f ${S}/configure

	myconf="${myconf}
        $(use_with xinerama)
        $(use_with dvb)
        $(use_with gstreamer)
        $(use_with vorbis oggvorbis)
        $(use_with encode lame)"

	kdesvn_src_compile
}
