# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
KMMODULE=arts
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS=true
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="aRts pipeline builder and other tools"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
KMEXTRACTONLY="mpeglib_artsplug/configure.in.in" # needed because the artsc-config call is here
KMEXTRA="doc/artsbuilder"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
	kdesvn-source_pkg_setup
}