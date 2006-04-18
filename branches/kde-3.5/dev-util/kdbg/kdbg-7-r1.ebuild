# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kdesvn-sourceforge

DESCRIPTION="A Graphical Debugger Interface to gdb"
HOMEPAGE="http://members.nextra.at/johsixt/kdbg.html"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-devel/gdb-5.0"

need-kde 3.5
