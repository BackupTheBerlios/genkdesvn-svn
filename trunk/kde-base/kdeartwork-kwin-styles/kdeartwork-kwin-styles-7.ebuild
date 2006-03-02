# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMMODULE=kwin-styles
KMNAME=kdeartwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="Window styles for kde"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
OLDDEPEND="~kde-base/kwin-$PV"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/kwin)"

