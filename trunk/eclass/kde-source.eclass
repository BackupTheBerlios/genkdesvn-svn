# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: 
#

inherit kde-make

ECLASS="kde-source"
INHERITED="$INHERITED $ECLASS"

### Terminology:
#
#
#	"non-recursive", "shallow":
#		method of traversal in which directories are treated as if
#		they contained no subdirectories.
#
#	"recursive", "deep":
#		method of traversal in which subdirectories are also descended into
#		NOTE, that by the convention established here,
#		files must be treated as EXCLUSIVELY recursive items.
#
#	"package", "split ebuild", "submodule":
#		refers to an individual application or library, or collection thereof,
#		for which a specialized ebuild exists.
#		(e.g. kmail is a package, while kdepim is a meta-package, containing kmail)
#
#	"distro":
#		refers to packages part of the KDE core distribution which follow
#		the same release schedule and are sometimes very interdependent;
#		their interdependence is perhaps the main reason the distinction is made;
#		another reason however, is the difference in their handling in portage:
#		non-distro ebuilds get their own releases and tarballs,
#		and distro ebuilds reuse the same tarball (of the main module)
#		example packages in distro are those in the kdepim module (such as kmail),
#		and of non-distro are those in extragear (such as amarok)
#
#	"module", "main module", "meta-package":
#		specifies the main module in which specific applications are part of;
#		NOTE, that in the naming of split ebuilds, KMNAME refers to the module,
#		while KMMODULE refers to the submodule (i.e. the specific application);
#
#	"meta":
#		refers to the method of ebuild organization used by the KDE split ebuilds;
#		since it is somewhat sophisticated, another method of submoduling;
#		the whole concept of this scheme lies on the assumption that kde distro packages
#		are tightly knit and simple fetching of the submodule won't suffice.
#
#	"root":
#		refers to the location of the main module relative to the repository URL,
#		which is very useful for handling moves and branches on the repository,
#		along with hiding specific details from the ebuilds themselves.
#    
#
###

# --- begin configurable settings --- #

### Variable: PATCHES
#
# Set to list of names of  patches to be run. In case of meta-ebuilds, 
# patches will be applied by kde-meta, otherwise by subversion. 
# Thus ESVN_PATCHES should not be set by an ebuild 
# as it will be overwritten to ensure consistent behavior.
#
###

[ -z "$KMNAME" ] && ESVN_PATCHES="${PATCHES}" || ESVN_PATCHES=""

###	Variable: KSCM_MODULE
#
# >>> See definition in kde-repo.eclass
# This setting will be ignored if meta-packages are used.
#
###

# If KMNAME is set, assign it to KSCM_MODULE
[ -n "${KMNAME}" ] && KSCM_MODULE="${KMNAME}"

### Variable: KSCM_SUBDIR
#
# >>> See definition in kde-repo.eclass
# This setting will be overwritten if meta-packages are used.
#
###

if [ -n "${KMNAME}" ]
then
	if [ -n "${KMMODULE}" ]
	then
		KSCM_SUBDIR="${KMMODULE}"
	else
		KSCM_SUBDIR="${PN}"
	fi
fi

### Variable: KSCM_ROOT
#
# >>> See definition in kde-repo.eclass
# In the cases of extragear and playground which maintain a more complex
# internal structure we allow a sloppier definition by the ebuilds,
# and rewrite them here for convenience.
# In the cases of distro ebuilds, we provide the correct branch path.
#
###

# If ebuild specifies KSCM_ROOT
if [ -n "${KSCM_ROOT}" ]
then

	# Rewrite KSCM_ROOT to include preceding trunk for extragear and playground
	case "${KSCM_ROOT}" in 
		extragear|playground) KSCM_ROOT=trunk/${KSCM_ROOT};;
	esac

# Otherwise, if ebuild is part of KDE base set of ebuilds
elif [ "${KDEBASE}" == "true" ]
then

	case ${PV} in
		7) KSCM_ROOT="branches/KDE/3.5";;
		8.0) KSCM_ROOT="branches/KDE/4.0";;
		8.1) KSCM_ROOT="trunk/KDE";;
	esac

fi

# --- end configurable settings --- #

# Must inherit kde-make after kde-repo as kde-make needs ${S}
inherit kde-repo kde-make

function collect_translations {
	
	# Print function tracing information
	debug-print-function $FUNCNAME $*
	
	dir=${1}

	if [ -d "${dir}" ]
	then

		for match in $(grep "[^/]*\.pot" -h -o $(find ${dir} -name Makefile.am) | uniq)
		do
			basename ${match} .pot
		done

	else

		# Do not interpret non-existence of directory as fatal, but output debug message
		debug-print $FUNCNAME "${dir} does not exist}"
	fi

}


