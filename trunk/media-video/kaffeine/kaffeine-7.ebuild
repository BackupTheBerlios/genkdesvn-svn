# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde sourceforge

DESCRIPTION="Media player for KDE"
HOMEPAGE="http://kaffeine.sourceforge.net/"
SRC_URI="http://download.berlios.de/genkdesvn/admin.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="dvb gstreamer arts"

DEPEND=">=media-libs/xine-lib-1
	gstreamer? ( >=media-libs/gst-plugins )
	arts? ( >=kde-base/arts )
	dvb? ( >=sys-kernel/linux-headers-2.6 )"

need-kde 3.2

src_unpack() {
	cvs_src_unpack
	cd $S
	rm -r admin
	unpack $A
	# Visiblity stuff is way broken! Just disable it when it's present
	# until upstream finds a way to have it working right.
	if grep KDE_ENABLE_HIDDEN_VISIBILITY configure.in &> /dev/null || ! [[ -f configure ]]; then
	find ${S} -name configure.in.in | xargs sed -i -e 's:KDE_ENABLE_HIDDEN_VISIBILITY:echo Disabling hidden visibility:g'
		rm -f configure
	fi
}

src_compile() {
	myconf="$(use_with arts) $(use_with gstreamer) $(use_with dvb)"
	kde_src_compile
}

