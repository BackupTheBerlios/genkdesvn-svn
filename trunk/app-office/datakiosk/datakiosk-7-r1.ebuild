# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=extragear
KSCM_MODULE=office
KSCM_SUBDIR=datakiosk
inherit kdesvn kdesvn-source

DESCRIPTION="DataKiosk is a JuK-like database interface tool for generic SQL databases."
HOMEPAGE="http://extragear.kde.org/apps/datakiosk/"
LICENSE="GPL-2"

SLOT="${PV}"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="app-office/kugar"

need-kde 3.3
