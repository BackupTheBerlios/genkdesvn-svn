# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=kdenonbeta
ESCM_DEEPITEMS=kdenonbeta/$PN
inherit kde-source

IUSE=""
DESCRIPTION="Unsermake - Advanced KDE build system"
HOMEPAGE="http://wiki.kde.org/tiki-index.php?page=unsermake"
KEYWORDS="~x86 ~ppc ~amd64"
LICENSE="GPL-2"
SLOT=0

DEPEND=">=dev-lang/python-2.2"
RDEPEND="$DEPEND"

src_unpack()
{

	subversion_src_unpack

}

src_compile()
{
	return
}

src_install()
{
	dodir /usr/kde/unsermake
	cp -a ${S}/* ${D}/usr/kde/unsermake
}

pkg_postinst()
{
	einfo
	einfo "To enable kde builds with unsermake, set the unsermake useflag"
	einfo
	einfo "To manually build KDE applications with unsermake,"
	einfo "you have to add unsermake to your PATH:"
	einfo "export PATH=\"\$PATH:/usr/kde/unsermake\""
	einfo "And then proceed as normal, but instead call unsermake directly"
	einfo "unsermake -f Makefile.cvs"
	einfo "./configure"
	einfo "unsermake"
	einfo
	einfo "Unsermake builds are highly experimental; use at your own risk"
	einfo
}
