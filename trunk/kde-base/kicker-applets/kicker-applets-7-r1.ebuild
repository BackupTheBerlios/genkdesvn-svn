# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kicker-applets doc/kicker-applets"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="kicker applets"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="xmms"
DEPEND="xmms? ( media-sound/xmms )
$(deprange-dual $PV $MAXKDEVER kde-base/kicker)"

myconf="$(use_with xmms)"

