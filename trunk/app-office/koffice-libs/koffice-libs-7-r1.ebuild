# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MAXKOFFICEVER=7
KMNAME=koffice
KMMODULE=lib
inherit kde-meta eutils kde-source

DESCRIPTION="shared koffice libraries"
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc amd64"

IUSE="doc"
SLOT="$PV"

# unsermake cant handle doc generation, dont know what the problem is
if use doc; then
	UNSERMAKE=no
fi

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-data)"

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
	doc/api/
	doc/koffice/
	doc/thesaurus/"

KMEXTRACTONLY="
	kchart/kdchart/"

need-kde 3.3

src_unpack() {
	kde-source_src_unpack

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' $S/lib/Makefile.am

	kde-meta_src_unpack makefiles
}

src_compile() {
	kde-meta_src_compile

	if use doc; then
		$(make) apidox || die
	fi
}

src_install() {
	kde-meta_src_install

	if use doc; then
		$(make) DESTDIR=${D} install-apidox || die
	fi
}

