# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=koffice
MAXKOFFICEVER=$PV
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KOffice: Report viewer(generator)"
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

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
    libkoproperty lib/koproperty
    libkotext lib/kotext
    libkwmf lib/kwmf
    libkowmf lib/kwmf
    libkstore lib/store"

KMEXTRACTONLY="lib/"

KMEXTRA="filters/kugar"

need-kdesvn 3.4