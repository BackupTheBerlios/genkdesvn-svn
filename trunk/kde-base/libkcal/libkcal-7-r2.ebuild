# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE kcal library for korganizer etc"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
OLDDEPEND="~kde-base/ktnef-$PV"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/ktnef)"

KMCOPYLIB="libktnef ktnef/lib"
KMEXTRACTONLY="libkdepim/email.h"
KMCOMPILEONLY="libemailfunctions/"

PATCHES="$FILESDIR/icaltimezone.c.diff"
