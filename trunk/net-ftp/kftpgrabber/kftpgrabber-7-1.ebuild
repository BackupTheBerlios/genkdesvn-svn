# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=extragear
KSCM_MODULE=network
KSCM_SUBDIR=kftpgrabber
inherit kdesvn kdesvn-source

DESCRIPTION="A graphical FTP client for KDE."
HOMEPAGE="http://kftpgrabber.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-libs/openssl"
	
need-kde 3.3

src_unpack() {
	kdesvn_src_unpack

	epatch "${FILESDIR}/${PN}-uic.patch"
	epatch "${FILESDIR}/${PN}-gcc4.patch"
	epatch "${FILESDIR}/${PN}-gcc41.patch"
}

