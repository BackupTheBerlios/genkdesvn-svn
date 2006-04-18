# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	amor
	eyesapplet
	fifteenapplet
	kmoon
	kodo
	kteatime
	ktux
	kweather
	kworldwatch"
inherit kdesvn-meta-parent

DESCRIPTION="kdetoys - merge this to pull in all kdetoys-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

