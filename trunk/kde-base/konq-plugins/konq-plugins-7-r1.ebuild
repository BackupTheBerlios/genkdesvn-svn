# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdeaddons
KMNODOCS=true
MAXKDEVER=$PV
UNSERMAKE=no
inherit kdesvn-meta kdesvn-source

DESCRIPTION="Various plugins for konqueror"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/konqueror)
    !kde-misc/metabar"
RDEPEND="${DEPEND}
$(deprange 3.5.0 $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"

# Don't install the akregator plugin, since it depends on akregator, which is
# a heavy dep.
KMEXTRACTONLY="konq-plugins/akregator"
