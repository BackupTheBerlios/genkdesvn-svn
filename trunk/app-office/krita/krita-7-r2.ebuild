# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MAXKOFFICEVER=${PV}
KMNAME=koffice
inherit kde-meta eutils kde-source

DESCRIPTION="KOffice image manipulation program."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="$PV"
KEYWORDS="~amd64 ~x86"
IUSE="javascript openexr"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	>=media-gfx/imagemagick-5.5.2
	media-libs/lcms
	javascript? ( kde-base/kjsembed )
	openexr? ( >=media-libs/openexr-1.2 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkopalette lib/kopalette
	libkrossmain lib/kross/main
	libkrossapi lib/kross/api"

KMEXTRACTONLY="lib/"

KMEXTRA="filters/krita"

need-kde 3.3
