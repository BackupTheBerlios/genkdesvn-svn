# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/qt3.eclass,v 1.7 2005/07/25 14:53:25 caleb Exp $
#
# Original Author:
# 	Caleb Tennis <caleb@gentoo.org>
#
# Modifications by:
#	Mario Tanev <mtanev@csua.berkeley.edu>
#	Stefan Vunckx <stefan.vunckx@skynet.be>
#
# Purpose:
#
# This eclass is simple.  Inherit it, and in your depend, do something like this:
#
# DEPEND="$(qt_min_version 3.1)"
#
# and it handles the rest for you
#
# Caveats:
#
# Currently, the ebuild assumes that a minimum version of Qt3 is NOT satisfied by Qt4

inherit versionator

if [[ -z $QTDIR ]]; then
	[ -d ${ROOT}/var/db/pkg/x11-libs/qt-7* ] && QTDIR="/usr/qt/devel"
fi

QTPKG="x11-libs/qt-"
QT3MAJORVERSIONS="3.3 3.2 3.1 3.0"
QT3VERSIONS="3.3.6 3.3.5-r1 3.3.5 3.3.4-r9 3.3.4-r8 3.3.4-r7 3.3.4-r6 3.3.4-r5 3.3.4-r4 3.3.4-r3 3.3.4-r2 3.3.4-r1 3.3.4 3.3.3-r3 3.3.3-r2 3.3.3-r1 3.3.3 3.3.2 3.3.1-r2 3.3.1-r1 3.3.1 3.3.0-r1 3.3.0 3.2.3-r1 3.2.3 3.2.2-r1 3.2.2 3.2.1-r2 3.2.1-r1 3.2.1 3.2.0 3.1.2-r4 3.1.2-r3 3.1.2-r2 3.1.2-r1 3.1.2 3.1.1-r2 3.1.1-r1 3.1.1 3.1.0-r3 3.1.0-r2 3.1.0-r1 3.1.0"

addwrite "${QTDIR}/etc/settings"
addpredict "${QTDIR}/etc/settings"

qt_min_version() {
	qt3_min_version "$@"
}

qt3_min_version() {
	echo "|| ( "
	qt3_min_version_list "$@"
	echo " )"
}

qt3_min_version_list() {
	local MINVER="$1"
	local VERSIONS=""

	VERSIONS="|| ( =${QTPKG}3* =${QTPKG}7* )"

	echo "$VERSIONS"
}
