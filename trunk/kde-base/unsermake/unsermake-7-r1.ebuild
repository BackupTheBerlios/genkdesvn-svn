# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=trunk/kdenonbeta/
ESCM_DEEPITEMS=$KSCM_ROOT$PN
inherit python kde-source

IUSE=""
DESCRIPTION="Unsermake - Advanced KDE build system"
HOMEPAGE="http://wiki.kde.org/tiki-index.php?page=unsermake"
KEYWORDS="~x86 ~ppc ~amd64"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-lang/python-2.2
	!<kde-base/kdelibs-3.4"
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
	python_version
	UNSERMAKEDIR=/usr/lib/python${PYVER}/site-packages/unsermake/
	dodir ${UNSERMAKEDIR}
	cp -a ${S}/*.py ${D}/${UNSERMAKEDIR}
	cp -a ${S}/*.um ${D}/${UNSERMAKEDIR}
	cp -a ${S}/unsermake ${D}/${UNSERMAKEDIR}
	dodir /usr/bin
	dosym ${UNSERMAKEDIR}/unsermake /usr/bin/unsermake
}

pkg_postinst()
{	
	subversion_pkg_postinst
	einfo
	einfo "To enable kde builds with unsermake, add unsermake to your FEATURES in /etc/make.conf"
	einfo
	einfo "To manually build KDE applications with unsermake, call unsermake instead of make as follows:"
	einfo "make -f Makefile.cvs"
	einfo "./configure"
	einfo "unsermake"
	einfo
	einfo "Unsermake builds are highly experimental; use at your own risk"
}
