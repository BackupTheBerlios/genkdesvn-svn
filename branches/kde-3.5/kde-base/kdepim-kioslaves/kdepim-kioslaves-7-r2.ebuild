# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
KMMODULE=kioslaves
MAXKDEVER=$PV
KMNODOCS="true"
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="kioslaves from kdepim package"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="sasl"
DEPEND="sasl? ( >=dev-libs/cyrus-sasl-2 )
		$(deprange $PV $MAXKDEVER kde-base/libkmime)"

myconf="$myconf $(use_with sasl)"

KMCOPYLIB="libkmime libkmime/"
KMEXTRACTONLY="libkmime/"
KMCOMPILEONLY="libemailfunctions"
