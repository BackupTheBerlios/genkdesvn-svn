# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
KMMODULE=mpeglib_artsplug
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="mpeglib plugin for arts"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/mpeglib)"
KMCOPYLIB="libmpeg mpeglib/lib/"
KMEXTRACTONLY="mpeglib/"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
	kdesvn-source_pkg_setup
}
