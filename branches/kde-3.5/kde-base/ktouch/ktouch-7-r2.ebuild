# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE: A program that helps you to learn and practice touch typing"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdeedu)"

KMEXTRACTONLY="libkdeedu/kdeeduplot"
KMCOPYLIB="libkdeeduplot libkdeedu/kdeeduplot"

