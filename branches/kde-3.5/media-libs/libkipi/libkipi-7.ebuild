# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkipi/libkipi-0.1.1.ebuild,v 1.3 2005/04/07 15:42:46 blubb Exp $

KSCM_ROOT=extragear
KSCM_MODULE=libs
KSCM_SUBDIR=$PN
inherit kde kde-source

DESCRIPTION="A library for image plugins accross KDE applications."
HOMEPAGE="http://digikam.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc amd64 ~sparc"
IUSE=""

DEPEND="dev-util/pkgconfig"
need-kde 3.1

PATCHES="${FILESDIR}/${P}-libkipi.patch"
