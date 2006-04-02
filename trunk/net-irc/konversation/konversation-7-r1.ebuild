# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=network
KSCM_SUBDIR=konversation
inherit kdesvn kdesvn-source

DESCRIPTION="A user friendly IRC Client for KDE3.x"
HOMEPAGE="http://konversation.kde.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

need-kde 3

src_install() {
	kdesvn_src_install
	use nls || rm -rf "${D}"/usr/share/locale
}
