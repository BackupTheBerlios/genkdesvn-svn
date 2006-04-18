# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=trunk/extragear
KSCM_MODULE=network
KSCM_SUBDIR=ktorrent
inherit kdesvn kdesvn-source

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.pwsp.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

need-kde 3.3

KMEXTRA="ktorrent/libtorrent"

src_compile(){
	local myconf="--enable-knetwork"
	kdesvn_src_compile
}

