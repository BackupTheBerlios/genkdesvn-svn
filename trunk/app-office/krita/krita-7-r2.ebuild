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
	libkoscript lib/koscript
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkopalette lib/kopalette"

KMEXTRACTONLY="lib/"

KMEXTRA="filters/krita"

KMHEADERS=(
	'krita/plugins/colorsfilters/ wdg_brightness_contrast.h'
	'krita/plugins/cimg/ wdg_cimg.h'
	'krita/plugins/bumpmap/ wdgbumpmap.h'
	'krita/plugins/convolutionfilters/ kis_custom_convolution_filter_configuration_base_widget.h'
	'krita/plugins/colorrange/ wdg_colorrange.h'
	'krita/plugins/imagesize/ wdg_imagesize.h wdg_layersize.h'
	'krita/plugins/rotateimage/ wdg_rotateimage.h'
	'krita/plugins/shearimage/ wdg_shearimage.h'
	'krita/plugins/colorspaceconversion/ wdgconvertcolorspace.h'
	'krita/plugins/tool_crop/ wdg_tool_crop.h'
	'krita/plugins/tool_star/ wdg_tool_star.h'
	'krita/plugins/tool_transform/ wdg_tool_transform.h'
	'krita/plugins/histogram/ wdghistogram.h'
	'krita/plugins/variations/ wdg_variations.h'
	'krita/plugins/performancetest/ wdg_perftest.h'
	'krita/plugins/separate_channels/ wdg_separations.h'
#	'krita/plugins/colorsfilters/ wdg_perchannel.h'
)

need-kde 3.3
