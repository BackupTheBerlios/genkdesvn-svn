# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="renamedlgplugins/images"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="renamedlg plugin for image files"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

