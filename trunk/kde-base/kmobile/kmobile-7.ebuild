# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
KMEXTRA="doc/api"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE mobile devices manager"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE=""
DEPEND="app-mobilephone/gnokii"
