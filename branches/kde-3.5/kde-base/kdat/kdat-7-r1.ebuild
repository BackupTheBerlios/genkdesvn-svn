# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="tar-based DAT archiver for KDE"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

