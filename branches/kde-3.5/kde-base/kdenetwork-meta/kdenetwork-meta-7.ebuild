# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	dcoprss
	kdenetwork-filesharing
	kdict
	kget
	knewsticker
	kopete
	kpf
	kppp
	krdc
	krfb
	ksirc
	ktalkd
	librss
	kdnssd
	kdenetwork-kfile-plugins
	lisa
	wifi?(kwifimanager)"
inherit kde-meta-parent

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="wifi"
