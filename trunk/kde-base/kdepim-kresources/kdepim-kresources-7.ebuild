# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
KMMODULE=kresources
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE PIM groupware plugin collection"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/libkpimexchange)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/libkpgp)
$(deprange $PV $MAXKDEVER kde-base/libkdenetwork)
$(deprange $PV $MAXKDEVER kde-base/akregator)
$(deprange $PV $MAXKDEVER kde-base/kode)
	>=app-crypt/gpgme-0.4.0"
KMCOPYLIB="
	libkcal libkcal
	libkpimexchange libkpimexchange
	libkdepim libkdepim
	libqgpgme libkdenetwork/qgpgme"
KMEXTRACTONLY="
	libkcal/
	libkpimexchange/
	libkdepim/
	korganizer/
	kmail/kmailicalIface.h
	libkdenetwork/
	libemailfunctions/ "
KMCOMPILEONLY="
	libkcal/libical/src/libical/
	libkcal/libical/src/libicalss/
	certmanager/
	libkdenetwork/gpgmepp
	libkpgp/
	knotes/
	akregator/src/librss
	kaddressbook/
	libemailfunctions/ "

PATCHES="$FILESDIR/use-installed-kode.diff $FILESDIR/icaltimezone.c.diff"

