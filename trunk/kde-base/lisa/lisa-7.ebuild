# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
KMMODULE=lanbrowsing
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE Lan Information Server - allows KDE desktops to share information over a network"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
KMEXTRA="doc/kcontrol/lanbrowser"

src_install() {
	kde-meta_src_install

	chmod u+s ${D}/${KDEDIR}/bin/reslisa

	# lisa, reslisa initscripts
	dodir /etc/init.d
	sed -e "s:_KDEDIR_:${KDEDIR}:g" ${FILESDIR}/lisa > ${D}/etc/init.d/lisa
	sed -e "s:_KDEDIR_:${KDEDIR}:g" ${FILESDIR}/reslisa > ${D}/etc/init.d/reslisa
	chmod +x ${D}/etc/init.d/*

	insinto /etc/conf.d
	newins ${FILESDIR}/lisa.conf lisa
	newins ${FILESDIR}/reslisa.conf reslisa

	for x in /etc/lisarc /etc/reslisarc; do
		echo '# Default lisa/reslisa configfile' > $D/$x
	done
}
