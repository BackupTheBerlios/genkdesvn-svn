# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
KMMODULE=kfile-plugins
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="kfile plugins from the kdenetwork package. Currently provides a torrent kfile plugin."
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
