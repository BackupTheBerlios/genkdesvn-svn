# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit kofficesvn

DESCRIPTION="KOffice integrated environment for managing data"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="mysql postgres"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	sys-libs/readline
	mysql? ( dev-db/mysql )
	postgres? ( dev-libs/libpqxx )
	virtual/python"

DEPEND="${RDEPEND}"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkoproperty lib/koproperty
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkrossmain lib/kross/main
	libkrossapi lib/kross/api"

KMEXTRACTONLY="lib/"

src_compile() {
	local myconf="$(use_enable mysql) $(use_enable postgres pgsql) --enable-kexi-reports"

	kofficesvn_src_compile
}
