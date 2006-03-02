# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kfile-plugins/"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="kdeaddons kfile plugins"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl"
DEPEND="ssl? (dev-libs/openssl)"

# kfile-cert requires ssl

src_compile() {
	myconf="$(use_with ssl)"
	kdesvn-meta_src_compile
}
