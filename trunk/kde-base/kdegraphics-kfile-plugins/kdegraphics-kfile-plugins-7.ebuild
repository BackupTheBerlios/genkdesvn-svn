# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegraphics
KMMODULE=kfile-plugins
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="kfile plugins from kdegraphics"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="tiff openexr"
DEPEND="tiff? ( media-libs/tiff )
	openexr? ( media-libs/openexr )"
RDEPEND="${DEPEND}
	app-text/xpdf" # needed for "pdfinfo"

# ps installed with kghostview, pdf installed with kpdf
KMEXTRACTONLY="kfile-plugins/ps kfile-plugins/pdf"
