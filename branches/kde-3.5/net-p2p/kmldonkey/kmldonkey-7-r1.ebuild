# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=network
KSCM_SUBDIR=kmldonkey
inherit kdesvn eutils kdesvn-source

DESCRIPTION="Provides integration for the MLDonkey P2P software and KDE 3"
HOMEPAGE="http://www.kmldonkey.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="|| ( kde-base/kcontrol kde-base/kdebase )"

need-kde 3

PATCHES="${FILESDIR}/${P}-sandbox.patch"

pkg_postinst() {
	echo
	einfo "To configure Kmldonkey use your KDE ControlCenter"
	echo
}
