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

inherit kdesvn-functions eutils

ECLASS="kdesvn-meta-parent"
INHERITED="$INHERITED $ECLASS"

RDEPEND=""

# For each indicated submodule (dependency)
for submodule in $KMSUBMODULES
do

	# Extract indicated use flag including ?
	[ -z "${submodule##*\(*}" ] && useflag="${submodule%\(*)}" || useflag=""

	# Extract indicated dependency
	dep="${submodule#$useflag\(}"
	dep="${dep%)}"

	# Add dependency on submodule $dep
	if [ -z "$useflag" ]; then
		RDEPEND="$RDEPEND $(deprange $PV $MAXKDEVER kde-base/$dep)"
	else
		RDEPEND="$RDEPEND $useflag ( $(deprange $PV $MAXKDEVER kde-base/$dep) )"
	fi

done

pkg_postrm() {

	queue=""

	# For each indicated submodule (dependency)
	for submodule in $KMSUBMODULES
	do

		# Extract indicated use flag excluding ?
		[ -z "${submodule##*?(*}" ] && useflag="${submodule%?(*)}" || useflag=""

		# Extract indicated dependency
		dep="${submodule#$useflag?(}"
		dep="${dep%)}"
		dep="$(deprange-list $PV $MAXKDEVER kde-base/$dep)"
		
		# If dependency has been installed
		if has_version $dep; then
		
			# If use flag is indicated
			if [ ! -z $useflag ]; then

				# If this ebuild was built with indicated use flag, add to queue
				( built_with_use -a kde-base/$PN $useflag ) && queue="$queue $dep"
		
			# Otherwise, add to queue unconditionally
			else

				queue="$queue $dep"

			fi

		fi
	
	done

	# Unmerge queued dependencies
	[ ! -z "$queue" ] && emerge unmerge $queue

}