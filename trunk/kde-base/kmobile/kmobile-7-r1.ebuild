# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE mobile devices manager"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="app-mobilephone/gnokii
$(deprange $PV $MAXKDEVER kde-base/libkcal)"

KMCOPYLIB="libkcal libkcal"

PATCHES="${FILESDIR}/${PN}-recurrence.patch"
