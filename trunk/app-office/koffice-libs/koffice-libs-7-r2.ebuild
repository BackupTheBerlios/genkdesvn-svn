# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MAXKOFFICEVER=7
KMNAME=koffice
KMMODULE=lib
KMNODOCS="true"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="Shared KOffice libraries."
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc"
SLOT="$PV"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-data)
    virtual/python
    dev-lang/ruby"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

KMEXTRA="
	interfaces/
	plugins/
	tools/
    filters/olefilters/
	filters/xsltfilter/
	filters/generic_wrapper/
	kounavail/
	doc/api
	doc/koffice/
	doc/thesaurus/"

KMEXTRACTONLY="
	kexi/Makefile.global
	kchart/kdchart/"

need-kdesvn 3.4

src_unpack() {
	kdesvn-source_src_unpack unpack

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' $S/lib/Makefile.am

	kdesvn-meta_src_unpack makefiles
}

src_compile() {
	local myconf="--enable-scripting --with-pythonfir=${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages"
	kdesvn-meta_src_compile
	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kdesvn-meta_src_install
	if use doc; then
		make DESTDIR=${D} install-apidox || die
	fi
}

