# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EFDO_MODULE="gtk-qt"
EFDO_SUBDIR="$PN"
inherit gtk-engines2 eutils kde-functions freedesktop

DESCRIPTION="GTK+2 Qt Theme Engine"
HOMEPAGE="http://www.freedesktop.org/Software/gtk-qt"
LICENSE="GPL-2"

IUSE="arts debug"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="${DEPEND}
	>=x11-libs/gtk+-2.2.0
	arts? ( kde-base/arts )"

need-kde 3
# Set slot after the need-kde. Fixes bug #78455.
SLOT="2"

src_compile() {
	make -f ${S}/admin/Makefile.common

	local myconf="$(use_with arts) $(use_enable debug)"
	econf ${myconf} || die
	emake || die
}
