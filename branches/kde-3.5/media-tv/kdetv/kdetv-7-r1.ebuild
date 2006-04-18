# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=$PN
inherit kdesvn flag-o-matic kdesvn-source

DESCRIPTION="A TV application for KDE"
HOMEPAGE="http://www.kdetv.org"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="arts lirc opengl zvbi"

RDEPEND="zvbi? ( >=media-libs/zvbi-0.2.4 )
    lirc? ( app-misc/lirc )
    opengl? ( virtual/opengl )
    media-libs/alsa-lib
    || ( ( x11-libs/libICE
        x11-libs/libXxf86dga
        x11-libs/libXrandr
        x11-libs/libX11
        x11-libs/libXv
        x11-libs/libSM
        x11-libs/libXxf86vm
        x11-libs/libXext
        x11-libs/libXrender
        ) virtual/x11 )"

DEPEND="${RDEPEND}
    || ( (
        x11-proto/videoproto
        x11-proto/xproto
        x11-proto/xextproto
        ) virtual/x11 )
    virtual/os-headers"

need-kde 3.2

PATCHES="${FILESDIR}/${PN}-xinerama.patch
    ${FILESDIR}/${PN}-bindnow.patch"

src_compile() {
	local myconf="$(use_enable arts)
		$(use_enable lirc kdetv-lirc)
		$(use_with zvbi)
		$(use_with opengl gl)"

	append-flags -fno-strict-aliasing

	export BINDNOW_FLAGS="$(bindnow-flags)"
	kdesvn_src_compile all
}

src_install() {
	kdesvn_src_install

	# Move the .desktop file in FDO's suggested place
	dodir /usr/share/applications/kde
	mv ${D}/usr/share/applnk/Multimedia/kdetv.desktop \
		${D}/usr/share/applications/kde/
}

