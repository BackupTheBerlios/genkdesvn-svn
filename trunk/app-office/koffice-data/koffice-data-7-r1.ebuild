# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-data/koffice-data-1.3.5.ebuild,v 1.3 2005/04/09 12:59:37 josejx Exp $

KMMODULE=
KMNOMODULE="true"
inherit kofficesvn

DESCRIPTION="shared koffice data files"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

KMEXTRA="
	mimetypes/
	servicetypes/
	pics/
	templates/
	autocorrect/"
