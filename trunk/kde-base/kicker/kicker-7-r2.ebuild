# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

UNSERMAKE=no
KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE panel housing varous applets"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="xcomposite"
PATCHES="$FILESDIR/applets-configure.in.in.diff"

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)
$(deprange $PV $MAXKDEVER kde-base/kdebase-data)
    xcomposite? ( || ( (
            x11-libs/libXcomposite
            ) <=x11-base/xorg-x11-6.9 )
        )"

DEPEND="${RDEPEND}
    xcomposite? ( || ( (
            x11-proto/compositeproto
            ) <=x11-base/xorg-x11-6.9 )
        )"

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY="libkonq
	kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"

#PATCHES="${FILESDIR}/kdebase-kicker.patch"

src_compile() {
	myconf="$myconf $(use_with xcomposite composite)"
	kdesvn-meta_src_compile
}

