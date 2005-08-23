# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: Provide common functionality for applications residing in SourceForge CVS
#

inherit kde sourceforge

ECLASS="kde-sourceforge"
INHERITED="$INHERITED $ECLASS"

# URI at which the newest admin tarball is stored
SRC_URI="http://download.berlios.de/genkdesvn/admin.tar.bz2"

RESTRICT="nomirror"

function kde-sourceforge_src_unpack() {

	# Print function tracing information
	debug-print-function ${FUNCNAME}

	# Perform CVS fetch from SourceForge
	sourceforge_src_unpack

	# Prepare to unpack custom admin tarball
	cd ${S}

	# If admin already exists, replace it, it is most likely stale
	if [ -d "admin" ]
	then
		debug-print "${FUNCNAME}: removing old admin directory"
		rm -rf "admin"
	fi

	# Unpack new admin tarball
	unpack ${A}

}

EXPORT_FUNCTIONS src_unpack
