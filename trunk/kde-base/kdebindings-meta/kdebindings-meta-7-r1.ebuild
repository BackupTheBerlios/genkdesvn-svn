# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	kalyptus
	kdejava
	kjsembed
	pykde
	qtjava
	smoke"
inherit kdesvn-meta-parent

DESCRIPTION="kdebindings - merge this to pull in all kdebindings-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="$RDEPEND
>=kde-base/dcopperl-$PV
>=kde-base/dcoppython-$PV
>=kde-base/korundum-$PV
>=kde-base/qtruby-$PV"

# Omitted: qtsharp, dcopc, dcopjava, xparts (considered broken by upstream) 
