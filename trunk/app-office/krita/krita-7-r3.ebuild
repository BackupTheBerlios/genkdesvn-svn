# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MAXKOFFICEVER=${PV}
KMNAME=koffice
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KOffice image manipulation program."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="$PV"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="openexr"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	>=media-gfx/imagemagick-5.5.2
	>=media-libs/lcms-1.14-r1
	opengl? ( virtual/opengl virtual/glu )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkopalette lib/kopalette
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkrossmain lib/kross/main
	libkrossapi lib/kross/api"

KMEXTRACTONLY="lib/"

KMEXTRA="filters/krita"

need-kdesvn 3.4