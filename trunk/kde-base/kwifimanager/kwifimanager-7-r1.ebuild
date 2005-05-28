# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
KMMODULE=wifi
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE wifi (wireless network) gui"
KEYWORDS="~x86 ~amd64 ~ppc ~ppc64"
IUSE=""
DEPEND=">=net-wireless/wireless-tools-25"
KMEXTRA="doc/kwifimanager"
