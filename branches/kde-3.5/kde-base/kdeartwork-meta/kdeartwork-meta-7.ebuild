# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	kdeartwork-emoticons
	kdeartwork-iconthemes
	kdeartwork-icewm-themes
	kdeartwork-kscreensaver
	kdeartwork-kwin-styles
	kdeartwork-kworldclock
	kdeartwork-sounds
	kdeartwork-styles
	kdeartwork-wallpapers"
inherit kde-meta-parent

DESCRIPTION="kdeartwork - merge this to pull in all kdeartwork-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

