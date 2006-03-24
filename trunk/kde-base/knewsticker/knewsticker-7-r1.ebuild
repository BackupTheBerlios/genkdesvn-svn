# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

UNSERMAKE=no
KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kicker plugin: rss news ticker"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/librss)"

KMCOPYLIB="librss librss"
KMEXTRACTONLY="librss"
