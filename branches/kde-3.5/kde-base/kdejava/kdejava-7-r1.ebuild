# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

KMNAME=kdebindings
KMEXTRACTONLY=qtjava
KMCOPYLIB="libqtjavasupport qtjava/javalib/qtjava"
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kdesvn-meta kdesvn-source

DESCRIPTION="KDE java bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
COMMONDEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/kwin)
	$(deprange-dual $PV $MAXKDEVER kde-base/kcontrol)
	$(deprange $PV $MAXKDEVER kde-base/qtjava)"
DEPEND="virtual/jdk $COMMONDEPEND"
RDEPEND="virtual/jre $COMMONDEPEND"

PATCHES="$FILESDIR/no-gtk-glib-check.diff $FILESDIR/kdejava-3.4.0_rc1-classpath.diff"


# Probably missing other kdebase, kdepim etc deps
# Needs to be compiled with just kdelibs installed to make sure

# Someone who knows about java-in-gentoo should look at this and the
# other java kdebindings, and fix the stupid thing
src_unpack() {
	kdesvn-source_src_unpack

	# $PREFIX-dependant, so don't go into the makefile tarballs
	cd $S/kdejava/koala/org/kde/koala
	for x in Makefile.am Makefile.in; do
		mv $x $x.orig
		sed -e "s:_CLASSPATH_:$(java-config -p qtjava):" $x.orig > $x
		rm $x.orig
	done
}

src_compile() {
	myconf="$myconf --with-java=`java-config --jdk-home`"
	kdesvn-meta_src_compile
}
