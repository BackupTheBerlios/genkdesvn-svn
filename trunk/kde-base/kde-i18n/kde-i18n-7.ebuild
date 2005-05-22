# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit kde eutils kde-source

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
SLOT="$PV"

need-kde ${PV}

pkg_setup() {

	if [ -z "$LINGUAS" ]; then
		echo
		eerror "You must define a LINGUAS environment variable that contains a list"
		eerror "of the language codes for which languages you would like to install."
		eerror "e.g.: LINGUAS=\"se de pt\""
		echo
		die
	fi

}

src_unpack() {

	ESCM_DEEPITEMS="KDE/kde-common/admin"
	ESCM_SHALLOWITEMS="KDE/kde-i18n"

	for lang in $LINGUAS
	do

		ESCM_SHALLOWITEMS="$ESCM_SHALLOWITEMS KDE/kde-i18n/$lang/messages"

	done

	subversion_src_unpack

	rm $S/subdirs
	for lang in $LINGUAS
	do

		if [ -d $S/$lang/messages ]; then
		
			ewarn "Including $lang as supported language"
			echo $lang >>$S/subdirs
			#cp $FILESDIR/Makefile.am $S/$lang/messages/

		fi

	done
	mv $WORKDIR/KDE/kde-common/admin $S/

}

src_compile() {

	kde_src_compile myconf configure
	for lang in $LINGUAS
	do

		[ -d $S/$lang/messages ] && cat $FILESDIR/Makefile >> $S/$lang/messages/Makefile

	done
	kde_src_compile make

}
