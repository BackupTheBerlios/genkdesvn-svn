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

inherit kde-meta kdesvn multilib
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

# This has function sections now. Call unpack, apply any patches not in $PATCHES,
# then call makefiles.
function kdesvn-meta_src_unpack() {
	kde-meta_src_unpack
}

function kdesvn-meta_src_compile() {
	kde-meta_src_compile
}

function kdesvn-meta_src_install() {
	kde-meta_src_install
}

EXPORT_FUNCTIONS src_unpack src_compile src_install

