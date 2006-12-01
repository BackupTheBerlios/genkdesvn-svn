# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mario Tanev
# Purpose: 
#

inherit kdesvn-make

ECLASS="berlios"
INHERITED="$INHERITED $ECLASS"

# If no module indicated in ebuild, assume package name is it
[ -z $EBERLIOS_MODULE ] && EBERLIOS_MODULE="$PN"
ECVS_MODULE="$EBERLIOS_MODULE"

# If no user indicated in ebuild, assume anonymous login
[ -z $EBERLIOS_USER ] && EBERLIOS_USER="anonymous"
ECVS_USER="$EBERLIOS_USER"

# If no server indicated in ebuild, assume cvs.berlios.de
[ -z $EBERLIOS_SERVER ] && EBERLIOS_SERVER="cvs.berlios.de"
ECVS_SERVER="$EBERLIOS_SERVER:/cvsroot/$EBERLIOS_MODULE"

ECVS_BRANCH=""
S=$WORKDIR/$EBERLIOS_MODULE

inherit cvs
