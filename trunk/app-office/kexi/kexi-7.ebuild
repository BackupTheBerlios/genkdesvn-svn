# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKOFFICEVER=$PV
KMNAME=koffice
inherit kde-meta eutils kde-source

DESCRIPTION="KOffice integrated environment for managing data"
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc"

IUSE="postgres mysql"
SLOT="$PV"

DEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	dev-util/pkgconfig
	dev-db/sqlite
	postgres? ( dev-libs/libpqxx )
	mysql? ( dev-db/mysql )"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkoscript lib/koscript
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store"

KMEXTRACTONLY="lib/"

src_compile() {
	myconf="${myconf} $(use_enable postgres pgsql) $(use_enable mysql)"
	kde_src_compile
}

# Kexi requires Qextmdi
need-kde 3.2

