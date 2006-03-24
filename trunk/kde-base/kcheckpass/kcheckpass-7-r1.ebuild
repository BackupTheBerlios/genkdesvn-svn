# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils flag-o-matic kdesvn-source

DESCRIPTION="KDE pam client that allows you to auth as a specified user without actually doing anything as that user"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="pam"
DEPEND="pam? ( sys-libs/pam >=kde-base/kdebase-pam-5 ) !pam? ( sys-apps/shadow )"

#src_unpack() {
#	unpack "kdebase-${PV}-patches-1.tar.bz2"
#	kdesvn-meta_src_unpack

#	epatch "${WORKDIR}/patches/${P}-bindnow.patch"
#}

src_compile() {
	myconf="$(use_with pam)"

#	export BINDNOW_FLAGS="$(bindnow-flags)"
	kdesvn-meta_src_compile
}

