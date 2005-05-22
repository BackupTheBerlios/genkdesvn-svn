# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebindings
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit perl-module kde-meta kde-source

DESCRIPTION="Perl bindings for DCOP"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="dev-lang/perl"
PATCHES="$FILESDIR/no-gtk-glib-check.diff
	$FILESDIR/installdirs-vendor.diff" # install into vendor_perl, not into site_perl - bug 42819

# Because this installs into /usr/lib/perl5/..., it doesn't have SLOT=X.Y like the rest of KDE,
# and it installs into /usr entirely
SLOT="0"
src_compile() {
	kde_src_compile myconf
	myconf="$myconf --prefix=/usr"
	kde_src_compile configure make
}

src_install() {
	kde-meta_src_install
	fixlocalpod
}

# note uses perl-module_pkg_postinst for more local.pod magic, was bug 83520
