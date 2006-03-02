# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdewebdev
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE: Quanta Plus Web Development Environment"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="doc tidy"
DEPEND="doc? ( app-doc/quanta-docs )
	dev-libs/libxml2"
RDEPEND="$DEPEND
$(deprange $PV $MAXKDEVER kde-base/kfilereplace)
$(deprange $PV $MAXKDEVER kde-base/kimagemapeditor)
$(deprange $PV $MAXKDEVER kde-base/klinkstatus)
$(deprange $PV $MAXKDEVER kde-base/kommander)
$(deprange $PV $MAXKDEVER kde-base/kxsldbg)
tidy? ( app-text/htmltidy )"

KMCOMPILEONLY=lib

# LIBXML_LIBS is needed by quanta (parsers) by is set kxsldbg, so we extrac it
# to let it set LIBXML_LIBS !!! The exports are no longer needed now ...
#KMEXTRACTONLY="kxsldbg/"

