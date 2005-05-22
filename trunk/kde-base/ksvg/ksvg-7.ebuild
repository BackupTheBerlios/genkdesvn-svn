# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="SVG viewer library and embeddable kpart"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

DEPEND="media-libs/libart_lgpl
	media-libs/lcms
	dev-libs/fribidi"
