# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: Abstract functionality needed for operation of multiple source
# control management tools

ECLASS="scm"
INHERITED="$INHERITED $ECLASS"

# Perform deep copy of a given item between given paths.
# $1 = item to copy (directory/file)
# $2 = source path where item resides
# $3 = destination path where item is to reside
function scm_deep_copy() {

	debug-print-function $FUNCNAME $*

	local item="$1"
	local src="$2"
	local dest="$3"

	einfo "Copying $item to $dest"
	debug-print "$FUNCNAME: Deep-copying $item from $src to $dest"
	pushd $src >/dev/null
	debug-print `cp -Rf --parents "$item" "$dest" 2>&1`
	popd >/dev/null

}

# Perform shallow copy of a given directory between given paths.
# $1 = directory to copy non-recursively
# $2 = source path where item resides
# $3 = destination path where item is to reside
function scm_shallow_copy() {

	debug-print-function $FUNCNAME $*

	local item="$1"
	local src="$2"
	local dest="$3"
	
	einfo "Copying $item to $dest"
	debug-print "$FUNCNAME: Shallow-copying $item from $src to $dest"
	pushd $src >/dev/null
	debug-print `cp -f --parents "$item"/* "$dest" 2>&1`
	popd >/dev/null

}

# Copy items from a given directory to ${WORKDIR}
# $1 = path to source directory
# $2 = procedure to be called to perform deep copy (optional, default=deep_copy)
# $3 = procedure to be called to perform shallow copy (optional, default=shallow_copy)
function src_to_workdir() {

	debug-print-function $FUNCNAME $*

	local src=$1
	local deep_copy=scm_deep_copy
	local shallow_copy=scm_shallow_copy

	[ -n $2 ] && deep_copy=$2

	for item in $ESCM_SHALLOWITEMS
	do

		[ -e $src/$item ] && $shallow_copy $item $src $WORKDIR 

	done

	for item in $ESCM_DEEPITEMS
	do
	
		[ -e $src/$item ] && $deep_copy $item $src $WORKDIR

	done

	for item in $ESCM_EXTERNALS
	do

		[ -e $WORKDIR/$item ] && einfo "Moving $item to $S" && mv $WORKDIR/$item $S

	done
	
}
