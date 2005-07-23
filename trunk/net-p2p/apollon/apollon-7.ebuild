# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde sourceforge

DESCRIPTION="A KDE-based giFT GUI to search for and monitor downloads."
HOMEPAGE="http://apollon.sourceforge.net"
SRC_URI="http://download.berlios.de/genkdesvn/admin.tar.bz2"
UNSERMAKE=no

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=net-p2p/gift-0.11.4"
need-kde 3

src_unpack() {
	cvs_src_unpack
	cd $S
	rm -r admin
	unpack $A
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog HowToGetPlugins.README README TODO || die
}

