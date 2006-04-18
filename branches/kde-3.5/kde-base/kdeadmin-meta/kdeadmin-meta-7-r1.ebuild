# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	x86?(lilo-config)
	kcron
	kdat
	kdeadmin-kfile-plugins
	kuser
	secpolicy"
# NOTE: kpackage, ksysv are useless on a normal gentoo system and so aren't included
# in the above list. However, packages do nominally exist for them.
inherit kdesvn-meta-parent

DESCRIPTION="kdeadmin - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

