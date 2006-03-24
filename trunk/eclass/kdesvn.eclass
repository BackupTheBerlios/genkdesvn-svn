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
# The kdesvn eclass is inherited by all kdesvn-* eclasses. Few ebuilds inherit straight from here.

inherit base eutils kde kdesvn-functions
ECLASS=kdesvn
INHERITED="$INHERITED $ECLASS"
SLOT="0"

# Touch all files for a given extension, so that the
# makefile regenerates any (.cpp and/or .h) files depending on them
kdesvn_touch_files() {
	debug-print-function $FUNCNAME $*

	EXTENSION="$1"
    cd $S
    debug-print "$FUNCNAME: Searching for ${EXTENSION} files in $PWD"
    FILES="`find . -name "*${EXTENSION}" -print`"
    debug-print "$FUNCNAME: ${EXTENSION} files found:"
    debug-print "$UIFILES"
    # done in two stages, because touch doens't have a silent/force mode
    if [ -n "$FILES" ]; then
        debug-print "$FUNCNAME: touching ${EXTENSION} files..."
        touch $FILES
    fi
}

kdesvn_touch_all_files() {
	kdesvn_touch_files ".ui"
	kdesvn_touch_files ".kcfgc"
}

# checks for arts support if arts USE flag is set
kdesvn_pkg_setup() {
	debug-print-function $FUNCNAME $*
	kde_pkg_setup
}

# unpack function for KDE
kdesvn_src_unpack() {
	debug-print-function $FUNCNAME $*
	kde_src_unpack

	kdesvn_touch_all_files
}

# compiles the code for the KDE app
kdesvn_src_compile() {
    debug-print-function $FUNCNAME $*
    [ -z "$1" ] && kdesvn_src_compile all

   # Ugly, ugly, ugly hack to make apps use qt-7
    has_version '>=x11-libs/qt-7' && export QTDIR="/usr/qt/devel" || export QTDIR="/usr/qt/3"

    while [ "$1" ]; do

        case $1 in
            myconf)
                debug-print-section myconf

				# run portage's KDE eclass
				kde_src_compile myconf

				# KDESVN specific stuff:
				myconf="${myconf} --host=${CHOST}" # set somewhere else ??
				[ -n "$KDEBASE" ] && myconf="${myconf} $(use_with arts)" # kde.eclass' code relies on $KDEMINORVER eg 3 :(

                debug-print "$FUNCNAME: myconf: set to ${myconf}"
				;;
			configure)
                debug-print-section configure
                debug-print "$FUNCNAME::configure: myconf=${myconf}"

				# KDESVN specific stuff
				kdesvn-make_configure "${myconf}"

				# run portage's KDE eclass
				kde_src_compile configure				
				;;
			make)
				debug-print-section make

				# run portage's KDE eclass
				kde_src_compile make

				# KDESVN specific stuff
				# nothing atm :-)
				;;
			all)
				debug-print-section all
				kdesvn_src_compile myconf configure make
				;;
		esac

	shift
	done
}

# installs the KDE app
kdesvn_src_install() {
    debug-print-function $FUNCNAME $*
    [[ -z "$1" ]] && kdesvn_src_install all

    cd ${S}

    while [[ "$1" ]]; do

        case $1 in
            make)
                debug-print-section make

				# run portage's KDE eclass
				kde_src_install make

				# KDESVN specific stuff
				# nothing atm :-)
                ;;
            dodoc)
                debug-print-section dodoc

				# run portage's KDE eclass
				kde_src_install dodoc

				# KDESVN specific stuff
				# nothing atm :-)
                ;;
            all)
                debug-print-section all
                kdesvn_src_install make dodoc
                ;;
        esac

    shift
    done
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install
