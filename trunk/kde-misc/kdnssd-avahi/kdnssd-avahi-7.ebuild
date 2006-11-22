# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=playground
KSCM_MODULE=network
KSCM_SUBDIR=$PN
inherit kdesvn kdesvn-source

DESCRIPTION="DNS Service Discovery kioslave using Avahi (rather than mDNSResponder)"
HOMEPAGE="http://wiki.kde.org/tiki-index.php?page=Zeroconf+in+KDE"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="net-dns/avahi"
DEPEND="${RDEPEND}"

need-kde 3.5

pkg_config() {
        if ! built_with_use net-dns/avahi qt3; then
                eerror "To compile kdnssd-avahi package you need Avahi with Qt 3.x support."
                eerror "but net-dns/avahi is not built with qt3 USE flag enabled."
                die "Please, rebuild net-dns/avahi with the \"qt3\" USE flag."
        fi
}
