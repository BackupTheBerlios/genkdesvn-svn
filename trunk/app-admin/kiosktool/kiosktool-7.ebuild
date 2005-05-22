# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=sysadmin
KSCM_SUBDIR=$PN
inherit kde kde-source

DESCRIPTION="KDE Kiosk GUI Admin Tool"
HOMEPAGE="http://extragear.kde.org/apps/kiosktool/"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

need-kde 3.2
