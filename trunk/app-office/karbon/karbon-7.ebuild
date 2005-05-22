# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKOFFICEVER=$PV
KMNAME=koffice
inherit kde-meta eutils kde-source

DESCRIPTION="KOffice: Yet another vector graphics application."
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc"

IUSE=""
SLOT="$PV"

DEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	>=media-libs/libart_lgpl-2.3.9
	dev-util/pkgconfig"

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

KMCOMPILEONLY="filters/liboofilter"

KMEXTRA="filters/karbon"

need-kde 3.1

