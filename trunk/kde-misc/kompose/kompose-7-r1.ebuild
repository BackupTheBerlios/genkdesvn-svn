# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kdesvn berlios

DESCRIPTION="A KDE fullscreen task manager."
HOMEPAGE="http://kompose.berlios.de"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="media-libs/imlib2"
RDEPEND="media-libs/imlib2"
need-kde 3.2

function pkg_setup() {
	# gentoo bug 94881
	if ! built_with_use media-libs/imlib2 X; then
		eerror "This package requires imlib2 to be built with X11 support."
		eerror "Please run USE=X emerge media-libs/imlib2, then try emerging kompose again."
		die "imlib2 must be built with USE=X"
	 fi
}

