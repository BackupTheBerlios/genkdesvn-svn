# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdemultimedia
KMMODULE=audiofile_artsplugin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="arts audiofile plugin"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
DEPEND="media-libs/audiofile"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}
