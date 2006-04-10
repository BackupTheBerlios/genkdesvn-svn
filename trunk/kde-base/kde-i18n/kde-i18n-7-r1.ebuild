# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

I18N_PATH="trunk/l10n"
I18N_FILES="charset entry.desktop flag.png"
for lang in ${LINGUAS}
do
	for file in ${I18N_FILES}
	do
		ESCM_DEEPITEMS="${ESCM_DEEPITEMS} ${I18N_PATH}/${lang}/messages/$file"
	done
done
inherit kdesvn-functions kdesvn-source

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://i18n.kde.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RESTRICT="nostrip"
need-kde ${PV}

S=${WORKDIR}/${I18N_PATH}

src_unpack() {
	[ -n "$LINGUAS" ] && svn_src_unpack
}

src_install() {
	[ -n "$LINGUAS" ] && for lang in ${LINGUAS}
	do
		for file in ${I18N_FILES}
		do
			install -D ${lang}/messages/$file ${D}/${PREFIX}/share/locale/${lang}/$file
		done
	done
}

pkg_postinst() {
	if [ -n "$LINGUAS" ]
	then
		svn_pkg_postinst
	else
		ewarn "This package was installed with no data, since LINGUAS has not been defined."
		ewarn "Thus you will be unable to switch languages from the KDE control center"
		ewarn "Reemerge with defined LINGUAS to be able to do so."
	fi
}
