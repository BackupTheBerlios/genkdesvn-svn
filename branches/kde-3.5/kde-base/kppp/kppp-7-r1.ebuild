# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE: A dialer and front-end to pppd"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

#PATCHES="${FILESDIR}/${PN}-bindnow.patch"

#src_compile() {
#	export BINDNOW_FLAGS="$(bindnow-flags)"
#	kdesvn-meta_src_compile
#}
