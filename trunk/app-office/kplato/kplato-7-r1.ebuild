# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Headers: $

ESCM_EXTERNALS="branches/KDE/3.5/kdepim/kdgantt"
inherit kofficesvn

DESCRIPTION="KOffice integrated project management and planning tool."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)"

DEPEND="${RDEPEND}"

KMCOPYLIB="
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkstore lib/store"

KMEXTRACTONLY="
	lib/
	kugar/"

KMCOMPILEONLY="kdgantt"

#KMEXTRA="kdgantt"
