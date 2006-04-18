# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	blinken
	kanagram
	kalzium
	kgeography
	khangman
	kig
	kpercentage
	kiten
	kvoctrain
	kturtle
	kverbos
	kdeedu-applnk
	kbruch
	keduca
	klatin
	kmplot
	kstars
	ktouch
	klettres
	kwordquiz"

inherit kdesvn-meta-parent

DESCRIPTION="kdeedu - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

