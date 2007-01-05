# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KMNAME=kdebase
KMMODULE=kioslave
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kioslave: the kde VFS framework - kioslave plugins present a filesystem-like view of arbitrary data"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="hal kdehiddenvisibility ldap openexr samba"
DEPEND="ldap? ( net-nds/openldap )
        samba? ( >=net-fs/samba-3.0.1 )
        >=dev-libs/cyrus-sasl-2
        hal? ( || ( dev-libs/dbus-qt3-old ( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 ) )
                   =sys-apps/hal-0.5* )
        openexr? ( >=media-libs/openexr-1.2.2-r2 )"
RDEPEND="${DEPEND}
        $(deprange $PV $MAXKDEVER kde-base/kdialog)"    # for the kdeeject script used by the devices/mounthelper ioslave

pkg_setup() {
	if use hal && has_version '<sys-apps/dbus-0.91' && ! built_with_use sys-apps/dbus qt3; then
		eerror "To enable HAL support in this package is required to have"
		eerror "sys-apps/dbus compiled with Qt 3 support."
		eerror "Please reemerge sys-apps/dbus with USE=\"qt3\"."
		die "Please reemerge sys-apps/dbus with USE=\"qt3\"."
	fi

	kdesvn-source_pkg_setup
}

src_unpack() {
        kdesvn-source_src_unpack
        #  FIXME - disable broken tests
        sed -i -e "s:TESTS =.*:TESTS =:" ${S}/kioslave/smtp/Makefile.am || die "sed failed"
        sed -i -e "s:TESTS =.*:TESTS =:" ${S}/kioslave/trash/Makefile.am || die "sed failed"
}

src_compile() {
        myconf="$myconf `use_with ldap` `use_with samba` `use_with hal` `use_with openexr`"
        kdesvn-meta_src_compile
}

