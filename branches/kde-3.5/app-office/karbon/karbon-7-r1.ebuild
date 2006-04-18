# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit kofficesvn

DESCRIPTION="KOffice: Yet another vector graphics application."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	>=media-gfx/imagemagick-5.5.2
	>=media-libs/freetype-2
    media-libs/fontconfig
	media-libs/libart_lgpl"

DEPEND="${RDEPEND}"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
    libkopalette lib/kopalette
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store"

KMEXTRACTONLY="lib/"

KMCOMPILEONLY="filters/liboofilter"

KMEXTRA="filters/karbon"

