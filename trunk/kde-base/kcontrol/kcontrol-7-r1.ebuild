# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
KSCM_L10N_PO="kcontrol \"kcm*\" filetypes kaccess kthememanager"
[ -n "$LINGUAS" ] && ESCM_SHALLOWITEMS="l10n/scripts"
for lang in $LINGUAS
do

	ESCM_SHALLOWITEMS="$ESCM_SHALLOWITEMS trunk/l10n/$lang/messages"

done
inherit kde-meta eutils kde-source

DESCRIPTION="The KDE Control Center"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE="ssl arts ieee1394 logitech-mouse opengl"
PATCHES="$FILESDIR/configure.in.in-kdm-settings.diff"

DEPEND="ssl? ( dev-libs/openssl )
	arts? ( $(deprange $PV $MAXKDEVER kde-base/arts) )
	opengl? ( virtual/opengl )
	ieee1394? ( sys-libs/libraw1394 )
	logitech-mouse? ( >=dev-libs/libusb-0.1.10a )"

RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kcminit)
$(deprange $PV $MAXKDEVER kde-base/kdebase-data)"

KMEXTRACTONLY="kicker/kicker/core/kicker.h
	    kicker/kicker/core/kickerbindings.cpp
	    kicker/taskbar/taskbarbindings.cpp
	    kwin/kwinbindings.cpp
	    kdesktop/kdesktopbindings.cpp
	    klipper/klipperbindings.cpp
	    kxkb/kxkbbindings.cpp
	    libkonq/
	    kioslave/thumbnail/configure.in.in" # for the HAVE_LIBART test

# The order of these dependencies is important
KMCOMPILEONLY="kicker/libkicker kicker/taskmanager kicker/taskbar"

src_unpack() {

	kde-source_src_unpack	
	cp -r $S/admin $WORKDIR/l10n/scripts

}

src_compile() {

	local _S=$S
	pushd $WORKDIR/trunk/l10n >/dev/null
	scripts/autogen.sh $LINGUAS
	for lang in $LINGUAS
	do

		S=$WORKDIR/trunk/l10n/$lang	
		[ -d $S/messages ] && cat $FILESDIR/Makefile.l10n >> $S/messages/Makefile.in && kde_src_compile

	done
	popd >/dev/null
	S=$_S
	
	myconf="$myconf `use_with ssl` `use_with arts` `use_with opengl gl`"
	kde-meta_src_compile

}

src_install() {

	for lang in $LINGUAS
	do

		if [ -d $WORKDIR/trunk/l10n/$lang/messages ]; then
		
			pushd $WORKDIR/trunk/l10n/$lang >/dev/null
			make DESTDIR=${D} install
			popd >/dev/null

		fi

	done
	kde-meta_src_install

}
