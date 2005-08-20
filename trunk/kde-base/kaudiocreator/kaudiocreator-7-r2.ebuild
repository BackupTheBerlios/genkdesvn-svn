# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE CD ripper and audio encoder frontend"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="encode flac mp3 vorbis"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcddb)
    media-sound/cdparanoia"

# External encoders used - no optional compile-time support
RDEPEND="$DEPEND
    $(deprange $PV $MAXKDEVER kde-base/kdemultimedia-kioslaves)
    encode? ( vorbis? ( media-sound/vorbis-tools )
              flac? ( media-libs/flac )
              mp3? ( media-sound/lame ) )"

KMCOPYLIB="libkcddb libkcddb"
KMCOMPILEONLY="kscd"
KMCFGONLY="libkcddb"
KMUIONLY="libkcddb"
