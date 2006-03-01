# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdenetwork
KMMODULE=lanbrowsing
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true" # there is no doc/lanbrowsing, only doc/lisa !!!
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE Lan Information Server - allows KDE desktops to share information over a network"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
KMEXTRA="doc/kcontrol/lanbrowser
	doc/lisa"

#PATCHES="${FILESDIR}/${PN}-bindnow.patch"

#src_compile() {
#	export BINDNOW_FLAGS="$(bindnow-flags)"
#	kdesvn-meta_src_compile
#}

src_install() {
	kdesvn-meta_src_install

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
