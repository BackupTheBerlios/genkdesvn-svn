# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=libs
KSCM_SUBDIR=$PN
inherit kdesvn kdesvn-source

DESCRIPTION="A KDE library for loss-less EXIF operations."
HOMEPAGE="http://digikam.sourceforge.net/"
LICENSE="GPL-2"

KEYWORDS="x86 ~ppc amd64 ~sparc"
IUSE=""

DEPEND="media-libs/libexif
	dev-util/pkgconfig"
RDEPEND="media-libs/libexif"

need-kde 3.1
