# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE: Viewer for PostScript (.ps, .eps) and Portable Document Format (.pdf) files"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
RDEPEND="${DEPEND}
	virtual/ghostscript"
KMEXTRA="kfile-plugins/ps"
