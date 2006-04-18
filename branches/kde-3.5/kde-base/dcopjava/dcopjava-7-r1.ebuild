# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE TODO install a jar file rather than a tree of class files, and use java-pkg.eclass,
# in keeping with policy

KMNAME=kdebindings
KMEXTRACTONLY="kdejava/configure.in.in"
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="Java bindings for DCOP"
KEYWORDS="~x86 ~ppc ~amd64" # broken according to upstream - 3.4a1 README
IUSE=""
DEPEND="virtual/jdk"
RDEPEND="virtual/jre"
PATCHES="$FILESDIR/no-gtk-glib-check.diff"


pkg_setup() {
	ewarn "This package is consdered broken by upstream. You're on your own."
	kdesvn-source_pkg_setup
}

src_compile () {
	myconf="$myconf --with-java=`java-config --jdk-home`"
	kdesvn-meta_src_compile
}
