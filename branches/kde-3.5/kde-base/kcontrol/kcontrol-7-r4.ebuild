# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

UNSERMAKE=no
KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="The KDE Control Center"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="arts ieee1394 logitech-mouse opengl ssl"
PATCHES="$FILESDIR/configure.in.in-kdm-settings.diff"

DEPEND=">=media-libs/freetype-2
	media-libs/fontconfig
	ssl? ( dev-libs/openssl )
	arts? ( $(deprange $PV $MAXKDEVER kde-base/arts) )
	opengl? ( virtual/opengl )
	ieee1394? ( sys-libs/libraw1394 )
	logitech-mouse? ( >=dev-libs/libusb-0.1.10a )"

RDEPEND="${DEPEND}
	sys-apps/usbutils
	$(deprange $PV $MAXKDEVER kde-base/kcminit)
	$(deprange $PV $MAXKDEVER kde-base/kdebase-data)
	$(deprange $PV $MAXKDEVER kde-base/kde-i18n)
	$(deprange $PV $MAXKDEVER kde-base/kicker)
	$(deprange $PV $MAXKDEVER kde-base/kdesu)
	$(deprange $PV $MAXKDEVER kde-base/khelpcenter)
	$(deprange $PV $MAXKDEVER kde-base/khotkeys)
	$(deprange $PV $MAXKDEVER kde-base/libkonq)"

KMEXTRACTONLY="kwin/kwinbindings.cpp
        kicker/kicker/core/kickerbindings.cpp
        kicker/taskbar/taskbarbindings.cpp
        kdesktop/kdesktopbindings.cpp
        klipper/klipperbindings.cpp
        kxkb/kxkbbindings.cpp
        kicker/taskmanager
		kicker/libkicker
		kicker/taskbar"

KMEXTRA="doc/kinfocenter"

KMCOPYLIB="libkonq libkonq
	libkicker kicker/libkicker
	libtaskbar kicker/taskbar
	libtaskmanager kicker/taskmanager"

KMTARGETSONLY=( 
	'kicker/libkicker .kcfgc' 
	'kicker/taskbar .kcfgc'
)

src_compile() {
	myconf="$myconf `use_with ssl` `use_with arts` `use_with opengl gl`
			`use_with ieee1394 libraw1394` `use_with logitech-mouse libusb`
			--with-usbids=/usr/share/misc/usb.ids"
	kdesvn-meta_src_compile
}