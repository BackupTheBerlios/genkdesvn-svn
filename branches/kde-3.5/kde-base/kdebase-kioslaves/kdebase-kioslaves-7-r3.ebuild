# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KMNAME=kdebase
KMMODULE=kioslave
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kioslave: the kde VFS framework - kioslave plugins present a filesystem-like view of arbitrary data"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="hal ldap openexr samba"
DEPEND="ldap? ( net-nds/openldap )
	openexr? ( media-libs/openexr )
	samba? ( >=net-fs/samba-3.0.1 )
	>=dev-libs/cyrus-sasl-2
	hal? ( >=sys-apps/dbus-0.33
	       =sys-apps/hal-0.5* 
		   sys-apps/pmount )"
RDEPEND="${DEPEND}
	$(deprange $PV $MAXKDEVER kde-base/kdialog)" # for the kdeeject script used by the devices/mounthelper ioslave

myconf="$myconf `use_with ldap` `use_with samba` `use_with hal` `use_with openexr`"
