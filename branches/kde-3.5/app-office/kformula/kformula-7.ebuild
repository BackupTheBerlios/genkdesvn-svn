# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# location of koffice in SVN
KSCM_ROOT="branches/koffice/1.6/"
MAXKOFFICEVER=$PV
KMNAME=koffice
inherit kde-meta eutils kde-source

DESCRIPTION="KOffice Formula Editor"
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc amd64"

IUSE=""
SLOT="$PV"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store"

KMEXTRACTONLY="lib/"

KMEXTRA="filters/kformula"

need-kde 3.3


