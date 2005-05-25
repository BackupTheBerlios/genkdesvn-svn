# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	kig
	kalzium
	khangman
	kpercentage
	kiten
	kvoctrain
	kturtle
	kverbos
	kdeedu-applnk
	kbruch
	keduca
	kmessedwords
	klatin
	kmplot
	kstars
	ktouch
	klettres
	kmathtool
	kwordquiz"

inherit kde-meta-parent

DESCRIPTION="kdeedu - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

