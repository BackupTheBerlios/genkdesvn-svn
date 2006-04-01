# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Original Author:
#	Stefan Vunckx <stefan.vunckx@skynet.be>
#
# This is the kofficesvn eclass.

KMNAME=koffice

inherit kdesvn-meta multilib eutils kdesvn-source
IUSE="python ruby"

# location of koffice in SVN
KSCM_ROOT="branches/koffice/1.6/"

# Add a blocking dep on the package we're derived from
DEPEND="${DEPEND} 
	!=$(get-parent-package ${CATEGORY}/${PN})-${SLOT}*
	dev-util/pkgconfig"

RDEPEND="
		${RDEPEND} !=$(get-parent-package ${CATEGORY}/${PN})-${SLOT}*
		python? ( virtual/python )
    	ruby? ( dev-lang/ruby )"

# dependency on kde
need-kde 3.4

# koffice is NOT installed in slots
SLOT="0"
MAXKOFFICEVER="7"

function kofficesvn_src_unpack() {
	debug-print-function $FUNCNAME $*

	kdesvn-source_src_unpack "$@"
}

function kofficesvn_src_compile() {
	debug-print-function $FUNCNAME $*

	## Koffice configuration
	# enable scripting if one of the script USE flags is set
	if use python || use ruby; then
		myconf="$myconf--enable-scripting"
	else
		myconf="$myconf --disable-scripting"
	fi

	# dis/enable python
	use python && myconf="$myconf --with-pythondir=${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages"

	# TODO: 
	# Ruby gets picked up if it's installed so nothing else to do then make it a dep for koffice

	kdesvn-meta_src_compile "$@"
}

function kofficesvn_src_install() {
	debug-print-function $FUNCNAME $*

	kdesvn-meta_src_install "$@"
}

EXPORT_FUNCTIONS src_unpack src_compile src_install