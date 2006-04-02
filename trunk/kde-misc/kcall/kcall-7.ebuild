# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=playground
KSCM_MODULE=pim
KSCM_SUBDIR=${PN}
inherit kde eutils kde-source

DESCRIPTION="Telephony application of Kontact"
HOMEPAGE="http://www.basyskom.de/index.pl/kcall"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="=net-dns/bind-9.2*"

need-kde 3.4
