# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	subversion?(kdesdk-kioslaves)
	cervisia
	kapptemplate
	kbabel
	kbugbuster
	kcachegrind
	kdesdk-kfile-plugins
	kdesdk-misc
	kdesdk-scripts
	kmtrace
	kompare
	kspy
	kuiviewer
	umbrello"
inherit kde-meta-parent

DESCRIPTION="kdesdk - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="subversion"

