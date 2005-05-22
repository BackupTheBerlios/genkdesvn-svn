# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="The KDE desktop"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

DEPEND="$DEPEND
$(deprange $PV $MAXKDEVER kde-base/libkonq)
$(deprange $PV $MAXKDEVER kde-base/kdm)
$(deprange $PV $MAXKDEVER kde-base/kcontrol)"
	# Requires the desktop background settings module, 
	# so until we separate the kcontrol modules into separate ebuilds :-),
	# there's a dep here
RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kcheckpass)
	sys-apps/eject"

KMCOPYLIB="libkonq libkonq/"
KMEXTRACTONLY="kcheckpass/kcheckpass.h
	libkonq/
	kdm/kfrontend/themer/
	kioslave/thumbnail/configure.in.in" # for the HAVE_LIBART test
KMCOMPILEONLY="kcontrol/background
	kdmlib/"
KMNODOCS=true

src_install() {
	# ugly, needs fixing: don't install kcontrol/background
	kde-meta_src_install

	rmdir ${D}/${PREFIX}/share/templates/.source/emptydir
}

pkg_postinst() {
	mkdir -p ${PREFIX}/share/templates/.source/emptydir
}
