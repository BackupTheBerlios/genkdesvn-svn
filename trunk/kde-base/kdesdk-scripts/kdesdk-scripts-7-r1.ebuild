# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdesdk
KMMODULE="scripts"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="Kdesdk Scripts - Some useful scripts for the development of applications"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""