# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source flag-o-matic

DESCRIPTION="KDE multi-protocol IM client"
HOMEPAGE="http://kopete.kde.org/"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="jingle sametime ssl xscreensaver slp kernel_linux latex crypt
          winpopup sms irc yahoo gadu groupwise netmeeting statistics autoreplace
          connectionstatus contactnotes translator webpresence texteffect highlight
          alias autoreplace history nowlistening addbookmarks kdehiddenvisibility reloadingkit"

# The kernel_linux? ( ) conditional dependencies are for webcams, not supported
# on other kernels AFAIK
BOTH_DEPEND="dev-libs/libxslt
        dev-libs/libxml2
        net-dns/libidn
        >=dev-libs/glib-2
        app-crypt/qca
        sametime? ( =net-libs/meanwhile-1.0* )
        jingle? (
                >=media-libs/speex-1.1.6
                dev-libs/expat
                ~net-libs/ortp-0.7.1 )
        || ( (
                x11-libs/libX11
                x11-libs/libXext
                x11-libs/libXrender
                xscreensaver? ( x11-libs/libXScrnSaver )
                ) <virtual/x11-7 )
        kernel_linux? ( virtual/opengl )
        sms? ( app-mobilephone/gsmlib )"

RDEPEND="${BOTH_DEPEND}
        ssl? ( app-crypt/qca-tls )
        !kde-base/kopete
        !kde-base/kdenetwork
        latex? ( virtual/tetex
                media-gfx/imagemagick )
        crypt? ( app-crypt/gnupg )"
#       gnomemeeting is deprecated and ekiga is not yet ~ppc64
#       only needed for calling
#       netmeeting? ( net-im/gnomemeeting )"

DEPEND="${BOTH_DEPEND}
        kernel_linux? ( virtual/os-headers )
        || ( (
                        x11-proto/videoproto
                        kernel_linux? ( x11-libs/libXv )
                        xscreensaver? ( x11-proto/scrnsaverproto )
                ) <virtual/x11-7 )"

if use reloadingkit; then
	PATCHES="${FILESDIR}/reloadingkit-0.2.1.diff"
fi

pkg_setup() {
        if use kernel_linux && ! built_with_use =x11-libs/qt-3* opengl; then
                eerror "To support Video4Linux webcams in this package is required to have"
                eerror "=x11-libs/qt-3* compiled with OpenGL support."
                eerror "Please reemerge =x11-libs/qt-3* with USE=\"opengl\"."
                die "Please reemerge =x11-libs/qt-3* with USE=\"opengl\"."
        fi

        if use reloadingkit; then
                echo
                einfo "Patching Kopete with the "Kopete Reloading Kit" patch as requested. The patch can be found at:"
                einfo "http://www.kde-apps.org/content/show.php?content=49765"
                echo
        fi

	kdesvn-source_pkg_setup
}

kopete_disable() {
        einfo "Disabling $2 $1"
        sed -i -e "s/$2//" "${S}/kopete/$1s/Makefile.am"
}

#pkg_setup() {
#        #kdesvn-meta_src_unpack

#        #epatch "${FILESDIR}/kopete-0.12_alpha1-xscreensaver.patch"
#        # use ekiga instead of gnomemeeting by default
#        #epatch "${FILESDIR}/gnomemeeting-ekiga.patch"

#        #epatch "${FILESDIR}/${P}-icqfix.patch"

#        use latex || kopete_disable plugin latex
#        use crypt || kopete_disable plugin cryptography
#        use netmeeting || kopete_disable plugin netmeeting
#        use statistics || kopete_disable plugin statistics
#        use autoreplace || kopete_disable plugin autoreplace
#        use connectionstatus || kopete_disable plugin connectionstatus
#        use contactnotes || kopete_disable plugin contactnotes
#        use translator || kopete_disable plugin translator
#        use webpresence || kopete_disable plugin webpresence
#        use texteffect || kopete_disable plugin texteffect
#        use highlight || kopete_disable plugin highlight
#        use alias || kopete_disable plugin alias
#        use addbookmarks || kopete_disable plugin addbookmarks
#        use history || kopete_disable plugin history
#        use nowlistening || kopete_disable plugin nowlistening

#        use winpopup || kopete_disable protocol winpopup
#        use gadu || kopete_disable protocol '\$(GADU)'
#        use irc || kopete_disable protocol irc
#        use groupwise || kopete_disable protocol groupwise
#        use yahoo || kopete_disable protocol yahoo

#        rm -f "${S}/configure"

#    kdesvn-source_pkg_setup
#}

src_compile() {
        use latex || kopete_disable plugin latex
        use crypt || kopete_disable plugin cryptography
        use netmeeting || kopete_disable plugin netmeeting
        use statistics || kopete_disable plugin statistics
        use autoreplace || kopete_disable plugin autoreplace
        use connectionstatus || kopete_disable plugin connectionstatus
        use contactnotes || kopete_disable plugin contactnotes
        use translator || kopete_disable plugin translator
        use webpresence || kopete_disable plugin webpresence
        use texteffect || kopete_disable plugin texteffect
        use highlight || kopete_disable plugin highlight
        use alias || kopete_disable plugin alias
        use addbookmarks || kopete_disable plugin addbookmarks
        use history || kopete_disable plugin history
        use nowlistening || kopete_disable plugin nowlistening

        use winpopup || kopete_disable protocol winpopup
        use gadu || kopete_disable protocol '\$(GADU)'
        use irc || kopete_disable protocol irc
        use groupwise || kopete_disable protocol groupwise
        use yahoo || kopete_disable protocol yahoo

        # External libgadu support - doesn't work, kopete requires a specific development snapshot of libgadu.
        # Maybe we can enable it in the future.
        local myconf="$(use_enable jingle)
                $(use_enable sametime sametime-plugin)
                --without-xmms --without-external-libgadu
                $(use_with xscreensaver) $(use_enable sms smsgsm)
                $(use_enable debug testbed)"

	kdesvn_src_compile
}

src_install() {
        kdesvn-meta_src_install

        rm -f "${D}${KDEDIR}"/bin/{stun,relay}server
}
