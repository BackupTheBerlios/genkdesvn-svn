# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
#UNSERMAKE="no"
KMNODOCS="true"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE network connection status tracking daemon"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

#KMEXTRA="doc/api"