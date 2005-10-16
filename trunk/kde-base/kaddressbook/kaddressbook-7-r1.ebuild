# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="The KDE Address Book"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
OLDDEPEND="~kde-base/libkdepim-$PV
	~kde-base/libkcal-$PV
	~kde-base/certmanager-$PV
	~kde-base/libkdenetwork-$PV
	~kde-base/kontact-$PV"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/certmanager)
$(deprange $PV $MAXKDEVER kde-base/libkdenetwork)
$(deprange $PV $MAXKDEVER kde-base/kontact)
$(deprange $PV $MAXKDEVER kde-base/akregator)"

KMCOPYLIB="
	libkdepim libkdepim
	libkcal libkcal
	libkleopatra certmanager/lib/
	libqgpgme libkdenetwork/qgpgme/
	libkpinterfaces kontact/interfaces/"
KMEXTRACTONLY="
	libkdepim/
	libkdenetwork/
	libkcal/
	certmanager/
	kontact/interfaces/
	akregator
	kmail/kmailIface.h"
KMCOMPILEONLY="
	akregator/src/librss"
KMTARGETSONLY=(
	'libkcal/libical/src/libical ical.h'
	'libkcal/libical/src/libicalss icalss.h')
KMEXTRA="
	kabc/
	kfile-plugins/vcf
	kontact/plugins/kaddressbook"

KMHEADERS=( 'kaddressbook/common/ kabprefs_base.h' )

PATCHES="$FILESDIR/icaltimezone.c.diff"
