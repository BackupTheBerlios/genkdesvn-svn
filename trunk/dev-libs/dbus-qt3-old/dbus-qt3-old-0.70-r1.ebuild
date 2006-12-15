# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dbus-qt3-old/dbus-qt3-old-0.70.ebuild,v 1.2 2006/10/30 19:35:30 steev Exp $

inherit qt3

DESCRIPTION="D-BUS Qt3 bindings compatible with old application API and new dbus"
HOMEPAGE="http://freedesktop.org/wiki/Software_2fdbus"
SRC_URI="http://www.kolumbus.fi/juuso.alasuutari/${P/-old}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-apps/dbus-0.91"
DEPEND=">=sys-apps/dbus-0.91
	=x11-libs/qt-3*"
S=${WORKDIR}/${P/-old}

src_compile() {

	econf \
		--enable-qt3 \
		--with-qt3-moc=/usr/qt/devel/bin/moc \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
