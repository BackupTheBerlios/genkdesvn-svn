# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=graphics
KSCM_SUBDIR=$PN
inherit kdesvn kdesvn-source

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://digikam.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86"
IUSE="nfs"

DEPEND=">=media-libs/libgphoto2-2
    >=media-libs/libkexif-0.2.1
    >=dev-db/sqlite-3
    >=media-libs/libkipi-0.1.1
    media-libs/imlib2
    media-libs/tiff
    sys-libs/gdbm
    >=media-gfx/dcraw-8.03"

RDEPEND="${DEPEND}
    || ( ( kde-base/kgamma kde-base/kamera ) kde-base/kdegraphics )"

need-kde 3.4

pkg_setup(){
	kdesvn_pkg_setup
	slot_rebuild "media-libs/libkipi media-libs/libkexif" && die
}

src_compile(){
	myconf="$(use_enable nfs nfs-hack)"
	kdesvn_src_compile
}

src_install(){
	kdesvn_src_install

	# Install the .desktop in FDO's suggested directory
	dodir /usr/share/applications/kde
	mv ${D}/usr/share/applnk/Graphics/digikam.desktop \
		${D}/usr/share/applications/kde
}

