# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKOFFICEVER=7
KMNAME=koffice
KMMODULE=lib
inherit kde-meta eutils kde-source

DESCRIPTION="shared koffice libraries"
HOMEPAGE="http://www.koffice.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~ppc amd64"

IUSE=""
SLOT="$PV"

DEPEND="dev-util/pkgconfig"

RDEPEND="$DEPEND $(deprange $PV $MAXKOFFICEVER app-office/koffice-data)"

KMEXTRA="
	interfaces/
	plugins/
	tools/
	filters/olefilters/
	filters/xsltfilter/
	filters/generic_wrapper/
	kounavail/
	doc/koffice
	doc/thesaurus"

KMEXTRACTONLY="
	kchart/kdchart"

src_unpack() {
	kde-source_src_unpack

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' $S/lib/Makefile.am

	kde-meta_src_unpack makefiles
}

need-kde 3.1

