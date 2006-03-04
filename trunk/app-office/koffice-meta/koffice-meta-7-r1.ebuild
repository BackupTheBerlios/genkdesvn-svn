# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MAXKOFFICEVER=$PV

inherit kdesvn-functions
DESCRIPTION="koffice - merge this to pull in all koffice-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/karbon)
	$(deprange $PV $MAXKOFFICEVER app-office/kchart)
	$(deprange $PV $MAXKOFFICEVER app-office/kformula)
	$(deprange $PV $MAXKOFFICEVER app-office/kivio)
	$(deprange $PV $MAXKOFFICEVER app-office/koffice-data)
	$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	$(deprange $PV $MAXKOFFICEVER app-office/koshell)
	$(deprange $PV $MAXKOFFICEVER app-office/kpresenter)
	$(deprange $PV $MAXKOFFICEVER app-office/kspread)
	$(deprange $PV $MAXKOFFICEVER app-office/kugar)
	$(deprange $PV $MAXKOFFICEVER app-office/kexi)
	$(deprange $PV $MAXKOFFICEVER app-office/krita)
	$(deprange $PV $MAXKOFFICEVER app-office/kplato)
	$(deprange $PV $MAXKOFFICEVER app-office/kword)"
