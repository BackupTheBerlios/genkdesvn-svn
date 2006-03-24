# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

UNSERMAKE=no
KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="The KDE desktop"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="xscreensaver"

DEPEND="$DEPEND
$(deprange $PV $MAXKDEVER kde-base/libkonq)
$(deprange $PV $MAXKDEVER kde-base/kdm)
$(deprange $PV $MAXKDEVER kde-base/kcontrol)
    xscreensaver? ( || ( (
            x11-proto/scrnsaverproto
            ) virtual/x11 )
        )"
	# Requires the desktop background settings module, 
	# so until we separate the kcontrol modules into separate ebuilds :-),
	# there's a dep here
RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kcheckpass)
$(deprange $PV $MAXKDEVER kde-base/kdialog)
    xscreensaver? ( || ( (
            x11-libs/libXScrnSaver
            ) virtual/x11 )
        )"


KMCOPYLIB="libkonq libkonq/"
KMEXTRACTONLY="kcheckpass/kcheckpass.h
	libkonq/
	kdm/kfrontend/themer/
	kioslave/thumbnail/configure.in.in" # for the HAVE_LIBART test
KMCOMPILEONLY="kcontrol/background
	kdmlib/"
KMNODOCS=true

src_compile() {
	myconf="${myconf} $(use_with xscreensaver)"
	kdesvn-meta_src_compile
}


src_install() {
	# ugly, needs fixing: don't install kcontrol/background
	kdesvn-meta_src_install

	rmdir ${D}/${PREFIX}/share/templates/.source/emptydir
}

pkg_postinst() {
	subversion_pkg_postinst
	mkdir -p ${PREFIX}/share/templates/.source/emptydir
}
