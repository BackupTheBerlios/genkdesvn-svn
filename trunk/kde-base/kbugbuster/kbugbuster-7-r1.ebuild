# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta kde-source

DESCRIPTION="KBugBuster - A tool for checking and reporting KDE apps' bugs"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="kcal"

DEPEND="kcal? ( $(deprange $PV $MAXKDEVER kde-base/libkcal) )
	$(deprange $PV $MAXKDEVER kde-base/libkdepim)"

#TODO tell configure about the optional kcal support, or something
