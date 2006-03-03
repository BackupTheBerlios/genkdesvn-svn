# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebindings
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KDE javascript parser and embedder"
HOMEPAGE="http://xmelegance.org/kjsembed/"

KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/kwin)"
OLDDEPEND="~kde-base/kwin-$PV"

PATCHES="$FILESDIR/no-gtk-glib-check.diff"

# Probably missing some deps, too
