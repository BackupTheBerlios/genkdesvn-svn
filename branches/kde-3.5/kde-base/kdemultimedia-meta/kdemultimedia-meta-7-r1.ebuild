# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	arts?(artsplugin-akode)
	arts?(artsplugin-audiofile)
	arts?(artsplugin-xine)
	arts?(juk)
	arts?(kaboodle)
	arts?(kaudiocreator)
	arts?(kdemultimedia-arts)
	arts?(krec)
	arts?(noatun)
	kdemultimedia-kappfinder-data
	kdemultimedia-kfile-plugins
	kdemultimedia-kioslaves
	kmid
	kmix
	kscd
	libkcddb"

## scheduled to be removed
#	mpeglib
#	artsplugin-mpeglib
#	artsplugin-mpg123

inherit kdesvn-meta-parent

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="arts"

