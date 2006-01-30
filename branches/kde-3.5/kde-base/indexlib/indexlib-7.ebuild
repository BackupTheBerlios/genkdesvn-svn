# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS=true
inherit kde-meta eutils kde-source

DESCRIPTION="KDEPIM indexing library"
HOMEPAGE="http://pim.kde.org/"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
