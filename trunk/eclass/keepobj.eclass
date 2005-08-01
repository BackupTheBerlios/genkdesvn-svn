# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: 
#

ECLASS="keepobj"
INHERITED="$INHERITED $ECLASS"

[ -z "$PORTAGE_OBJDIR" ] && PORTAGE_OBJDIR=/var/tmp/portage/objects

function objdir() {
	if [ $(keepobj_enabled) ]
	then
		echo ${PORTAGE_OBJDIR}/${CATEGORY}/${P}/
	else
		echo ${S}
	fi
}

function srcdir() {
	if [ $(keepobj_enabled) ]
	then
		echo ${S}
	else
		echo .
	fi
}

function keepobj() {
	debug-print-function $FUNCNAME $*
	pushd $(objdir) >/dev/null
	$*
	retcode=$?
	popd >/dev/null
	return $retcode
}

function keepobj_enabled() {
	if ( hasq keepobj ${FEATURES} )
	then
		echo "yes"
	fi
}

function keepcache_enabled() {
	if ( hasq confcache $FEATURES )
	then
		echo "$(keepobj_enabled)"
	fi
}

function keepobj_initialize() {
	if [ $(keepobj_enabled) ] && [ ! -d $(objdir) ]
	then
		mkdir -p $(objdir)
	fi
}

