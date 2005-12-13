# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESF_MODULE="gamescrafters"
ESF_SUBDIR="$PN"
inherit games sourceforge

DESCRIPTION=""
#SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/tk"

dogamesbitmap() { gameswrapper ${FUNCNAME/games} "$@"; }

src_install() {

	egamesinstall

}
