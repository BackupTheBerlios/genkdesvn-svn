# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-data/koffice-data-1.3.5.ebuild,v 1.3 2005/04/09 12:59:37 josejx Exp $

MAXKOFFICEVER=$PV
KMNAME=koffice
KMMODULE=
KMNOMODULE="true"
inherit kde-meta eutils kde-source

DESCRIPTION="shared koffice data files"
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc amd64"

IUSE=""
SLOT="$PV"

RDEPEND=""

DEPEND="dev-util/pkgconfig"

KMEXTRA="
	mimetypes/
	servicetypes/
	pics/
	templates/
	autocorrect/"

need-kde 3.3
