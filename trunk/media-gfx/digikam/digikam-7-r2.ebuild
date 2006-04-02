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
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND=">=media-libs/libgphoto2-2
	>=media-libs/libkexif-0.2.1
	media-libs/libkipi
	media-libs/imlib2
	media-libs/tiff
	media-gfx/exiv2
	=dev-db/sqlite-3*"

PATCHES="${FILESDIR}/gcc41.patch"

need-kde 3.4

src_install(){
	kdesvn_src_install

	# Install the .desktop in FDO's suggested directory
	dodir /usr/share/applications/kde
	mv ${D}/usr/share/applnk/Graphics/digikam.desktop \
		${D}/usr/share/applications/kde/
}
