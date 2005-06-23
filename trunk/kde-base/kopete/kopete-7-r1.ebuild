# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="ssl"

RDEPEND="ssl? ( app-crypt/qca-tls )
		 >=sys-kernel/linux-headers-2.6.11"

src_compile() {

	myconf="${myconf} --enable-audiovideo"

	kde_src_compile
}