# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=utils
KSCM_SUBDIR=$PN
inherit kdesvn kdesvn-source

DESCRIPTION="Application which allows direct editing of all aspects of the KDE desktop"
HOMEPAGE="http://extragear.kde.org/apps/kconfigeditor/"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

need-kde 3.2
