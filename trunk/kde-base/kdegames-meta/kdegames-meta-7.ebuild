# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	arts?(kasteroids)
	arts?(kbounce)
	arts?(kolf)
	atlantik
	katomic
	kbackgammon
	kbattleship
	kblackbox
	kenolaba
	kfouleggs
	kgoldrunner
	kjumpingcube
	klickety
	klines
	kmahjongg
	kmines
	konquest
	kpat
	kpoker
	ktron
	ktuberling
	ksame
	kshisen
	ksirtet
	ksmiletris
	ksnake
	ksokoban
	kspaceduel
	kreversi
	kwin4
	lskat"
inherit kde-meta-parent

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~ppc ~sparc ~ppc64 ~amd64"
IUSE=""

