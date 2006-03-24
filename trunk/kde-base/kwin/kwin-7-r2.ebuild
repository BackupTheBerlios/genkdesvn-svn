# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE window manager"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="xcomposite"
RDEPEND="xcomposite? ( || ( (
            x11-libs/libXcomposite
            x11-libs/libXdamage
            ) <=x11-base/xorg-x11-6.9 )
        )"
DEPEND="${RDEPEND}
    xcomposite? ( || ( (
            x11-proto/compositeproto
            x11-proto/damageproto
            ) <=x11-base/xorg-x11-6.9 )
        )"

#PATCHES="${FILESDIR}/${P}-systray.patch"

src_compile() {
	myconf="$myconf $(use_with xcomposite composite)"
	kdesvn-meta_src_compile
}
