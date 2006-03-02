# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	arts? ( ksayit )
	arts? ( kttsd )
	kmag
	kdeaccessibility-iconthemes
	kmousetool
	kbstateapplet
	kmouth"
inherit kdesvn-meta-parent

DESCRIPTION="kdeaccessibility - merge this to pull in all kdeaccessiblity-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="arts"

