# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE Time tracker tool"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/kdepim-kresources)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)"

KMCOPYLIB="
	libkcal libkcal
	libkdepim libkdepim
	libkcal_resourceremote kresources/remote"
	
KMEXTRACTONLY="
	libkcal/
	libkdepim/
	kresources/remote"
