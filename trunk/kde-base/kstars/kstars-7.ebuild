# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE Desktop Planetarium"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdeedu)"
OLDDEPEND="~kde-base/libkdeedu-$PV"

KMEXTRACTONLY="libkdeedu/extdate libkdeedu/kdeeduplot"
KMCOPYLIB="libextdate libkdeedu/extdate
	    libkdeeduplot libkdeedu/kdeeduplot"

