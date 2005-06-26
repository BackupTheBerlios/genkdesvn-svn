# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kword/kword-1.3.5.ebuild,v 1.3 2005/04/09 13:08:55 josejx Exp $

KMNAME=koffice
MAXKOFFICEVER=$PV
inherit kde-meta eutils kde-source

DESCRIPTION="KOffice Word Processor"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc amd64"
IUSE=""
SLOT="$PV"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	$(deprange $PV $MAXKOFFICEVER app-office/kspread)
	>=app-text/wv2-0.1.8
	>=media-gfx/imagemagick-5.5.2
	>=app-text/libwpd-0.8"

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
	libkspreadcommon kspread"

KMEXTRACTONLY="lib/ kspread/ kchart/kdchart"

KMCOMPILEONLY="filters/liboofilter interfaces/ kspread/"

KMEXTRA="filters/kword"

PATCHES="${FILESDIR}/CAN-2005-0064.patch"

need-kde 3.3
