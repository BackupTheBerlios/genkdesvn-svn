# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	lirc? ( kdelirc )
	crypt? ( kgpg )
	ark
	kcalc
	kcharselect
	kdf
	kedit
	kfloppy
	khexedit
	kjots
	klaptopdaemon
	kmilo
	kregexpeditor
	ksim
	ktimer
	kwalletmanager
	superkaramba"
inherit kdesvn-meta-parent

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="crypt lirc"

