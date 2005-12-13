# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: 
#

ECLASS="unsermake"
INHERITED="$INHERITED $ECLASS"

DEPEND="$DEPEND
	>=kde-base/unsermake-7-r1"

function make_cmd() {
	[ "$UNSERMAKE" == no ] && echo make || echo unsermake $UNSERMAKEOPTS
}

function emake_cmd() {
	[ "$UNSERMAKE" == no ] && echo emake || echo unsermake $UNSERMAKEOPTS
}

function automake_cmd() {
	echo env UNSERMAKE=$UNSERMAKE AUTOMAKE=automake-1.7 make -f
}

