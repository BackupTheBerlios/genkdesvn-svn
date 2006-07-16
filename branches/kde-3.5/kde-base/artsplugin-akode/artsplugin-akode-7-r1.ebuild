# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/artsplugin-akode/artsplugin-akode-3.5.0.ebuild,v 1.5 2005/12/17 13:52:13 corsair Exp $

KMNAME=kdemultimedia
KMMODULE=akode_artsplugin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="akode arts plugin"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)
	$(deprange $PV $MAXKDEVER media-libs/akode)"

KMCOPYLIB="libartsbuilder arts/runtime"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
	kdesvn-source_pkg_setup
}

src_compile() {
	local myconf="--with-akode"

	kdesvn-meta_src_compile
}