# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=network
KSCM_SUBDIR=ktorrent
inherit kde kde-source

need-kde 3

IUSE=""
DESCRIPTION="BitTorrent frontend for the KDE desktop"
HOMEPAGE="http://extragear.kde.org/apps/ktorrent"
LICENSE="GPL-2"
KEYWORDS="~x86"

PATCHES="$FILESDIR/ktorrent-7-Makefile.am.patch"

