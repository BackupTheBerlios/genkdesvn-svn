# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Helper application for subversion.eclass"
HOMEPAGE="http://genkdesvn.berlios.de/"
SRC_URI="http://download.berlios.de/genkdesvn/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-util/subversion-1.2.0"

