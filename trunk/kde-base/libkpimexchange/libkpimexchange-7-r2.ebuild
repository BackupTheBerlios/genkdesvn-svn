# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE PIM exchange library"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkcal)"

KMCOPYLIB="libkcal libkcal"
KMEXTRACTONLY="
	libkcal/"

KMCOMPILEONLY="
    libkcal/libical/src/libical/
    libkcal/libical/src/libicalss/"

#KMTARGETSONLY=(
#	'libkcal/libical/src/libical ical.h'
#	'libkcal/libical/src/libicalss icalss.h')

