# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=playground
KSCM_MODULE=graphics
KSCM_SUBDIR=oKular
KSCM_MODULE_IS_ROOT=true
inherit flag-o-matic kde kde-source

DESCRIPTION="A powerful unified viewer application for KDE with a plugin system and backends for most popular formats"
HOMEPAGE="http://developer.kde.org/summerofcode/okular.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~ppc ~sparc"
IUSE="chm gs"

RDEPEND=""

DEPEND="${RDEPEND}
	chm? ( app-doc/chmlib )
	gs? ( x11-libs/qt )"

need-kde 3.5

src_compile() {
	local myconf="$(use_with gs libqgs)"

	kde_src_compile
}
