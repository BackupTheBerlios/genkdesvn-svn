# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdepim
KMMODULE=wizards
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KMNODOCS="true"
inherit kde-meta eutils kde-source

DESCRIPTION="KDEPIM wizards"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
OLDDEPEND="~kde-base/libkdepim-$PV
	~kde-base/libkcal-$PV
	~kde-base/certmanager-$PV
	~kde-base/kdepim-kresources-$PV
	~kde-base/libkpimidentities-$PV"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/certmanager)
$(deprange $PV $MAXKDEVER kde-base/kdepim-kresources)
$(deprange $PV $MAXKDEVER kde-base/libkpimidentities)
$(deprange $PV $MAXKDEVER kde-base/kaddressbook)"

KMCOPYLIB="
	libkcal libkcal
	libkdepim libkdepim
	libkpimidentities libkpimidentities
	libkabc_xmlrpc kresources/egroupware
	libkcal_xmlrpc kresources/egroupware
	libknotes_xmlrpc kresources/egroupware
	libkcal_slox kresources/slox
	libkabc_slox kresources/slox
	libkcal_groupwise kresources/groupwise
	libkabc_groupwise kresources/groupwise
	libkcalkolab kresources/kolab/kcal
	libkabckolab kresources/kolab/kabc
	libknoteskolab kresources/kolab/knotes
	libkcal_newexchange kresources/newexchange
	libkabc_newexchange kresources/newexchange"
KMEXTRACTONLY="
	libkdepim/
	libkcal/
	libkpimidentities/
	kresources/
	knotes/
	certmanager/lib/
	kmail"
KMCOMPILEONLY="
	libemailfunctions"
KMTARGETSONLY=(
	'kresources/slox .kcfgc'
	'kresources/lib .kcfgc'
	'kresources/egroupware .kcfgc'
	'kresources/groupwise .kcfgc')
