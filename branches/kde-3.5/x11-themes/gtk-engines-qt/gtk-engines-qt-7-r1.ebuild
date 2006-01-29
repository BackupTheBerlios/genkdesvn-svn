# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EFDO_MODULE="gtk-qt"
EFDO_SUBDIR="gtk-qt-engine"
inherit eutils kde-functions freedesktop kde-make

DESCRIPTION="GTK+2 Qt Theme Engine"
HOMEPAGE="http://www.freedesktop.org/Software/gtk-qt"
SRC_URI="http://download.berlios.de/genkdesvn/admin.tar.bz2"
LICENSE="GPL-2"

IUSE="arts debug"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="${DEPEND}
	>=x11-libs/gtk+-2.2
	arts? ( kde-base/arts )"

need-kde 3
# Set slot after the need-kde. Fixes bug #78455.
SLOT="2"

src_unpack() {
	cvs_src_unpack
	cd $S
	rm -r admin
	unpack $A
}

src_compile() {
	make -f ${S}/admin/Makefile.common

	local myconf="$(use_with arts) $(use_enable debug)"
	econf ${myconf} || die
	make || die
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS
}
