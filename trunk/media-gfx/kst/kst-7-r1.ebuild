# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit kde
need-kde 3.1

KSCM_ROOT=extragear
KSCM_MODULE=graphics
KSCM_SUBDIR=kst
inherit kde-source

DESCRIPTION="A plotting and data viewing program for KDE"
HOMEPAGE="http://extragear.kde.org/apps/kst/"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"
LICENSE="GPL-2"

SLOT="0"
IUSE=""

#DEPEND="|| ( kde-base/kdebase-meta >=kde-base/kdebase-3.1 )"
RDEPEND="$DEPEND
	sci-libs/gsl"
