# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	kfilereplace
	kimagemapeditor
	klinkstatus
	kommander
	kxsldbg
	quanta"
inherit kde-meta-parent

DESCRIPTION="kdewebdev - merge this to pull in all kdewebdev-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

