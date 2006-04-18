# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=utils
KSCM_SUBDIR=$PN
inherit kdesvn kdesvn-source

DESCRIPTION="A KDE Recipe Tool"
HOMEPAGE="http://krecipes.sourceforge.net"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="mysql postgres sqlite"

DEPEND="sqlite? ( dev-db/sqlite )"
RDEPEND="${DEPEND}
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )"

need-kde 3

pkg_setup() {
	if ! use sqlite && ! use mysql && ! use postgres; then
		eerror krecipes needs either SQLite, MySQL or PostgreSQL to work,
		eerror please try again with USE=\"sqlite\", USE=\"mysql\" or USE=\"postgres\".
		die
	fi
	kdesvn-source_pkg_setup
}

src_compile() {
	myconf="$(use_with sqlite) $(use_with mysql) $(use_with postgres postgresql)"

	kdesvn_src_compile
}
