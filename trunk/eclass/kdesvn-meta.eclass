# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Original Author:
#	Dan Armak <danarmak@gentoo.org>
#
# Modifications by:
#	Mario Tanev <mtanev@csua.berkeley.edu>
#	Stefan Vunckx <stefan.vunckx@skynet.be>
#
# This is the kdesvn-meta eclass which supports broken-up kde-base packages.
# ALL functions are prefixed with "kdesvn_" so that we can still use the official eclass functions,
# except for the src_* functions; they have the kdesvn-meta_ prefix

inherit kdesvn multilib

if [ "$KDEBASE" = "true" ]; then
    need-kdesvn $PV

    SLOT="$KDEMAJORVER.$KDEMINORVER"
fi

## TODO: inherit kde-meta

ECLASS=kdesvn-meta
INHERITED="$INHERITED $ECLASS"

# Set the following variables in the ebuild. Only KMNAME must be set, the rest are optional.
# A directory or file can be a path with any number of components (eg foo/bar/baz.h).
# Do not include the same item in more than one of KMMODULE, KMMEXTRA, KMCOMPILEONLY, KMEXTRACTONLY, KMCOPYLIB.
#
# KMNAME: name of the metapackage (eg kdebase, kdepim). Must be set before inheriting this eclass
# (unlike the other parameters here), since it affects $SRC_URI.
# KMNOMODULE: unless set to "true", then KMMODULE will be not defined and so also the docs. Useful when we want to installs subdirs of a subproject, like plugins, and we have to mark the topsubdir ad KMEXTRACTONLY.
# KMMODULE: Defaults to $PN. Specify one subdirectory of KMNAME. Is treated exactly like items in KMEXTRA.
# Fex., the ebuild name of kdebase/l10n is kdebase-l10n, because just 'l10n' would be too confusing.
# KMNODOCS: unless set to "true", 'doc/$KMMODULE' is added to KMEXTRA. Set for packages that don't have docs.
# KMEXTRA, KMCOMPILEONLY, KMEXTRACTONLY: specify files/dirs to extract, compile and install. $KMMODULE
# is added to $KMEXTRA automatically. So is doc/$KMMODULE (unless $KMNODOCS==true).
# Makefiles are created automagically to compile/install the correct files. Observe these rules:
# - Don't specify the same file in more than one of the three variables.
# - When using KMEXTRA, remember to add the doc/foo dir for the extra dirs if one exists.
# - KMEXTRACTONLY take effect over an entire directory tree, you can override it defining
# KMEXTRA, KMCOMPILEONLY for every subdir that must have a different behavior.
# eg. you have this tree:
# foo/bar
# foo/bar/baz1
# foo/bar/baz1/taz
# foo/bar/baz2
# If you define:
# KMEXTRACTONLY=foo/bar and KMEXTRA=foo/bar/baz1
# then the only directory compiled will be foo/bar/baz1 and not foo/bar/baz1/taz (also if it's a subdir of a KMEXTRA) or foo/bar/baz2
#
# IMPORTANT!!! you can't define a KMCOMPILEONLY SUBDIR if its parents are defined as KMEXTRA or KMMODULE. or it will be installed anywhere. To avoid this probably are needed some chenges to the generated Makefile.in.
#
# KMCOPYLIB: Contains an even number of $IFS (i.e. whitespace) -separated words.
# Each two consecutive words, libname and dirname, are considered. symlinks are created under $S/$dirname
# pointing to $PREFIX/lib/libname*.
#
# KMTARGETSONLY: contains list of directories followed by targets. Those files, and those files alone, 
# will be compiled in that directory. This is useful when apps link to ui or kcfgc file from other directory.
# usage is 'path/to/dir/ .extension1 [.extension2 [.extension3 ...]]'
#
# KMHEADERS: contains list of directories followed by list of files to create before compiling, syntax is:
# 'path/to/dir/ header1.h [header2.h [header3.h ...]]' etc
#
# KMHEADERDIRS: contains list of directories followed by list of file patterns to create before compiling, syntax is:
# 'path/to/dir/ *.extension' etc

# ====================================================

function kdesvn_set_target_arrays {
	set_target_arrays
}

# create a full path vars, and remove ALL the endings "/"
function kdesvn_create_fullpaths() {
	create_fullpaths
}

# Creates Makefile.am files in directories where we didn't extract the originals.
# Params: $1 = directory
# $2 = $isextractonly: true iff the parent dir was defined as KMEXTRACTONLY
# Recurses through $S and all subdirs. Creates Makefile.am with SUBDIRS=<list of existing subdirs>
# or just empty all:, install: targets if no subdirs exist.
function kdesvn_change_makefiles() {
	change_makefiles
}

function kdesvn_set_common_variables() {
	set_common_variables
}

function kdesvn_sort_subdirs {
	sort_subdirs
}

