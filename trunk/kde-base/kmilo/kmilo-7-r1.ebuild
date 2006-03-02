# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kmilo - a kded module that can be extended to support various types of hardware
input devices that exist, such as those on keyboards."
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="pbbuttonsd"
DEPEND="pbbuttonsd? ( app-laptop/pbbuttonsd )"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf="$(use_with pbbuttonsd powerbook)"

	kdesvn-meta_src_compile
}
		
