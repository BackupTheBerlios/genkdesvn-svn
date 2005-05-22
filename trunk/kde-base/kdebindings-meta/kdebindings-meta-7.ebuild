# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdebindings - merge this to pull in all kdebindings-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="
>=kde-base/dcopperl-$PV
>=kde-base/dcoppython-3.4.0_beta2
$(deprange $PV $MAXKDEVER kde-base/kalyptus)
$(deprange $PV $MAXKDEVER kde-base/kdejava)
$(deprange $PV $MAXKDEVER kde-base/kjsembed)
>=kde-base/korundum-$PV
$(deprange $PV $MAXKDEVER kde-base/qtjava)
>=kde-base/qtruby-$PV
$(deprange $PV $MAXKDEVER kde-base/smoke)"


# Omitted: qtsharp, dcopc, dcopjava, xparts (considered broken by upstream) 
