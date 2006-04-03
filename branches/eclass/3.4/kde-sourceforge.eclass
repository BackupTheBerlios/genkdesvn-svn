# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: Provide common functionality for applications residing in SourceForge CVS
#

inherit eutils kde-make kde sourceforge

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

	if [ -d po ]
	then
		strip-linguas -u po
		cd po
		for po in *.po
		do
			lingua="$(basename ${po} .po)"
			if ( ! hasq "${lingua}" ${LINGUAS} )
			then
				debug-print "${FUNCNAME}: removing translations for lingua ${lingua}"
				rm -f "${lingua}".*
			fi
		done
		cd ${OLDPWD}
	fi

	# If admin already exists, replace it, it is most likely stale
	if [ -d admin ]
	then
		debug-print "${FUNCNAME}: removing old admin directory into admin.old"
		mv -f admin admin.old
	fi

	# If configure script exists, remove it so it is regenerated
	if [ -f configure ]
	then
		debug-print "${FUNCNAME}: removing old configure script"
		rm -f configure
	fi

	# Unpack new admin tarball
	unpack ${A}

}

function kde-sourceforge_pkg_setup {

	kde-make_pkg_setup
	kde_pkg_setup

}

EXPORT_FUNCTIONS pkg_setup src_unpack
