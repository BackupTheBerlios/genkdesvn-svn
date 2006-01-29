# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KSCM_ROOT=trunk/kdenonbeta
inherit kde kde-source

KEYWORDS="~x86 ~ppc ~sparc ~amd64"
DESCRIPTION="KMobiletools is a KDE-based application that allows to control
mobile phones with your PC."
HOMEPAGE="http://kmobiletools.berlios.de/"
LICENSE="GPL-2"

IUSE="gammu kde kitchensync moto4lin"

DEPEND="gammu? (app-mobilephone/gammu)
		kde? (>=kde-base/kontact-7)
		kitchensync? (kde-base/kitchensync)
		moto4lin? (app-mobilephone/moto4lin)"


need-kde 3.2
