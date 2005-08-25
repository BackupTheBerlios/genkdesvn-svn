# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl xmms"

RDEPEND="ssl? ( app-crypt/qca-tls )
		 >=sys-kernel/linux-headers-2.6.11"

DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	xmms? ( media-sound/xmms )"
RDEPEND="$DEPEND
	ssl? ( app-crypt/qca-tls )
	>=sys-kernel/linux-headers-2.6.11"

myconf="$myconf $(use_with xmms) --enable-audiovideo"
