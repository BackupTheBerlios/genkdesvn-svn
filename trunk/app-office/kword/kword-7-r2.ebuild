# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=koffice
MAXKOFFICEVER=$PV
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KOffice Word Processor"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	$(deprange $PV $MAXKOFFICEVER app-office/kspread)
	>=app-text/wv2-0.1.8
	>=media-gfx/imagemagick-5.5.2
	>=app-text/libwpd-0.8.2"

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
    libkstore lib/store
    libkspreadcommon kspread"

KMEXTRACTONLY="
    lib/
    kspread/"

KMCOMPILEONLY="filters/liboofilter"

KMEXTRA="filters/kword"

need-kdesvn 3.4
