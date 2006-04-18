# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Original Author:
#	Stefan Vunckx <stefan.vunckx@skynet.be>
#
# This is the kofficesvn eclass.

# indicate these are koffice ebuilds to kdesvn-meta (must be set before kdesvn-meta inherit !!!)
KMNAME=koffice

# location of koffice in SVN
[ -z "${KSCM_ROOT}" ] && KSCM_ROOT="branches/koffice/1.6/"

inherit kdesvn-meta multilib eutils kdesvn-source
IUSE=""

# Add a blocking dep on the package we're derived from
DEPEND="
	${DEPEND} 
	!=$(get-parent-package ${CATEGORY}/${PN})-${SLOT}*
	dev-util/pkgconfig"

RDEPEND="
	${RDEPEND} !=$(get-parent-package ${CATEGORY}/${PN})-${SLOT}*"

# dependency on kde
need-kde 3.4

# koffice is NOT installed in slots
SLOT="0"
MAXKOFFICEVER="7"

function kofficesvn_src_unpack() {
	debug-print-function $FUNCNAME $*

	kdesvn-source_src_unpack "$@"

	create_fullpaths
}

function kofficesvn_src_compile() {
	debug-print-function $FUNCNAME $*

	kdesvn-meta_src_compile "$@"
}

function kofficesvn_src_install() {
	debug-print-function $FUNCNAME $*

	kdesvn-meta_src_install "$@"
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
