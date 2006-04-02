# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KSCM_ROOT=extragear
KSCM_MODULE=graphics
KSCM_SUBDIR=showimg
inherit kdesvn kdesvn-source

DESCRIPTION="ShowImg is a feature-rich image viewer for KDE  including an image management system."
HOMEPAGE="http://www.jalix.org/projects/showimg/"
LICENSE="GPL-2"

KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE="exif kipi mysql postgres"

DEPEND="|| ( kde-base/libkonq kde-base/kdebase )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/libpq dev-libs/libpqxx )
	exif? ( media-libs/libkexif )
	kipi? ( media-plugins/kipi-plugins )"

need-kde 3.4

src_compile(){
	local myconf="--with-showimgdb \
        $(use_enable exif kexif) \
        $(use_enable kipi libkipi) \
        $(use_with mysql) \
        $(use_with postgres pgsql)"
	kdesvn_src_compile all
}
