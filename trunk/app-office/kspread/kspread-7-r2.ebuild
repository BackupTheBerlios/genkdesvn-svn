# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kofficesvn

DESCRIPTION="KOffice Spreadsheet Application"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	$(deprange $PV $MAXKOFFICEVER app-office/kchart)"

DEPEND="${RDEPEND}"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkochart interfaces
	libkrossmain lib/kross/main
	libkrossapi lib/kross/api"

KMEXTRACTONLY="lib/
	interfaces/"

KMCOMPILEONLY="filters/liboofilter"

KMEXTRA="filters/kspread"

