# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=kaffeine
inherit kde eutils kde-source

DESCRIPTION="Media player for KDE"
HOMEPAGE="http://kaffeine.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="dvb gstreamer arts"

DEPEND=">=media-libs/xine-lib-1
	gstreamer? ( >=media-libs/gst-plugins )
	arts? ( >=kde-base/arts )
	dvb? ( >=sys-kernel/linux-headers-2.6 )"

need-kde 3.2

src_compile() {
	myconf="$(use_with arts) $(use_with gstreamer) $(use_with dvb)"
	kde_src_compile
}
