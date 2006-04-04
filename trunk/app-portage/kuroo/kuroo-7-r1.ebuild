# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_PROJECT="${PN}-svn"
ESVN_REPO_URI="svn://kuroo.org/repos/kuroo"
KSCM_ROOT="branches"
KSCM_MODULE="0.80.0"

inherit kdesvn kdesvn-source

DESCRIPTION="A KDE Portage frontend"
HOMEPAGE="http://kuroo.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE="debug"

RDEPEND="!app-portage/guitoo
	|| (kde-misc/kdiff3 kde-base/kdesdk)"

need-kde 3.4
