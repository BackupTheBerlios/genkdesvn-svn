# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdeaddons
KMNODOCS=true
MAXKDEVER=$PV
UNSERMAKE=no
inherit kde-meta kde-source

DESCRIPTION="Various plugins for konqueror"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/konqueror)
$(deprange $PV $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"

# Don't install the akregator plugin, since it depends on akregator, which is
# a heavy dep.
KMEXTRACTONLY="konq-plugins/akregator"
