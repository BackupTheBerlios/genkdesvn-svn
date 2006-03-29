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

# must be done before inheriting qt3 eclass
if [[ -z $QTDIR ]]; then
	[ -d ${ROOT}/var/db/pkg/x11-libs/qt-7* ] && QTDIR="/usr/qt/devel"
fi

inherit qt3

QTPKG="${QTPKG}"
QT3MAJORVERSIONS="${QT3MAJORVERSIONS}"
QT3VERSIONS="${QT3VERSIONS}"

qt_min_version() {
    qt-copy_min_version "$@"
}

qt-copy_min_version() {
    echo "|| ( "
    qt-copy_min_version_list "$@"
    echo " )"

}

qt-copy_min_version_list() {
	local MINVER="$1"
	local VERSIONS=""

	VERSIONS="$(qt_min_version_list "${MINVER}") =${QTPKG}7*"

    echo "$VERSIONS"
}
