# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE linux kernel configuration module for kcontrol"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
DEPEND=""

