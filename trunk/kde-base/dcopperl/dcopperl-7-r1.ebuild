# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebindings
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit perl-module kdesvn-meta kdesvn-source

DESCRIPTION="Perl bindings for DCOP"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="dev-lang/perl"
PATCHES="$FILESDIR/no-gtk-glib-check.diff
	$FILESDIR/installdirs-vendor.diff" # install into vendor_perl, not into site_perl - bug 42819

# Because this installs into /usr/lib/perl5/..., it doesn't have SLOT=X.Y like the rest of KDE,
# and it installs into /usr entirely
SLOT="0"
src_compile() {
	kdesvn_src_compile myconf
	myconf="$myconf --prefix=/usr"
	kdesvn_src_compile configure make
}

src_install() {
	kdesvn-meta_src_install
	fixlocalpod
}

# note uses perl-module_pkg_postinst for more local.pod magic, was bug 83520
pkg_postinst() {
	subversion_pkg_postinst
	perl-module_pkg_postinst
}
