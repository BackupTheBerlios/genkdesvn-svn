# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

UNSERMAKE=no # doc/api is broken
KMMODULE=lib
KMNODOCS="true"
inherit kofficesvn eutils

DESCRIPTION="Shared KOffice libraries."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc python ruby"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-data)"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( virtual/python )
    ruby? ( dev-lang/ruby )"

KMEXTRA="
	interfaces/
	plugins/
	tools/
	filters/xsltfilter/
	filters/generic_wrapper/
	kounavail/
	doc/koffice/
	doc/thesaurus/"
#	doc/api => broken
#	filters/olefilters/ => broken

KMEXTRACTONLY="
	kexi/Makefile.global
	kchart/kdchart/"

src_unpack() {
	kofficesvn_src_unpack

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' $S/lib/Makefile.am

	kdesvn-meta_src_unpack makefiles
}

src_compile() {
	# enable scripting if one of the script USE flags is set
	if use python || use ruby; then
		myconf="$myconf--enable-scripting"
	else
		myconf="$myconf --disable-scripting"
	fi

	# dis/enable python
	use python && myconf="$myconf --with-pythondir=${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages"

	# TODO: 
	# Ruby gets picked up if it's installed so nothing else to do then make it a dep for koffice

	kofficesvn_src_compile
	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kofficesvn_src_install
	if use doc; then
		make DESTDIR=${D} install-apidox || die
	fi
}

