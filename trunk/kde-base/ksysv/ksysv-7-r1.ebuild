# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE: Editor for Sys-V like init configurations"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=""

