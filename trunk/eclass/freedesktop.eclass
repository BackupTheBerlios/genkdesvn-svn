# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: 
#

ECLASS="freedesktop"
INHERITED="$INHERITED $ECLASS"

ECVS_BRANCH=""

# If no module indicated in ebuild, assume package name is it
[ -z $EFDO_MODULE ] && EFDO_MODULE="$PN"
[ -z $EFDO_SUBDIR ] && EFDO_SUBDIR="$EFDO_MODULE"
ECVS_MODULE="$EFDO_SUBDIR" 

# If no user indicated in ebuild, assume anonymous login
[ -z $EFDO_USER ] && EFDO_USER="anoncvs"
ECVS_USER="$EFDO_USER"

# If no server indicated in ebuild, assume cvs.freedesktop.org
[ -z $EFDO_SERVER ] && EFDO_SERVER="cvs.freedesktop.org"
ECVS_SERVER="$EFDO_SERVER:/cvs/$EFDO_MODULE"

# 
S=$WORKDIR/$EFDO_SUBDIR

# Set homepage to project page on freedesktop
HOMEPAGE="http://www.freedesktop.org/Software/$EFDO_MODULE"

inherit cvs

function freedesktop_src_unpack() {

	cvs_src_unpack

}

EXPORT_FUNCTIONS src_unpack

