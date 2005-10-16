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
IUSE="sametime slp ssl xmms"

DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	>=dev-libs/glib-2
	sametime? ( >=net-libs/meanwhile-0.4.2 )
	slp? ( net-libs/openslp )
	xmms? ( media-sound/xmms )"
RDEPEND="$DEPEND
	ssl? ( app-crypt/qca-tls )
	>=sys-kernel/linux-headers-2.6.11"

src_compile() {
    # External libgadu support - doesn't work, kopete requires a specific development snapshot of libgadu.
    # Maybe we can enable it in the future.
    # The nowlistening plugin has xmms support.
	local myconf="$(use_enable sametime sametime-plugin)
                  $(use_with xmms) --without-external-libgadu"

	kde-meta_src_compile
}
