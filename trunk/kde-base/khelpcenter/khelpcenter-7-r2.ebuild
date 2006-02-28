# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inhert kdesvn-meta eutils kdesvn-source

DESCRIPTION="The KDE Help Center"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

KMEXTRA="doc/faq
    doc/glossary
    doc/quickstart
    doc/userguide
    doc/visualdict"

