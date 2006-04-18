# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=trunk/kdenonbeta
inherit kdesvn kdesvn-source

DESCRIPTION="MS Access Migration driver for kexi"
HOMEPAGE="http://www.kexi-project.org/wiki/wikiview/index.php?UsingSubversion#MS_Access_Migration_Driver"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND="app-office/kexi
	app-office/mdbtools"

need-kde 3.5

