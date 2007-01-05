# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMMODULE=lib
KMNODOCS="true"
inherit kofficesvn eutils

DESCRIPTION="Shared KOffice libraries."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-data)
	virtual/python
	dev-lang/ruby"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

KMEXTRA="interfaces/
	plugins/
	tools/
	filters/olefilters/
	filters/xsltfilter/
	filters/generic_wrapper/
	kounavail/
	doc/koffice/
	doc/thesaurus/"
#	doc/api/" broken

KMEXTRACTONLY="
	kchart/kdchart/"

src_unpack() {
	kofficesvn_src_unpack

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' "${S}/lib/Makefile.am"

	kdesvn-meta_src_unpack makefiles
}

src_compile() {
	local myconf="--enable-scripting --with-pythonfir=${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages"
	kofficesvn_src_compile
	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kofficesvn_src_install
	if use doc; then
		make DESTDIR="${D}" install-apidox || die
	fi
}
