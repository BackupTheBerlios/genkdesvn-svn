# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE G3/G4 fax viewer"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="$(deprange $PV $MAXKDEVER kde-base/kviewshell)"

KMEXTRA="kfaxview"
KMCOPYLIB="libkmultipage kviewshell"
KMCOMPILEONLY="kviewshell/"
