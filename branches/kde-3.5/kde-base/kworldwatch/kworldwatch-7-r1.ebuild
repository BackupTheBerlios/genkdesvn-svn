# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdetoys
KMNODOCS="true"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE program that displays the part of the Earth lit up by the Sun"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

# kworldwatch is more commonly known as kworldclock
KMEXTRA="doc/kworldclock"

