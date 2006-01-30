# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# Original Author:
#	Dan Armak <danarmak@gentoo.org>
#
# Modifications by:
#	Mario Tanev <mtanev@csua.berkeley.edu>
#	Stefan Vunckx <stefan.vunckx@skynet.be>
#
# $Header: $

MAXKDEVER=$PV

inherit kde-meta-parent kdesvn-functions eutils

ECLASS="kdesvn-meta-parent"
INHERITED="$INHERITED $ECLASS"

RDEPEND=""