# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=multimedia
KSCM_SUBDIR=amarok
inherit kdesvn eutils flag-o-matic kdesvn-source

DESCRIPTION="Advanced audio player based on KDE framework."
HOMEPAGE="http://amarok.kde.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="aac kde mysql noamazon opengl postgres
visualization ipod ifp real njb mtp musicbrainz"
# kde: enables compilation of the konqueror sidebar plugin

DEPEND="kde? ( || ( kde-base/konqueror kde-base/kdebase ) )
        >=media-libs/xine-lib-1.1.2_pre20060328-r8
        >=media-libs/taglib-1.4
        mysql? ( >=virtual/mysql-4.0 )
        postgres? ( dev-db/postgresql )
        opengl? ( virtual/opengl )
        visualization? ( media-libs/libsdl
                                         =media-plugins/libvisual-plugins-0.4* )
        ipod? ( >=media-libs/libgpod-0.3 )
        aac? ( media-libs/libmp4v2 )
        ifp? ( media-libs/libifp )
        real? ( media-video/realplayer )
        njb? ( >=media-libs/libnjb-2.2.4 )
        mtp? ( media-libs/libmtp )
        musicbrainz? ( media-libs/tunepimp )
        =dev-lang/ruby-1.8*"

RDEPEND="${DEPEND}"

DEPEND="${DEPEND}
        >=dev-util/pkgconfig-0.9.0"

need-kde 3.3

src_compile() {
	append-flags -fno-inline

        # Extra, unsupported engines are forcefully disabled.
        local myconf="$(use_enable mysql) $(use_enable postgres postgresql)
                                  $(use_with opengl) --without-xmms
                                  $(use_with visualization libvisual)
                                  $(use_enable !noamazon amazon)
                                  $(use_with ipod libgpod)
                                  $(use_with aac mp4v2)
                                  $(use_with ifp)
                                  $(use_with real helix)
                                  $(use_with njb libnjb)
                                  $(use_with mtp libmtp)
                                  $(use_with musicbrainz)
                                  --with-xine
                                  --without-mas
                                  --without-nmm"

	kdesvn_src_compile
}

