# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=pim
KSCM_SUBDIR=kdebluetooth
inherit kdesvn kdesvn-source

need-kde 3

DESCRIPTION="KDE Bluetooth Framework"
HOMEPAGE="http://kde-bluetooth.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 hppa sparc"
IUSE="xmms irmc"

DEPEND=">=dev-libs/openobex-1.2-r1
	>=net-wireless/bluez-libs-2.15
	>=media-libs/libvorbis-1.0
	xmms? ( >=media-sound/xmms-1.2.10 )
	irmc? ( || ( kde-base/kitchensync kde-base/kdepim ) )"

RDEPEND="|| ( ( kde-base/kdialog kde-base/konqueror )  kde-base/kdebase )
    net-wireless/bluez-utils"

#PATCHES="${FILESDIR}/${PN}-gcc41.patch"

src_compile() {
	kdesvn_src_compile myconf
	myconf="$myconf `use_with xmms` `use_enable irmc irmcsynckonnector`"
	kdesvn_src_compile configure make
}

pkg_postinst() {
	einfo 'This new version of kde-bluetooth provides a replacement for the'
	einfo 'standard bluepin program "kbluepin". If you want to use this version,'
	einfo 'you have to edit "/etc/bluetooth/hcid.conf" and change the line'
	einfo '"pin_helper oldbluepin;" to "pin_helper /usr/bin/kbluepin;".'
	einfo 'Then restart hcid to make the change take effect.'
	einfo ''
	einfo 'The bemused server (avaible with the "xmms" USE flag enabled) only works with'
	einfo 'Symbian OS phones'
}
