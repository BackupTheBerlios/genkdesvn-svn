# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE System Guard"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="lm_sensors zeroconf"
DEPEND="lm_sensors? ( sys-apps/lm_sensors )
    zeroconf? ( net-misc/mDNSResponder )"

src_compile() {
	local myconf="$(use_with lm_sensors sensors)
				  $(use_enable zeroconf dnssd)"

	kdesvn-meta_src_compile
}

