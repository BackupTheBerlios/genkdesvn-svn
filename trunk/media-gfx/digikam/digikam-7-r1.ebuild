# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=graphics
KSCM_SUBDIR=$PN
inherit kde kde-source

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://digikam.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND=">=media-libs/libgphoto2-2
	>=media-libs/libkexif-0.2.1
	media-libs/libkipi
	media-libs/imlib2
	media-libs/tiff
	=dev-db/sqlite-3*"

need-kde 3.2
