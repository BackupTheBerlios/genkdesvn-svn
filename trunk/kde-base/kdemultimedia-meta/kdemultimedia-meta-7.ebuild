# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	arts?(artsplugin-akode)
	arts?(artsplugin-mpeglib)
	arts?(artsplugin-mpg123)
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
	libkcddb
	mpeglib"
inherit kde-meta-parent

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="arts"

