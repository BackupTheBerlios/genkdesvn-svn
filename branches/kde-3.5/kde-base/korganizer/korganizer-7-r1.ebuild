# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="A Personal Organizer for KDE"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkpimexchange)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/libkpimidentities)
$(deprange $PV $MAXKDEVER kde-base/ktnef)
$(deprange $PV $MAXKDEVER kde-base/kdepim-kresources)
$(deprange $PV $MAXKDEVER kde-base/kontact)
$(deprange $PV $MAXKDEVER kde-base/libkholidays)"

KMCOPYLIB="
	libkdepim libkdepim
	libkpimexchange libkpimexchange
	libkcal libkcal
	libkpimidentities libkpimidentities
	libktnef ktnef/lib
	libkcal_resourceremote kresources/remote
	libkpinterfaces kontact/interfaces
	libkholidays libkholidays"
KMEXTRACTONLY="
	libkpimexchange/
	libkcal/
	libkdepim/
	libkpimidentities/
	mimelib/
	ktnef/
	certmanager/lib/
	kresources/remote/
	kmail/kmailIface.h
	kontact/interfaces/
	libkholidays"
KMCOMPILEONLY="
	libemailfunctions"

# They seems to be used only by korganizer
KMEXTRA="
	kgantt
	kdgantt
	kontact/plugins/korganizer/" # We add here the kontact's plugin instead of compiling it with kontact because it needs a lot of korganizer deps.