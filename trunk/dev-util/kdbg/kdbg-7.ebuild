# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde sourceforge

DESCRIPTION="A Graphical Debugger Interface to gdb"
HOMEPAGE="http://members.nextra.at/johsixt/kdbg.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE=""

RDEPEND=">=sys-devel/gdb-5.0"
need-kde 3
