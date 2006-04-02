# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-sourceforge

DESCRIPTION="A KDE-based giFT GUI to search for and monitor downloads."
HOMEPAGE="http://apollon.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=net-p2p/gift-0.11.4"
need-kde 3

src_unpack() {
	kde-sourceforge_src_unpack
	cp -f ${S}/admin.old/acinclude.m4.in ${S}/admin
}

src_install() {
	keepobj_execute einstall || die
	dodoc AUTHORS ChangeLog HowToGetPlugins.README README TODO || die
}