# --- begin exportable functions --- #

function symlinks {

	libname=""
	for x in $KMCOPYLIB; do
		if [ "$libname" == "" ]; then
			libname=$x
		else
			dirname=$x
			cd ${objdir}
			mkdir -p ${dirname}
			cd ${dirname}
			if [ ! "$(find ${PREFIX}/$(get_libdir)/ -name "${libname}*")" == "" ]; then
				echo "Symlinking library ${libname} under ${PREFIX}/$(get_libdir)/ in object dir"
				ln -sf ${PREFIX}/$(get_libdir)/${libname}* .
			else
				die "Can't find library ${libname} under ${PREFIX}/$(get_libdir)/"
			fi
			libname=""
		fi
	done

	# apply any patches
	base_src_unpack autopatch

	# kdebase: Remove the installation of the "startkde" script.
	if [ "$KMNAME" == "kdebase" ]; then
		sed -i -e s:"bin_SCRIPTS = startkde"::g ${S}/Makefile.am.in
	fi

}


function kde-source_src_unpack {

	# Print function tracing information
	debug-print-function $FUNCNAME $*

	# Admin directory is requirement for all kde-related ebuilds
	ESCM_EXTERNALS="$ESCM_EXTERNALS branches/KDE/3.5/kde-common/admin"

	if [ -z "${KSCM_TRANS_MODULE}" ]
	then

		[ "${KSCM_ROOT}" == "trunk/extragear" ] && KSCM_TRANS_MODULE="extragear-${KSCM_MODULE}" || KSCM_TRANS_MODULE="${KSCM_MODULE}"

	fi

	# Add all translations for module for deep fetch and revision check
	for lang in ${LINGUAS}
	do

		ESCM_DEEPITEMS="${ESCM_DEEPITEMS} trunk/l10n/$lang/messages/${KSCM_TRANS_MODULE}"

		# Disabled as the translation module is shared by more packages
		#ESCM_CHECKITEMS="${ESCM_CHECKITEMS} trunk/l10n/$lang/messages/${KSCM_TRANS_MODULE}"

	done

	kde-repo_src_unpack

	# Make sure to perform set of patches and other functions
	# in case meta ebuilds are in use
	[ -n "$KMNAME" ] && symlinks && kde-meta_src_unpack makefiles

	# Set up translations directory, even if no translations are to be used
	mkdir -p "${S}/po"
	echo "SUBDIRS = \$(AUTODIRS)" > "${S}/po/Makefile.am"

	# For every language, copy the necessary translations for compilation
	for lang in ${LINGUAS}
	do

		# Source directory containing the bulk of translation files
		local srcdir="$WORKDIR/trunk/l10n/$lang/messages/$KSCM_TRANS_MODULE"

		# Destination directory to contain only the relevant translation files
		local destdir="$S/po/$lang"

		# List of names of applicable translations
		local translations=""

		if [ -z "${KSCM_SUBDIR}" ]
		then
			translations="${translations} $(for po in ${srcdir}/*.po; do basename $po .po; done)"
		else
			[ ! ${KMNOMODULE} ] && translations="$translations $(collect_translations ${S}/${KSCM_SUBDIR})"

			for item in ${KMEXTRA}
			do
				translations="${translations} $(collect_translations ${S}/${item})"
			done
		fi

		# If any translations apply, prepare them for compilation
		if [ -n "$translations" ]
		then

			# Create directory for translation compilation
			mkdir -p "${destdir}"

			# Copy each translation to the compilation (po) directory
			for translation in ${translations}
			do
				po="${srcdir}/${translation}.po"
				if [ -f "${po}" ]
				then
					cp "${po}" "${destdir}"
				else
					debug-print $FUNCNAME "${translation} translation missing for ${lang} language"
				fi

			done

			# Create the makefile template
			echo "KDE_LANG = $lang" > $destdir/Makefile.am
			echo "SUBDIRS = \$(AUTODIRS)" >> $destdir/Makefile.am
			echo "POFILES = AUTO" >> $destdir/Makefile.am
		fi

	done
	
	# Return to source directory for ebuilds with extended src_unpack
	cd ${S}

}

function kde-source_pkg_setup {

	kde-make_pkg_setup
	[ "`type -t kde_pkg_setup`" == "function" ] && kde_pkg_setup
	
}

EXPORT_FUNCTIONS pkg_setup src_unpack
