# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
KMMODULE=kresources
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE PIM groupware plugin collection"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/libkpimexchange)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/kaddressbook)
$(deprange $PV $MAXKDEVER kde-base/kode)
$(deprange $PV $MAXKDEVER kde-base/ktnef)
    dev-libs/libical
    >=app-crypt/gpgme-1.0.2"
KMCOPYLIB="
	libkcal libkcal
	libkpimexchange libkpimexchange
	libkdepim libkdepim
    libkabinterfaces kaddressbook/interfaces/
	libktnef ktnef/lib/"

KMEXTRACTONLY="
    korganizer/
    libkpimexchange/configure.in.in
    libkdepim/
    kmail/kmailicalIface.h
    libkpimexchange/"

KMCOMPILEONLY="
	libemailfunctions/
    knotes/
    libkcal/
    kaddressbook/common/
    "

PATCHES="$FILESDIR/use-installed-kode.diff"

KMTARGETSONLY=(
	'knotes libknotesresources.la'
	'libkcal/libical/src/libical ical.h')

src_compile() {
	export DO_NOT_COMPILE="knotes libkcal"

	kdesvn-meta_src_compile myconf configure

	cd knotes/; make libknotesresources.la
	cd $S/libkcal/libical/src/libical; make ical.h

	kdesvn-meta_src_compile make
}

