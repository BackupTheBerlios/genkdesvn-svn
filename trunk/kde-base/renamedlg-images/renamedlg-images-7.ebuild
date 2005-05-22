# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="renamedlgplugins/images"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="renamedlg plugin for image files"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
DEPEND=""

