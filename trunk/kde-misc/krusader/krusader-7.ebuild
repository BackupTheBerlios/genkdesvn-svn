# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krusader/krusader-1.60.0.ebuild,v 1.5 2005/06/14 01:31:20 weeve Exp $

ESF_SUBDIR="krusader_kde3"

inherit kde sourceforge

DESCRIPTION="An advanced twin-panel (commander-style) file-manager for KDE with many extras."
HOMEPAGE="http://krusader.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ia64"
IUSE="javascript kde"
# kde: adds support for Konqueror's right-click actions

DEPEND="kde? ( || ( ( kde-base/libkonq kde-base/kdebase-kioslaves )
		>=kde-base/kdebase-7 ) )
		javascript? ( kde-base/kjsembed )"

need-kde 3.3

src_compile() {
	kde_src_compile
}

pkg_postinst() {
	echo
	einfo "Krusader can use various external applications, including:"
	einfo "- KMail   (kde-base/kdepim)"
	einfo "- Kompare (kde-base/kdesdk)"
	einfo "- KDiff3  (app-misc/kdiff3)"
	einfo "- XXdiff  (dev-util/xxdiff)"
	einfo "- KRename (app-misc/krename)"
	einfo "- Eject   (virtual/eject)"
	einfo ""
	einfo "It supports also quite a few archive formats, including:"
	einfo "- app-arch/arj"
	einfo "- app-arch/unarj"
	einfo "- app-arch/rar"
	einfo "- app-arch/zip"
	einfo "- app-arch/unzip"
	einfo "- app-arch/unace"
	echo
}
