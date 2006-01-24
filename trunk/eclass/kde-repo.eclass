# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose:
#	Provide access to the KDE repository without extra functionality,
#	which is necessary for actual KDE ebuilds
#
inherit libtool
ECLASS="kde-repo"
INHERITED="$INHERITED $ECLASS"

##### --- begin configurable settings --- #####

### Variable: ESVN_REPO_URI
#
# Set to URI of repository to fetch from.
#
###

[ -z "${ESVN_REPO_URI}" ] && ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde"


### Variable: ESVN_BOOTSTRAP
#
# Set to script to run in the bootstrap phase.
# It should really only be set by an ebuild, not the user.
# It defaults to elibtoolize to possibly rectify potential libtool problems.
#
###

[ -z "${ESVN_BOOTSTRAP}" ] && ESVN_BOOTSTRAP=elibtoolize


### Variable: PATCHES
#
# Set to list of names of  patches to be run. In case of meta-ebuilds,
# patches will be applied by kde-meta, otherwise by subversion.
# Thus ESVN_PATCHES should not be set by an ebuild
# as it will be overwritten to ensure consistent behavior.
#
###

[ -z "$KMNAME" ] && ESVN_PATCHES="${PATCHES}" || ESVN_PATCHES=""


### Variable: KSCM_ROOT
#
# Set to path which to consider as the root of residence for the modules.
# It is useful for supporting branches, and deciding what the src directory is.
# It defaults to trunk.
#
###

[ -z "${KSCM_ROOT}" ] && KSCM_ROOT="trunk"


### Variable: KSCM_MODULE
#
# Set to main module associated with ebuild.
# If it is not set, it defaults to ebuild name
#
###

[ -z "${KSCM_MODULE}" ] && KSCM_MODULE="${PN}"


### Variable: KSCM_SUBDIR
#
# Set to submodule associated with ebuild.
# Note, that there is no default value, thus if you need
# submodule handling, you need to give it a value.
# ${PN} is usually a good choice.
#
###

# KSCM_SUBDIR= 


##### --- end configurable settings --- #####

inherit subversion

# --- begin helper functions  --- #

###	Function: wrap_root
#
#	Wraps KSCM_ROOT around parameter, and strips trailing slashes
#
#	Parameters:
#		$1 - path to wrap
###
function wrap_root() {

	# Print function tracing information
	debug-print-function ${FUNCNAME} ${*}

	# Append parameter to KSCM_ROOT
	strip_duplicate_slashes ${KSCM_ROOT}/${1}	

}

SRC_URI=""

# Set source directory
if [ "${KSCM_MODULE_IS_ROOT}" == "true" ]; then
	S="$(strip_duplicate_slashes ${WORKDIR}/$(wrap_root ${KSCM_MODULE}/${KSCM_SUBDIR}))"
else
	S="$(strip_duplicate_slashes ${WORKDIR}/$(wrap_root ${KSCM_MODULE}))"
fi

# --- begin exportable functions --- #

function kde-repo_src_unpack() {

	# Log function tracing information
	debug-print-function ${FUNCNAME} $*

	# Add all externals to list of items to be fetched recursively
	ESCM_DEEPITEMS="${ESCM_DEEPITEMS} ${ESCM_EXTERNALS}"

	# If submodules are used, fetch the module plus specific extra files
	if [ -n "${KSCM_SUBDIR}" ]
	then
		
		# DEEPITEMS stores items to be fetched recursively
		DEEPITEMS=""

		# SHALLOWITEMS stores items to be fetched non-recursively
		SHALLOWITEMS=""

		# CHECKITEMS stores items to be checked their revisions against installed versions
		CHECKITEMS=""
	
		# If meta ebuilds are in use (for distro packages)
		if [ -n "${KMNAME}" ]
		then
			
			# Let kde-meta create deeplist
			kde-meta_src_unpack "prepare"

			# Add Makefile.cvs to list of items to be fetched recursively
			DEEPITEMS="Makefile.cvs $deeplist"

			# Add submodule and extras to list of items for revision-check
			CHECKITEMS="${CHECKITEMS} ${KMMODULE} ${KMEXTRA}"

			# special cases: 
			if [ "${PN}" == "kdebase-startkde" ]; then
				# kdebase-startkde package is just a file
				CHECKITEMS="${CHECKITEMS} kdm/kfrontend/sessions/kde.desktop.in"
			fi

		# If non-meta ebuilds are in use
		else
	
			# Add submodule directory to list of items to be fetched recursively
			DEEPITEMS="${DEEPITEMS} ${KSCM_SUBDIR}"

			# Add submodule directory to list of items for revision-check
			CHECKITEMS="${DEEPITEMS} ${KSCM_SUBDIR}"

			# Add module directory to list of items to be fetched
			# non-recursively, which is needed for makefiles, etc.
			SHALLOWITEMS="${SHALLOWITEMS} /"

			# Unless documents are not to be used, also fetch the corresponding doc folder
			if [ -z "$KSCM_SUBDIR_NODOC" ]; then

				# Add submodule doc folder to list of items to be fetched
				# recursively
				DEEPITEMS="$DEEPITEMS doc/${KSCM_SUBDIR}"

				# Add submodule doc module folder to list of items for revision-check
				CHECKITEMS="$CHECKITEMS doc/${KSCM_SUBDIR}"

				# Add module doc folder to list of items to be fetched
				# non-recursively, for makefiles, etc.
				SHALLOWITEMS="$SHALLOWITEMS doc"

			fi
		fi

		# Wrap all entries of the lists containing deep, shallow and revision-checked items with their root	
		# Note, the following code utilizes indirect references, do not change if not familiar
		for LIST in DEEPITEMS SHALLOWITEMS CHECKITEMS
		do
			for item in ${!LIST}
			do
				ESCM_LIST=ESCM_${LIST}
				eval $ESCM_LIST=\"${!ESCM_LIST} $(wrap_root ${KSCM_MODULE}/${item})\"
			done
		done
	
	else
	
		ESCM_DEEPITEMS="${ESCM_DEEPITEMS} $(wrap_root ${KSCM_MODULE})"
		ESCM_CHECKITEMS="${ESCM_CHECKITEMS} $(wrap_root ${KSCM_MODULE})"

	fi

	# Perform subversion fetch
	subversion_src_unpack

}

EXPORT_FUNCTIONS src_unpack
