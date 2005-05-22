# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE Interactive Geometry tool"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="kig-scripting"
DEPEND="kig-scripting? ( >=dev-libs/boost-1.32 )"

src_compile() {
	myconf="${myconf} $(use_enable kig-scripting kig-python-scripting)"

	kde_src_compile
}
