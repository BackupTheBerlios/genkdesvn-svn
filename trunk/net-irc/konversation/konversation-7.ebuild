# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=network
KSCM_SUBDIR=konversation
inherit kde-base kde-source

need-kde 3

IUSE="nls"
DESCRIPTION="A user friendly IRC Client for KDE3.x"
HOMEPAGE="http://konversation.sourceforge.net"
LICENSE="GPL-2"
KEYWORDS="x86"

src_install() {
	kde_src_install
	use nls || rm -rf ${D}/usr/share/locale
}
