# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kat/kat-0.5.2.ebuild,v 1.2 2005/05/17 11:00:09 arj Exp $

inherit kde sourceforge

DESCRIPTION="The open source answer to WhereIsIt and Google Desktop Search"
HOMEPAGE="http://kat.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ia64"
IUSE="qt"

DEPEND=">=app-text/poppler-0.3.1
	>=dev-db/sqlite-3.2.1"

need-kde 3.3

pkg_setup() {
	# check if poppler has been built with qt enabled
	if has_version poppler && ! built_with_use poppler qt ; then
		eerror "Re-emerge poppler with qt use-flag enabled!"
		die "You need poppler built with qt flag to compile ${PN}."
	fi
}

src_compile(){
    PREFIX="`kde-config --prefix`"
    kde_src_compile
}
