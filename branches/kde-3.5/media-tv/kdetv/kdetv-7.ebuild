# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=$PN
inherit kde kde-source

DESCRIPTION="A TV application for KDE"
HOMEPAGE="http://www.kdetv.org"
LICENSE="GPL-2"

KEYWORDS="~x86"
IUSE="arts lirc"

DEPEND=">=media-libs/zvbi-0.2.4"
need-kde 3.2

src_compile() {

	local myconf="$(use_enable arts) $(use_enable lirc kdetv-lirc)"
	kde_src_compile all

}

