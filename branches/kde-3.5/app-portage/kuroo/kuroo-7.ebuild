# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ESF_MODULE="guitoo"
ESF_SUBDIR="kuroo"
inherit kdesvn-sourceforge

DESCRIPTION="A KDE Portage frontend"
HOMEPAGE="http://kuroo.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

RDEPEND="app-portage/gentoolkit
    !app-portage/guitoo
    kde-misc/kdiff3"

need-kde 3.4

