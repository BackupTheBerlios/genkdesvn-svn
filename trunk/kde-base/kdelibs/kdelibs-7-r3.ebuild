# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kdesvn flag-o-matic eutils multilib kdesvn-source
set-kdedir

DESCRIPTION="KDE libraries needed by all kde programs"
HOMEPAGE="http://www.kde.org/"
SRC_URI=""
LICENSE="GPL-2 LGPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="acl alsa arts cups doc jpeg2k kerberos openexr spell ssl tiff zeroconf"

# kde.eclass has kdelibs in DEPEND, and we can't have that in here.
# so we recreate the entire DEPEND from scratch.
RDEPEND="$(qt_min_version 3.3.3)
	arts? ( ~kde-base/arts-${PV} )
	app-arch/bzip2
	>=media-libs/freetype-2
	media-libs/fontconfig
	>=dev-libs/libxslt-1.1.4
	>=dev-libs/libxml2-2.6.6
	>=dev-libs/libpcre-4.2
	media-libs/libart_lgpl
	net-dns/libidn
	virtual/utempter
	acl? ( kernel_linux? ( sys-apps/acl ) )
	ssl? ( >=dev-libs/openssl-0.9.7d )
	alsa? ( media-libs/alsa-lib )
	cups? ( >=net-print/cups-1.1.19 )
	tiff? ( media-libs/tiff )
	kerberos? ( virtual/krb5 )
	jpeg2k? ( media-libs/jasper )
	openexr? ( >=media-libs/openexr-1.2 )
	spell? ( || ( app-text/aspell
	              app-text/ispell ) )
	zeroconf? ( net-misc/mDNSResponder )
	virtual/fam
	virtual/ghostscript"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	sys-devel/gettext
	dev-util/pkgconfig"

src_unpack() {
	kdesvn-source_src_unpack
	#! use arts && cd ${S} && epatch ${FILESDIR}/${P}-knotify-noarts.patch
}

src_compile() {
	# hspell is disabled because it requires version 0.9 of hspell that
	# is not in portage yet; leaving it to auto-detection tries to use it
	# and then fails because of missing required functions.

	# apidox is broken with unsermake
	if use doc; then
		if [ -z "$UNSERMAKE" ]; then 
			echo
			ewarn "Apidox generation is broken with unsermake in 3.5 branch,"
			ewarn "so unsermake is being disabled for building kdelibs."
			ewarn "If you dont want this, remove the doc use flag."
			echo 

			UNSERMAKE="no"
		fi
	fi

	myconf="--with-distribution=Gentoo
	        --enable-libfam $(use_enable kernel_linux dnotify)
	        --with-libart --with-libidn --with-utempter
	        $(use_with alsa) $(use_with arts) 
			$(use_with ssl) $(use_with acl)
	        $(use_with kerberos gssapi) $(use_with tiff)
	        $(use_with jpeg2k jasper) $(use_with openexr)
	        $(use_enable cups) $(use_enable zeroconf dnssd)
			--without-hspell"

	if use spell && has_version app-text/aspell; then
		myconf="${myconf} --with-aspell"
	else
		myconf="${myconf} --without-aspell"
	fi

	myconf="${myconf} --disable-fast-malloc"
	#use x86 && myconf="${myconf} --enable-fast-malloc=full"

	# fix bug 58179, bug 85593
	# kdelibs-3.4.0 needed -fno-gcse; 3.4.1 needs -mminimal-toc; this needs a
	# closer look... - corsair
	use ppc64 && append-flags "-mminimal-toc"

	export BINDNOW_FLAGS="$(bindnow-flags)"

	kdesvn_src_compile

	#if ! use arts; then
	#	cd arts/knotify
	#	make || die
	#	cd ${OLDPWD}
	#fi

	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kdesvn_src_install

	#if ! use arts; then
	#	cd arts/knotify
	#	make DESTDIR="${D}" install || die
	#	cd ${OLDPWD}
	#fi

	if use doc; then
		make DESTDIR="${D}" install-apidox || die
	fi

	# needed to fix lib64 issues on amd64, see bug #45669
	#use amd64 && ln -s ${KDEDIR}/lib ${D}/${KDEDIR}/lib64

	# Needed to create lib -> lib64 symlink for amd64 2005.0 profile
	if [ "${SYMLINK_LIB}" = "yes" ]; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) ${KDEDIR}/lib
	fi

	if ! use arts ; then
		dodir /etc/env.d

		# List all the multilib libdirs
		local libdirs
		for libdir in $(get_all_libdirs); do
			libdirs="${libdirs}:${PREFIX}/${libdir}"
		done

		cat <<EOF > ${D}/etc/env.d/25kdepaths-${SLOT} # number goes down with version upgrade
PATH=${PREFIX}/bin
ROOTPATH=${PREFIX}/sbin:${PREFIX}/bin
LDPATH=${libdirs:1}
CONFIG_PROTECT="${PREFIX}/share/config ${PREFIX}/env ${PREFIX}/shutdown"
EOF
	fi

}

pkg_postinst() {
	if use zeroconf; then
		echo 
		einfo "To make zeroconf support available in KDE"
		einfo "make sure that the 'mdnsd' daemon is running."
		einfo "Make sure also that multicast dns lookups are"
		einfo "enabled by editing the 'hosts:' line in "
		einfo "/etc/nsswitch.conf to include 'mdns', e.g.:"
		einfo "hosts: files mdns dns"
		echo 
	fi
}
