# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KSCM_I18N_PO="kicker appletproxy clockapplet extensionproxy naughtyapplet"
inherit kde-meta eutils kde-source

DESCRIPTION="KDE panel housing varous applets"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
PATCHES="$FILESDIR/applets-configure.in.in.diff
		$FILESDIR/qslider-X11-define-conflict.diff"

OLDDEPEND="~kde-base/libkonq-3.3.1"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)
$(deprange $PV $MAXKDEVER kde-base/kdebase-data)"

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY="libkonq
	kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"
