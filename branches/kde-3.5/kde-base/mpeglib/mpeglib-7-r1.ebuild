# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE mpeg library"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
DEPEND="media-sound/cdparanoia"

myconf="--with-cdparanoia --enable-cdparanoia"
