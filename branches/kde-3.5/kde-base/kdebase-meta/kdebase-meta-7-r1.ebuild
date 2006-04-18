# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KMSUBMODULES="
	kdebase-startkde
	drkonqi
	kappfinder
	kate
	kcheckpass
	kcminit
	kcontrol
	kdcop
	kdebugdialog
	kdepasswd
	kdeprint
	kdesktop
	kdesu
	kdialog
	kdm
	kfind
	khelpcenter
	khotkeys
	kicker
	kdebase-kioslaves
	klipper
	kmenuedit
	konqueror
	konsole
	kpager
	kpersonalizer
	kreadconfig
	kscreensaver
	ksmserver
	ksplashml
	kstart
	ksysguard
	ksystraycmd
	ktip
	kwin
	kxkb
	libkonq
	nsplugins
	knetattach
	kdebase-data"
inherit kdesvn-meta-parent

DESCRIPTION="kdebase - merge this to pull in all kdebase-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="$PV"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

