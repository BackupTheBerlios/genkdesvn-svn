# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
KMMODULE=audiofile_artsplugin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="arts audiofile plugin"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="media-libs/audiofile"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
	kdesvn-source_pkg_setup
}
