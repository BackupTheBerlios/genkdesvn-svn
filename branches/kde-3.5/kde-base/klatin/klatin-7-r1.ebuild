# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE: KLatin - a program to help revise Latin"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkdeedu)"


KMEXTRACTONLY="libkdeedu/kdeeducore"
KMCOPYLIB="libkdeeducore libkdeedu/kdeeducore"

