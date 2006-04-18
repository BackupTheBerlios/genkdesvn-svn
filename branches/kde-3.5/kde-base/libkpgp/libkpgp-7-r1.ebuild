# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE pgp abstraction library"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""
