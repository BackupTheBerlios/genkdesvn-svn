# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
KMMODULE=wifi
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE wifi (wireless network) gui"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="net-wireless/wireless-tools"
KMEXTRA="doc/kwifimanager"
