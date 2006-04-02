# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT=playground
KSCM_MODULE=base
KSCM_SUBDIR="${PN}"
inherit flag-o-matic kde kde-source

DESCRIPTION="The open source answer to WhereIsIt and Google Desktop Search"
HOMEPAGE="http://kat.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~ppc ~sparc"
IUSE="ext-doc ext-gnumeric ext-html ext-kpresenter ext-kspread ext-kword ext-mail ext-openoffice ext-pdf ext-ppt ext-ps ext-rtf ext-tex ext-xls xattr"

RDEPEND=">=dev-db/sqlite-3.2.1
	( || ( kde-base/kcontrol >=kde-base/kdebase-3.3 ) )
	ext-doc?	( app-text/antiword )
	ext-gnumeric?	( app-office/gnumeric )
	ext-html?	( app-text/html2text )
	ext-kpresenter?	( app-office/kpresenter )
	ext-kspread?	( app-office/kspread )
	ext-kword?	( app-office/kword )
	ext-mail?	( net-mail/mhonarc )
	ext-openoffice?	( virtual/ooo )
	ext-pdf?	( app-text/xpdf )
	ext-ppt?	( app-text/xlhtml )
	ext-ps?		( app-text/pstotext )
	ext-rtf?	( app-text/unrtf )
	ext-tex?	( dev-tex/untex )
	ext-xls?	( app-text/xlhtml )
	xattr?	( sys-apps/attr )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0
	!kde-misc/kat"

need-kde 3.3

src_compile() {
	# Filter fvisibility for now due to compile errors.
	filter-flags -fvisibility-inlines-hidden -fvisibility=hidden 

	PREFIX="`kde-config --prefix`"
	kde_src_compile
}

pkg_postinst() {
	if [ ! -e /dev/inotify ] ; then
		eerror "Your kernel does not seem to have inotify support enabled."
		eerror "In order to enable support for Kat's autoupdate deamon,"
		eerror "I suggest you install the latest sys-kernel/gentoo-sources"
		eerror "(or any other kernel with the inotify patch included)."
		eerror ""
		eerror "Enable Inotify file change notification support (INOTIFY)"
		eerror "within the kernel under Device Drivers / Character Devices."
		eerror "For more information regarding the use of Inotify and Kat:"
		eerror "https://infserver.unibz.it/kat/wiki/index.php/Getting_started"
		ebeep 10
	fi

	if use xattr; then
		einfo "You selected support for Extented attributes within Kat."
		einfo "You will need to set extended attributes on the file"
		einfo "systems that the autoupdate deamon of Kat is indexing."
		einfo "(Has to be supported by the kernel e.g. EXT2_FS_XATTR,"
		einfo "EXT3_FS_XATTR or REISERFS_FS_XATTR)"
		einfo ""
		einfo "To set extended attributes, you add 'user_xattr' to the"
		einfo "relevant file systems in your /etc/fstab file. For example:"
		einfo "/dev/hda3   /home  ext3	defaults,user_xattr	1 2"
		ebeep 10
	fi
}
