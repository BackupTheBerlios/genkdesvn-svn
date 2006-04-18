# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KSCM_MODULE=kdereview
KSCM_SUBDIR=$PN
KSCM_MODULE_IS_ROOT=true
inherit kdesvn kdesvn-source

DECRIPTION="Kerry Beagle is a KDE frontend for the Beagle desktop search daemon"
HOMEPAGE="http://en.opensuse.org/Kerry"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=app-misc/beagle-0.2"
DEPEND="${RDEPEND}
    dev-util/pkgconfig"

need-kde 3.4

