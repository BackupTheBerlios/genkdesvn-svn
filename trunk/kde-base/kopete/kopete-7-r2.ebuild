# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdenetwork
KMNOMODULE=true
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"

ESCM_EXTERNALS="branches/work/kopete/dev-0.12/kopete"
KMEXTERNAL="kopete"

inherit kde-meta eutils kde-source

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="sametime slp ssl xmms"

DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	>=dev-libs/glib-2
	sametime? ( >=net-libs/meanwhile-0.4.2 )
	slp? ( net-libs/openslp )
	xmms? ( media-sound/xmms )"
RDEPEND="$DEPEND
	ssl? ( app-crypt/qca-tls )
	>=sys-kernel/linux-headers-2.6.11"

src_compile() {
    # External libgadu support - doesn't work, kopete requires a specific development snapshot of libgadu.
    # Maybe we can enable it in the future.
    # The nowlistening plugin has xmms support.
	local myconf="$(use_enable sametime sametime-plugin)
                  $(use_with xmms) --without-external-libgadu"

	kde-meta_src_compile
}

pkg_postinst()
{	
	subversion_pkg_postinst
	einfo
	einfo "Please be aware: This is NOT kopete from KDE 3.5 itself !"
	einfo "This is a newer branch to continue work after KDE 3.5."
	einfo
	einfo "If you want to keep building kopete from the KDE 3.5 branch,"
	einfo "you can mask this package:"
	einfo "echo \"kde-base/kopete-7-r2\" >> /etc/portage/package.mask"
	einfo "All changes in 3.5 branch kopete will be adjusted in r1 ebuild !"
	einfo
	einfo "The kopete could not wait until KDE4, so instead they started"
	einfo "a new branch for kopete development as trunk/ is reserved for"
	einfo "KDE4 development. This is however still based on KDE 3.5 but"
	einfo "it wont belong to an official KDE release."
	einfo
	einfo "KDE 3.5.x should only contain bugfixes."
	echo
}