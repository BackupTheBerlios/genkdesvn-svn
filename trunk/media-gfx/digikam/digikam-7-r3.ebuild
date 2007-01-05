# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=graphics
KSCM_SUBDIR=$PN
inherit kdesvn kdesvn-source

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://www.digikam.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nfs kdehiddenvisibility kdeenablefinal"

DEPEND=">=media-libs/libgphoto2-2.2
	>=dev-db/sqlite-3
	>=media-libs/libkipi-0.1
	>=media-libs/tiff-3.8.2
	media-libs/jasper
	sys-libs/gdbm
	media-gfx/dcraw
	>=media-gfx/exiv2-0.12
	>=media-libs/lcms-1.14
	>=media-libs/libpng-1.2"

RDEPEND="${DEPEND}
	|| ( ( kde-base/kgamma kde-base/kamera ) kde-base/kdegraphics )"

need-kde 3.5

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

