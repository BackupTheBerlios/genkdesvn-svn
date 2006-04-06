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

#PATCHES="${FILESDIR}/${PN}-uic.patch"
#PATCHES="${PATCHES} ${FILESDIR}/${PN}-gcc4.patch"
#PATCHES="${PATCHES} ${FILESDIR}/${PN}-gcc41.patch"

