# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde sourceforge

DESCRIPTION="kradio is a radio tuner application for KDE"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="lirc"

DEPEND="lirc? ( app-misc/lirc )
	media-libs/libsndfile"
need-kde 3

