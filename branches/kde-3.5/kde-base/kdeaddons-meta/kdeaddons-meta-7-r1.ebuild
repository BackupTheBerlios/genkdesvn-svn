# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	arts?(noatun-plugins)
	atlantikdesigner
	knewsticker-scripts
	kaddressbook-plugins
	kate-plugins
	kicker-applets
	kdeaddons-kfile-plugins
	konq-plugins
	konqueror-akregator
	kdeaddons-docs-konq-plugins
	ksig
	renamedlg-audio
	renamedlg-images"
inherit kdesvn-meta-parent

DESCRIPTION="kdeaddons - merge this to pull in all kdeaddons-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="arts"
