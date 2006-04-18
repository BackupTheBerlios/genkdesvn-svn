# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=security
KSCM_SUBDIR=pwmanager
inherit kdesvn kdesvn-source

need-kde 3

DESCRIPTION="Password manager for KDE supporting chipcard access and encryption."
HOMEPAGE="http://passwordmanager.sourceforge.net"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 hppa"
IUSE="smartcard"

DEPEND="smartcard? ( sys-libs/libchipcard )
	sys-libs/zlib
	app-arch/bzip2"


src_compile() {
	local myconf="--enable-kwallet"

	if use smartcard; then
		myconf="${myconf} --enable-pwmanager-smartcard"

		if has_version "=sys-libs/libchipcard-0.9*"; then
			myconf="${myconf} --enable-pwmanager-libchipcard1"
		else
			myconf="${myconf} --disable-pwmanager-libchipcard1"
		fi

		if has_version ">=sys-libs/libchipcard-1.9"; then
			myconf="${myconf} --enable-pwmanager-libchipcard2"
		else
			myconf="${myconf} --disable-pwmanager-libchipcard2"
		fi
	else
		myconf="${myconf} --disable-pwmanager-smartcard"
	fi

	kdesvn_src_compile
}

