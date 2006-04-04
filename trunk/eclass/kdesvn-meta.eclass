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
IUSE=""

# only broken-up ebuilds can use this eclass
if [[ -z "$KMNAME" ]]; then
	die "kde-meta.eclass inherited but KMNAME not defined - broken ebuild"
fi

# BEGIN adapted from kde-dist.eclass, code for older versions removed for cleanness
if [[ "$KDEBASE" = "true" ]]; then
	unset SRC_URI

	need-kde

	DESCRIPTION="KDE ${PV} - "
	HOMEPAGE="http://www.kde.org/"
	LICENSE="GPL-2"
	SLOT="$KDEMAJORVER.$KDEMINORVER"

fi

debug-print "$ECLASS: finished, SRC_URI=$SRC_URI"

# Add a blocking dep on the package we're derived from
DEPEND="${DEPEND} !$(get-parent-package ${CATEGORY}/${PN})"
RDEPEND="${RDEPEND} !$(get-parent-package ${CATEGORY}/${PN})"

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

function set_target_arrays {

    for ((index=0; index < ${#KMTARGETSONLY[*]}; index++))
    do
        read targetdirs[index] targets[index] < <(echo ${KMTARGETSONLY[index]})
    done

    for ((index=0; index < ${#KMHEADERS[*]}; index++))
    do
        read newheaderdirs[index] newheaders[index] < <(echo ${KMHEADERS[index]})
    done

    for ((index=0; index < ${#KMHEADERDIRS[*]}; index++))
    do
        read headerdirs[index] headers[index] < <(echo ${KMHEADERDIRS[index]})
    done

}

# create a full path vars, and remove ALL the endings "/"
function create_fullpaths() {

    set_target_arrays
    for item in $KMMODULE; do
        tmp=`echo $item | sed -e "s/\/*$//g"`
        KMMODULEFULLPATH="$KMMODULEFULLPATH ${S}/$tmp"
    done
    for item in $KMEXTRA; do
        tmp=`echo $item | sed -e "s/\/*$//g"`
        KMEXTRAFULLPATH="$KMEXTRAFULLPATH ${S}/$tmp"
    done
    for item in $KMCOMPILEONLY ${targetdirs[*]}; do
        tmp=`echo $item | sed -e "s/\/*$//g"`
        KMCOMPILEONLYFULLPATH="$KMCOMPILEONLYFULLPATH ${S}/$tmp"
    done
    for item in $KMEXTRACTONLY; do
        tmp=`echo $item | sed -e "s/\/*$//g"`
        KMEXTRACTONLYFULLPATH="$KMEXTRACTONLYFULLPATH ${S}/$tmp"
    done

}

# Creates Makefile.am files in directories where we didn't extract the originals.
# Params: $1 = directory
# $2 = $isextractonly: true iff the parent dir was defined as KMEXTRACTONLY
# Recurses through $S and all subdirs. Creates Makefile.am with SUBDIRS=<list of existing subdirs>
# or just empty all:, install: targets if no subdirs exist.
function change_makefiles() {
	debug-print-function $FUNCNAME $*
	local dirlistfullpath dirlist directory isextractonly

	cd $1
	debug-print "We are in `pwd`"

	# check if the dir is defined as KMEXTRACTONLY or if it was defined is KMEXTRACTONLY in the parent dir, this is valid only if it's not also defined as KMMODULE, KMEXTRA or KMCOMPILEONLY. They will ovverride KMEXTRACTONLY, but only in the current dir.
	isextractonly="false"
	if ( ( hasq "$1" $KMEXTRACTONLYFULLPATH || [[ $2 = "true" ]] ) && \
		 ( ! hasq "$1" $KMMODULEFULLPATH $KMEXTRAFULLPATH $KMCOMPILEONLYFULLPATH ) ); then
		isextractonly="true"
	fi
	debug-print "isextractonly = $isextractonly"

	dirlistfullpath=
	for item in *; do
		if [[ -d "$item" ]] && [[ "$item" != "CVS" ]] && [[ "$S/$item" != "$S/admin" ]]; then
			# add it to the dirlist, with the FULL path and an ending "/"
			dirlistfullpath="$dirlistfullpath ${1}/${item}"
		fi
	done
	debug-print "dirlist = $dirlistfullpath"

	for directory in $dirlistfullpath; do

		if ( hasq "$1" $KMEXTRACTONLYFULLPATH || [[ $2 = "true" ]] ); then
			change_makefiles $directory 'true'
		else
			change_makefiles $directory 'false'
		fi
		# come back to our dir
		cd $1
	done

	cd $1
	debug-print "Come back to `pwd`"
	debug-print "dirlist = $dirlistfullpath"
	if [[ $isextractonly = "true" ]] || [[ ! -f Makefile.am ]] ; then
		# if this is a latest subdir
		if [[ -z "$dirlistfullpath" ]]; then
			debug-print "dirlist is empty => we are in the latest subdir"
			echo 'all:' > Makefile.am
			echo 'install:' >> Makefile.am
			echo '.PHONY: all' >> Makefile.am
		else # it's not a latest subdir
			debug-print "We aren't in the latest subdir"
			# remove the ending "/" and the full path"
			for directory in $dirlistfullpath; do
				directory=${directory%/}
				directory=${directory##*/}
				dirlist="$dirlist $directory"
			done
			echo "SUBDIRS=$dirlist" > Makefile.am
		fi
	fi
}

function set_common_variables() {
	# Overridable module (subdirectory) name, with default value
	if [[ "$KMNOMODULE" != "true" ]] && [[ -z "$KMMODULE" ]]; then
		KMMODULE=$PN
	fi

	# Unless disabled, docs are also extracted, compiled and installed
	DOCS=""
	if [[ "$KMNOMODULE" != "true" ]] && [[ "$KMNODOCS" != "true" ]]; then
		DOCS="doc/$KMMODULE"
	fi
}

function sort_subdirs {

	local modules="${*}"
	if [ -f subdirs ]
	then
		local sorted=""
		exec < subdirs
		while read subdir
		do
			for module in ${modules}
			do
				slashed="$(strip_duplicate_slashes ${module}/)"

				if [ -z "${slashed##${subdir}/*}" ]
				then
					sorted="${sorted} ${module}"
				fi
				
			done
			
		done
		echo ${sorted}
	else
		echo ${modules}
	fi

}

# This function differs from kde-meta_src_unpack() as it fetches the source code
# from the subversion repository
function kdesvn-meta_src_unpack() {
	debug-print-function $FUNCNAME $*

	set_common_variables

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

		kdesvn-meta_src_unpack "prepare"

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
		kdesvn_src_unpack autopatch

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
	debug-print-function $FUNCNAME $*

	# update timestamp for certain file-extensions that need to be generated
	kdesvn_touch_all_files

	set_common_variables

	if [[ "$KMNAME" == "kdebase" ]]; then
		# bug 82032: the configure check for java is unnecessary as well as broken
		myconf="$myconf --without-java"
	fi

	if [[ "$KMNAME" == "kdegames" ]]; then
		# make sure games are not installed with setgid bit, as it is a security risk.
		myconf="$myconf --disable-setgid"
	fi

	callsections="$*"
	[ -z "$callsections" -o "$callsections" == "all" ] && callsections="myconf configure make"
	for section in $callsections; do
		debug-print "$FUNCNAME: now in section $section"
		if [ "$section" == "configure" ]; then
			[ ! -f "Makefile.in" ] && make -f admin/Makefile.common
			myconf="$EXTRA_ECONF $myconf"
		fi

		if [ "$section" == "make" ]; then

			if [ "${UNSERMAKE}" == "no" ]; then

				# KMHEADERS: create headers without touching Makefile.am
				# syntax is different too: "path/to/dir file.h"
				for dir in $(sort_subdirs ${newheaderdirs[*]})
				do
					einfo "Creating headers in ${dir}"
					pushd ${S}/${dir} >/dev/null || die "${FUNCNAME}: unable to change directory to {S}/${dir}"
					for ((index=0; index< ${#newheaderdirs[*]}; index++))
					do
						if [ "${newheaderdirs[index]}" == "${dir}" ]
						then
							for target in ${newheaders[index]}
							do
								output="$(emake ${target} 2>&1)"
								ewarn "Manually creating ${target}"
							done
						fi
					done
					popd >/dev/null
				done

				# KMHEADERDIRS: create headers without touching Makefile.am
				# syntax is different too: "path/to/dir .extension"
				for dir in $(sort_subdirs ${headerdirs[*]})
				do
					einfo "Creating headers in ${dir}"
					pushd ${S}/${dir} >/dev/null || die "${FUNCNAME}: unable to change directory to {S}/${dir}"
					for ((index=0; index< ${#headerdirs[*]}; index++))
					do
						if [ "${headerdirs[index]}" == "${dir}" ]
						then
							for target in ${headers[index]}
							do
								for i in *${target};
								do
									if [ "${i}" != "*${target}" ]; then
										dest="$(basename ${i} ${target}).h"
										output="$(emake ${dest} 2>&1)"
										ewarn "Manually creating ${dest}"
									fi
								done
							done
						fi
					done
					popd >/dev/null
				done

			fi

			compiledirs="${KMCOMPILEONLY} ${KMMODULE} ${KMEXTRA} ${KMEXTERNAL} ${DOCS} po"
			for dir in $(sort_subdirs ${compiledirs} ${targetdirs[*]})
			do
				pushd ${S}/${dir} >/dev/null || die "${FUNCNAME}: unable to change directory to {S}/${dir}"
				# If directory is marked for complete compilation
				if ( hasq "${dir}" ${compiledirs} )
				then
					einfo "Making ${dir}"
					emake || die "died running emake, $FUNCNAME:make"
				# If directory is marked for specific targets
				else
					for ((index=0; index< ${#targetdirs[*]}; index++))
					do
						if [ "${targetdirs[index]}" == "${dir}" ]
						then
							for target in ${targets[index]}
							do
								if [ "${target:0:1}" == "." ]
								then
									einfo "Making ${target:1} headers in ${dir}"
									for src in *${target}
									do
										dest="$(basename ${src} ${target}).h"
										output="$(emake ${dest} 2>&1)"
										
										if [ ! ${?} -eq 0 ]
										then
											if [ "${target}" == ".ui" ]
											then
												ewarn "Manually creating ${dest} in ${dir}"
												${QTDIR}/bin/uic -o ${dest} ${src} || die
											else
												printf "${output}\n"
												die "unable to create ${target:1} headers in ${dir}"
											fi
										else
											printf "${output}\n"
										fi
									done
								else
									einfo "Making ${target} in ${dir}"
									emake ${target} || die "unable to make ${target} in ${dir}"
								fi
							done
						fi
					done
					echo 'all:' > Makefile.am
					echo 'install:' >> Makefile.am
					echo '.PHONY: all' >> Makefile.am
				fi
				popd >/dev/null
			done
			
		else
			kdesvn_src_compile $section
		fi
	done

	#kdesvn_src_compile $*
}

function kdesvn-meta_src_install() {
	debug-print-function $FUNCNAME $*

	set_common_variables

	if [[ "$1" == "" ]]; then
		kdesvn-meta_src_install make dodoc
	fi
	while [[ -n "$1" ]]; do
		case $1 in
		    make)
				for dir in $KMMODULE $KMEXTRA $KMEXTERNAL $DOCS po; do
					if [[ -d $S/$dir ]]; then
						cd $S/$dir
						einfo "Installing ${dir}"
						make DESTDIR=${D} destdir=${D} install || die
					fi
				done
				;;
		    dodoc)
				kdesvn_src_install dodoc
				;;
		    all)
				kdesvn-meta_src_install make dodoc
				;;
		esac
		shift
	done
}

EXPORT_FUNCTIONS src_unpack src_compile src_install

