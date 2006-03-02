# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdewebdev
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE: Quanta Plus Web Development Environment"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc tidy"
DEPEND="dev-libs/libxslt
    dev-libs/libxml2"
RDEPEND="$DEPEND
$(deprange $PV $MAXKDEVER kde-base/kfilereplace)
$(deprange $PV $MAXKDEVER kde-base/kimagemapeditor)
$(deprange $PV $MAXKDEVER kde-base/klinkstatus)
$(deprange $PV $MAXKDEVER kde-base/kommander)
$(deprange $PV $MAXKDEVER kde-base/kxsldbg)
tidy? ( app-text/htmltidy )
doc? ( app-doc/quanta-docs )"

KMCOMPILEONLY=lib

