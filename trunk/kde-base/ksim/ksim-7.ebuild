# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE System Monitor applets"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="snmp"

DEPEND="snmp? ( net-analyzer/net-snmp )"

