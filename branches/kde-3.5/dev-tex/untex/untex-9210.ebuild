# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_P="${PN}_${PV}"
DEB_PL="10"

DESCRIPTION="Converts (la)tex files to text"
HOMEPAGE="http://packages.debian.org/stable/tex/untex"
SRC_URI="mirror://debian/pool/main/u/untex/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/u/untex/${MY_P}-${DEB_PL}.diff.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc ~alpha ~sparc ~ia64"
IUSE=""

DEPEND="virtual/libc"

S="${S}.orig"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${MY_P}-${DEB_PL}.diff
}

src_compile() {
	$(tc-getCC) untex.c -o ${PN} ${CFLAGS} -lresolv -lm || die "Compile failed"
}

src_install() {
	dosbin untex || die "dosbin failed"
}
