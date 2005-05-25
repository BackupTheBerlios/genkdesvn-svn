# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: Handle emerging/unmerging of submodules
#

MAXKDEVER=$PV

inherit kde-functions eutils

ECLASS="kde-meta-parent"
INHERITED="$INHERITED $ECLASS"

RDEPEND=""

# For each indicated submodule (dependency)
for submodule in $KMSUBMODULES
do

	# Extract indicated use flag including ?
	[ -z "${submodule##*(*}" ] && useflag="${submodule%(*)}" || useflag=""

	# Extract indicated dependency
	dep="${submodule#$useflag(}"
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
