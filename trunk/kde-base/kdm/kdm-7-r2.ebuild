# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta eutils kdesvn-source

DESCRIPTION="KDE login manager, similar to xdm and gdm"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="openexr pam"

KMEXTRA="kdmlib/"
KMEXTRACTONLY="libkonq/konq_defaults.h"
KMCOMPILEONLY="kcontrol/background"
DEPEND="$DEPEND
	pam? ( sys-libs/pam >=kde-base/kdebase-pam-5 )
	openexr? ( media-libs/openexr )
	$(deprange $PV $MAXKDEVER kde-base/kcontrol)"
	# Requires the desktop background settings and kdm modules,

# Avoid using imake (kde bug 114466)
PATCHES="${FILESDIR}/no-imake.patch"

src_compile() {
	local myconf="--with-x-binaries-dir=/usr/bin"

	if use pam; then
		myconf="${myconf} --with-pam=yes"
	else
		myconf="${myconf} --with-pam=no --with-shadow"
	fi

	# openEXR check
	myconf="${myconf} $(use_enable openexr)"

	kdesvn-meta_src_compile myconf configure
	kde_remove_flag kdm/kfrontend -fomit-frame-pointer
	kdesvn-meta_src_compile make
}

src_install() {
	kdesvn-meta_src_install
	cd ${S}/kdm && make DESTDIR=${D} GENKDMCONF_FLAGS="--no-old --no-backup --no-in-notice" install

	# Customize the kdmrc configuration
	sed -i -e "s:#SessionsDirs=:SessionsDirs=/usr/share/xsessions\n#SessionsDirs=:" \
		${D}/${KDEDIR}/share/config/kdm/kdmrc || die
}

pkg_postinst() {
	subversion_pkg_postinst

	# set the default kdm face icon if it's not already set by the system admin
	# because this is user-overrideable in that way, it's not in src_install
	if [ ! -e "${ROOT}${KDEDIR}/share/apps/kdm/faces/.default.face.icon" ];	then
		mkdir -p "${ROOT}${KDEDIR}/share/apps/kdm/faces"
		cp "${ROOT}${KDEDIR}/share/apps/kdm/pics/users/default1.png" \
		    "${ROOT}${KDEDIR}/share/apps/kdm/faces/.default.face.icon"
	fi
	if [ ! -e "${ROOT}${KDEDIR}/share/apps/kdm/faces/root.face.icon" ]; then
		mkdir -p "${ROOT}${KDEDIR}/share/apps/kdm/faces"
		cp "${ROOT}${KDEDIR}/share/apps/kdm/pics/users/root1.png" \
			"${ROOT}${KDEDIR}/share/apps/kdm/faces/root.face.icon"
	fi
}
