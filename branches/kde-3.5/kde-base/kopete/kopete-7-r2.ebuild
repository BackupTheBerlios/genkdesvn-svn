# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdenetwork
KMNOMODULE=true
#MAXKDEVER=$PV
#KM_DEPRANGE="$PV $MAXKDEVER"

ESCM_EXTERNALS="branches/kopete/0.12/kopete"
ESCM_CHECKITEMS="${ESCM_CHECKITEMS} ${ESCM_EXTERNALS}"
KMEXTERNAL="kopete"

inherit kde-meta eutils kde-source

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ilbc jingle sametime slp ssl xmms"

DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	>=dev-libs/glib-2
	ilbc? ( dev-libs/ilbc-rfc3951 )
	jingle? ( media-libs/speex 
		dev-libs/expat
		>=net-libs/ortp-0.7.1
	)
	sametime? ( >=net-libs/meanwhile-0.4.2 )
	slp? ( net-libs/openslp )
	xmms? ( media-sound/xmms )"
RDEPEND="$DEPEND
	ssl? ( app-crypt/qca-tls )
	>=sys-kernel/linux-headers-2.6.11"

PATCHES="$FILESDIR/gcc4.patch"

need-kde 3.5

src_compile() {
    # External libgadu support - doesn't work, kopete requires a specific development snapshot of libgadu.
    # Maybe we can enable it in the future.
    # The nowlistening plugin has xmms support.
	local myconf="$(use_enable sametime sametime-plugin)
				  $(use_enable jingle)
                  $(use_with xmms) --without-external-libgadu"

	if use ilbc; then
		myconf="${myconf} --with-ilbc=/usr"
	fi

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
	einfo "The kopete devs could not wait until KDE4, so instead they started"
	einfo "a new branch for kopete development as trunk/ is reserved for"
	einfo "KDE4 development. This is however still based on KDE 3.5 but"
	einfo "it wont belong to an official KDE release."
	einfo
	einfo "KDE 3.5.x should only contain bugfixes."
	echo
}

# these files are not generated through ui or kcfgc
KMHEADERS=(
	'kopete/libkopete clientiface_stub.h'
	'kopete/protocols/jabber/libiris/iris/xmpp-core securestream.moc'
)

KMHEADERDIRS=(
	'kopete/libkopete .kcfgc'
	'kopete/libkopete/ui .ui'
	'kopete/kopete/addaccountwizard .ui'
	'kopete/kopete/addcontactwizard .ui'
	'kopete/kopete/contactlist .ui'
	'kopete/kopete/config/accounts .ui'
	'kopete/kopete/config/behavior .ui'
	'kopete/kopete/config/appearance .ui'
	'kopete/kopete/config/identity .ui .kcfgc'
	'kopete/kopete/config/avdevice .ui'
	'kopete/protocols/testbed .ui'
	'kopete/protocols/groupwise/ui .ui'
	'kopete/protocols/msn/ui .ui'
	'kopete/protocols/msn/config .ui'
	'kopete/protocols/irc/ui .ui'
	'kopete/protocols/oscar .ui'
	'kopete/protocols/oscar/aim/ui .ui'
	'kopete/protocols/oscar/icq/ui .ui'
	'kopete/protocols/yahoo/ui .ui'
	'kopete/protocols/jabber/ui .ui'
	'kopete/protocols/jabber/jingle .ui'
	'kopete/plugins/latex .ui .kcfgc'
	'kopete/plugins/autoreplace .ui'
	'kopete/plugins/history .ui .kcfgc'
	'kopete/plugins/cryptography .ui'
	'kopete/plugins/translator .ui'
	'kopete/plugins/nowlistening .ui .kcfgc'
	'kopete/plugins/webpresence .ui'
	'kopete/plugins/texteffect .ui'
	'kopete/plugins/highlight .ui'
	'kopete/plugins/alias .ui'
	'kopete/plugins/netmeeting .ui'
	'kopete/plugins/addbookmarks .ui'
	'kopete/plugins/statistics .ui'
)