# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	accessibility?(kdeaccessibility-meta)
	kdeaddons-meta
	kdeadmin-meta
	kdebase-meta
	kdeedu-meta
	kdegames-meta
	kdegraphics-meta
	kdemultimedia-meta
	kdenetwork-meta
	kdepim-meta
	kdesdk-meta
	kdetoys-meta
	kdeutils-meta
	kdeartwork-meta
	kdewebdev-meta"
inherit kde-meta-parent

DESCRIPTION="kde - merge this to pull in all kde packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~ppc ~sparc ~ppc64"
IUSE="accessibility"