# This function differs from kde-meta_src_unpack() as it fetches the source code
# from the subversion repository
function kdesvn-meta_src_unpack() {
	debug-print-function $FUNCNAME $*

	#set_common_variables

	sections="$@"
	[[ -z "$sections" ]] && sections="unpack makefiles"
	for section in $sections; do
	case $section in
	prepare)

		# kdepim packages all seem to rely on libkdepim/kdepimmacros.h
		# also, all kdepim Makefile.am's reference doc/api/Doxyfile.am
		if [ "$KMNAME" == "kdepim" ]; then
			KMEXTRACTONLY="$KMEXTRACTONLY libkdepim/kdepimmacros.h doc/api"
		fi

		# deeplist stores common items in cvs and non-cvs meta-ebuilds
		# It is named deeplist because this list also represents items to be
		# recursively fetched in cvs
		deeplist="admin Makefile.am Makefile.am.in configure.in.in configure.in.bot configure.in.mid
		acinclude.m4 aclocal.m4 AUTHORS COPYING INSTALL README NEWS ChangeLog
		$KMMODULE $KMEXTRA $KMCOMPILEONLY ${targetdirs[*]} $KMEXTRACTONLY $DOCS"

	;;
	unpack)

		kde-meta_src_unpack "prepare"

		# Create final list of stuff to extract
		extractlist=""
		for item in Makefile.am configure.in.mid acinclude.m4 aclocal.m4 $deeplist
		do
			extractlist="$extractlist $KMNAME-$TARBALLDIRVER/$item"
		done

		# xdeltas require us to uncompress to a tar file first.
		# $KMTARPARAMS is also available for an ebuild to use; currently used by kturtle
		# ${DISTDIR} is no longer used in portage; we must now use ${PORTAGE_ACTUAL_DISTDIR}
		if useq kdexdeltas && [ -n "$XDELTA_BASE" ]; then
			echo ">>> Base archive + xdelta patch mode enabled."
			echo ">>> Uncompressing base archive..."
			cd $T
			RAWTARBALL=${TARBALL//.bz2}
			bunzip2 -dkc ${PORTAGE_ACTUAL_DISTDIR}/${XDELTA_BASE/*\//} > $RAWTARBALL
			for delta in $XDELTA_DELTA; do
				deltafile="${delta/*\//}"
				echo ">>> Applying xdelta: $deltafile"
				xdelta patch ${PORTAGE_ACTUAL_DISTDIR}/$deltafile $RAWTARBALL $RAWTARBALL.1
				mv $RAWTARBALL.1 $RAWTARBALL
			done
			TARFILE=$T/$RAWTARBALL
		else
			TARFILE=$PORTAGE_ACTUAL_DISTDIR/$TARBALL
			KMTARPARAMS="$KMTARPARAMS -j"
		fi
		cd $WORKDIR

		echo ">>> Extracting from tarball..."
		# Note that KMTARPARAMS is also used by an ebuild
		tar -xpf $TARFILE $KMTARPARAMS $extractlist	2> /dev/null

		# Avoid syncing if possible
		# No idea what the above comment means...
		if [ -n "$RAWTARBALL" ]; then
			rm -f $T/$RAWTARBALL
		fi

		# Default $S is based on $P not $myP; rename the extracted dir to fit $S
		mv $KMNAME-$TARBALLDIRVER $P || die
		S=$WORKDIR/$P

		# Copy over KMCOPYLIB items
		libname=""
		for x in $KMCOPYLIB; do
			if [ "$libname" == "" ]; then
				libname=$x
			else
				dirname=$x
				cd $S
				mkdir -p ${dirname}
				cd ${dirname}
				if [ ! "$(find ${PREFIX}/$(get_libdir)/ -name "${libname}*")" == "" ]; then
					echo "Symlinking library ${libname} under ${PREFIX}/$(get_libdir)/ in source dir"
					ln -s ${PREFIX}/$(get_libdir)/${libname}* .
				else
					die "Can't find library ${libname} under ${PREFIX}/$(get_libdir)/"
				fi
				libname=""
			fi
		done

		# apply any patches
		kde_src_unpack autopatch

		# kdebase: Remove the installation of the "startkde" script.
		if [ "$KMNAME" == "kdebase" ]; then
			sed -i -e s:"bin_SCRIPTS = startkde"::g ${S}/Makefile.am.in
		fi

		# Visiblity stuff is way broken! Just disable it when it's present
		# until upstream finds a way to have it working right.
		if grep KDE_ENABLE_HIDDEN_VISIBILITY configure.in &> /dev/null || ! [[ -f configure ]]; then
			find ${S} -name configure.in.in | xargs sed -i -e \
				's:KDE_ENABLE_HIDDEN_VISIBILITY::g'
			rm -f configure
		fi

		# for ebuilds with extended src_unpack
		cd $S

	;;
	makefiles)

		# Create Makefile.am files
		create_fullpaths
		change_makefiles $S "false"

		# for ebuilds with extended src_unpack
		cd $S

	;;
	esac
	done
}

function kdesvn-meta_src_compile() {
	# update timestamp for certain file-extensions that need to be generated
	kdesvn_touch_all_files

	kde-meta_src_compile
}

function kdesvn-meta_src_install() {
	kde-meta_src_install
}

EXPORT_FUNCTIONS src_unpack src_compile src_install

