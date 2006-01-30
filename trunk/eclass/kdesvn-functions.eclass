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
# Purpose: 
# This contains everything except things that modify ebuild variables
# and functions (e.g. $P, src_compile() etc.)
# ALL functions are prefixed with "kdesvn_" so that we can still use the official eclass functions

inherit qt-copy kde-functions

# map of the monolithic->split ebuild derivation; used to build deps describing
# the relationships between them ...
# we can add our extra ebuilds to the list here
KDE_DERIVATION_MAP="${KDE_DERIVATION_MAP}
"

# accepts 1 parameter, the name of a split ebuild; echoes the name of its mother package
#kdesvn_get-parent-package () {
#	get-parent-package "$@"
#}

# accepts 1 parameter, the name of a monolithic package; echoes the names of all ebuilds derived from it
#kdesvn_get-child-packages () {
#	get-child-packages "$@"
#}

# convinience functions for requesting autotools versions
#kdesvn_need-automake() {
#	need-automake "$@"
#}

#kdesvn_need-autoconf() {
#	need-autoconf "$@"
#}


#kdesvn_deprange() {
#	deprange "$@"
#}

#kdesvn_deprange-list() {
#	deprange-list "$@"
#}

# This internal function iterates over simple ranges where only a numerical suffix changes
# Parameters: base name, lower bound, upper bound
#kdesvn_deprange-iterate-numbers() {
	#deprange-iterate-numbers "$@"
#}

# This internal function iterates over ranges with the same base version and different suffixes.
# If the lower bound has a revision number, this function won't mention the lower bound in its output.
# Parameters: base name, lower version suffix, upper version suffix
# eg: deprange-iterate-suffixes ~kde-base/libkonq-3.4.0 alpha8 beta2
#kdesvn_deprange-iterate-suffixes() {
#	deprange-iterate-suffixes "$@"
#}

# Wrapper around deprange() used for deps between split ebuilds.
# It adds the parent monolithic ebuild of the dep as an alternative dep.
#kdesvn_deprange-dual() {
#	deprange-dual "$@"
#}

# ---------------------------------------------------------------
# kde/qt directory management etc. functions, was kde-dirs.ebuild
# ---------------------------------------------------------------

need-kdesvn() {
    debug-print-function $FUNCNAME $*
    KDEVER="$1"
    # ask for autotools
    case "${KDEVER}" in
        7*)
			# determine install locations
			set-kdesvndir ${KDEVER}

            need-autoconf 2.5
            need-automake 1.7

			# Things outside kde-base only need a minimum version
			if [ -z "${KDEBASE}" ]; then
				min-kdesvn-ver ${KDEVER}
			fi
		
			# Set Qt versions
			qtver-from-kdesvnver ${KDEVER}
			need-qt ${selected_version}
            ;;
		*)
			# portage's kde-functions eclass stuff
			need-kde ${KDEVER}
			;;
    esac
}

set-kdesvndir() {
    debug-print-function $FUNCNAME $*

    # install prefix
    if [ -n "$KDEPREFIX" ]; then
        export PREFIX="$KDEPREFIX"
    elif [ "$KDEMAJORVER" == "2" ]; then
        export PREFIX="/usr/kde/2"
    else
        if [ -z "$KDEBASE" ]; then
            case $KDEMAJORVER.$KDEMINORVER in
                7.0) export PREFIX="/usr/kde/devel";;
            esac
		fi
    fi

    # kdelibs location
    if [ -n "$KDELIBSDIR" ]; then
        export KDEDIR="$KDELIBSDIR"
    elif [ "$KDEMAJORVER" == "2" ]; then
        export KDEDIR="/usr/kde/2"
    else
        if [ -n "$KDEBASE" ]; then
            # kde-base ebuilds must always use the exact version of kdelibs they came with
            case $KDEMAJORVER.$KDEMINORVER in
                7.0) export KDEDIR="/usr/kde/devel";;
            esac
        fi
    fi

    # check that we've set everything
    if [ -z "$PREFIX" ] || [ -z "$KDEDIR" ]; then
		set-kdedir $*
	fi

    debug-print "$FUNCNAME: Will use the kdelibs installed in $KDEDIR, and install into $PREFIX."
}

#kdesvn_need-qt() {
#	need-qt "$@"
#}

#kdesvn_set-qtdir() {
#	set-qtdir "$@"
#}

# returns minimal qt version needed for specified kde version
qtver-from-kdesvnver() {
    debug-print-function $FUNCNAME $*

    local ver

    case $1 in
        7)  ver=3.3;; # subversion
    esac

    selected_version="$ver"

	if [ -z "$ver" ]; then
		qtver-from-kdever $1
	fi
}

min-kdesvn-ver() {
    debug-print-function $FUNCNAME $*

    case $1 in
        7)          selected_version="7";;
    esac

	if [ -z "$selected_version" ]; then
		min-kde-ver $1
	fi
}


#kdesvn_sandbox_patch() {
#	kde_sandbox_patch "$@"
#}


kdesvn_remove_flag() {
    debug-print-function $FUNCNAME $*

    [ -z "${objdir}" ] && objdir=${S}
    cd ${objdir}/${1} || die
    [ -n "$2" ] || die

    cp Makefile Makefile.orig
    sed -e "/CFLAGS/ s/${2}//g
/CXXFLAGS/ s/${2}//g" Makefile.orig > Makefile

    cd $OLDPWD
}
