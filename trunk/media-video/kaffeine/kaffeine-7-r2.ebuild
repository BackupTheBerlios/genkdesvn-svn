# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kaffeine
inherit kdesvn eutils kdesvn-source

DESCRIPTION="Media player for KDE using xine and gstreamer backends."
HOMEPAGE="http://kaffeine.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dvb gstreamer xinerama vorbis encode kdehiddenvisibility"

RDEPEND=">=media-libs/xine-lib-1
        gstreamer? ( =media-libs/gstreamer-0.8*
                =media-libs/gst-plugins-0.8*
                =media-plugins/gst-plugins-xvideo-0.8* )
        media-sound/cdparanoia
        encode? ( media-sound/lame )
        vorbis? ( media-libs/libvorbis )
        x11-libs/libXtst"

DEPEND="${RDEPEND}
        dvb? ( media-tv/linuxtv-dvb-headers )"

# the dependency on xorg-x11 is meant to avoid gentoo bug #59746

#PATCHES="${FILESDIR}/${PN}-headers.patch"

need-kde 3.5.4

src_compile() {
        # see bug #143168
        replace-flags -O3 -O2

        myconf="${myconf}
                $(use_with xinerama)
                $(use_with dvb)
                $(use_with gstreamer)
                $(use_with vorbis oggvorbis)
                $(use_with encode lame)"

	kdesvn_src_compile
}

src_install() {
        kdesvn_src_install

        # Remove this, as kdelibs 3.5.4 provides it
        rm -f "${D}/usr/share/mimelnk/application/x-mplayer2.desktop"
}
