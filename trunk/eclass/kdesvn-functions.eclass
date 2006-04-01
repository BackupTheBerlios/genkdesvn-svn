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
kde-base/kdebindings kde-base/pykde
kde-base/kdegames kde-base/kanagram
kde-base/kdegames kde-base/blinken
"

# ---------------------------------------------------------------
# kde/qt directory management etc. functions, was kde-dirs.ebuild
# ---------------------------------------------------------------
# these functions overwrite the ones in kde-functions.eclass
# ---------------------------------------------------------------

need-kdesvn() {
	need-kde "$@"
}

need-kde() {
    debug-print-function $FUNCNAME $*
    KDEVER="7"

	# determine install locations
	set-kdedir

	need-autoconf 2.5
	need-automake 1.7

    if [ -n "${KDEBASE}" ]; then
        if [ -n "${KM_DEPRANGE}" ]; then
            DEPEND="${DEPEND} $(deprange ${KM_DEPRANGE} kde-base/kdelibs)"
            [ "${RDEPEND-unset}" != "unset" ] && RDEPEND="${RDEPEND} $(deprange ${KM_DEPRANGE} kde-base/kdelibs)"
        elif [ -z "${KDEVER}" ]; then
            DEPEND="${DEPEND} ~kde-base/kdelibs-$PV"
            [ "${RDEPEND-unset}" != "unset" ] && RDEPEND="${RDEPEND} ~kde-base/kdelibs-${PV}"
        else
            min-kde-ver ${KDEVER}
            DEPEND="${DEPEND} >=kde-base/kdelibs-${selected_version}"
            [ "${RDEPEND-unset}" != "unset" ] && RDEPEND="${RDEPEND} >=kde-base/kdelibs-${selected_version}"
        fi
    else
        # Things outside kde-base only need a minimum version
        min-kde-ver ${KDEVER}
        DEPEND="${DEPEND} >=kde-base/kdelibs-${selected_version}"
        [ "${RDEPEND-unset}" != "unset" ] && RDEPEND="${RDEPEND} >=kde-base/kdelibs-${selected_version}"
    fi


	# Set Qt versions
	qtver-from-kdever ${KDEVER}
	need-qt ${selected_version}

    if [ -n "${KDEBASE}" ]; then
        SLOT="$KDEMAJORVER.$KDEMINORVER"
		#SLOT="7.0"
    else
        SLOT="0"
    fi
}

set-kdedir() {
    debug-print-function $FUNCNAME $*

    # get version elements
    IFSBACKUP="$IFS"
    IFS=".-_"
    for x in "7"; do
        if [ -z "$KDEMAJORVER" ]; then KDEMAJORVER=$x
        else if [ -z "$KDEMINORVER" ]; then KDEMINORVER=$x
        else if [ -z "$KDEREVISION" ]; then KDEREVISION=$x
        fi; fi; fi
    done
    [ -z "$KDEMINORVER" ] && KDEMINORVER="0"
    [ -z "$KDEREVISION" ] && KDEREVISION="0"
    IFS="$IFSBACKUP"
    debug-print "$FUNCNAME: version breakup: KDEMAJORVER=$KDEMAJORVER KDEMINORVER=$KDEMINORVER KDEREVISION=$KDEREVISION"

    # install prefix
    if [ -n "$KDEPREFIX" ]; then
        export PREFIX="$KDEPREFIX"
    else
        if [ -z "$KDEBASE" ]; then
			# install in /usr if this is not a kde-base package
			export PREFIX="/usr"
			export KDEPREFIX="/usr"
		else
			export PREFIX="/usr/kde/devel"
			export KDEPREFIX="/usr/kde/devel"
		fi
    fi

    # kdelibs location
    if [ -n "$KDELIBSDIR" ]; then
        export KDEDIR="$KDELIBSDIR"
    else
		# all packages inheriting this eclass should link against the kdelibs from SVN
		export KDEDIR="/usr/kde/devel"
		export KDELIBSDIR="/usr/kde/devel"
    fi

    debug-print "$FUNCNAME: Will use the kdelibs installed in $KDEDIR, and install into $PREFIX."
}

need-qt() {
    debug-print-function $FUNCNAME $*
    QTVER="$1"

    QT=qt

    if [ "${RDEPEND-unset}" != "unset" ] ; then
        x_DEPEND="${RDEPEND}"
    else
        x_DEPEND="${DEPEND}"
    fi

	DEPEND="${DEPEND} $(qt-copy_min_version ${QTVER})"
	RDEPEND="${x_DEPEND} $(qt-copy_min_version ${QTVER})"
}

# returns minimal qt version needed for specified kde version
qtver-from-kdever() {
    debug-print-function $FUNCNAME $*

    local ver

    case $1 in
        7)  ver=7.0;; # subversion
			#ver=3.3
    esac

    selected_version="$ver"
}

min-kde-ver() {
    debug-print-function $FUNCNAME $*

	selected_version="7"
}