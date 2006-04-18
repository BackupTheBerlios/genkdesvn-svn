# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KAppTemplate - A shell script that will create the necessary framework to develop various KDE applications"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

