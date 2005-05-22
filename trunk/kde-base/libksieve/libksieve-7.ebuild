# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils kde-source

DESCRIPTION="library enable support for sieve (imap server-side filtering standard) in kde apps, used by kmail"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

