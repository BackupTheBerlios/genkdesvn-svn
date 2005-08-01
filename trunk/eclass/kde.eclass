# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde.eclass,v 1.115 2005/02/17 14:58:30 greg_g Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# Revisions Caleb Tennis <caleb@gentoo.org>
# The kde eclass is inherited by all kde-* eclasses. Few ebuilds inherit straight from here.

inherit base eutils kde-functions keepobj unsermake
ECLASS=kde
INHERITED="$INHERITED $ECLASS"
DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://www.kde.org/"
IUSE="${IUSE} debug arts xinerama kdeenablefinal"

DEPEND="$DEPEND >=sys-devel/automake-1.7.0
	sys-devel/autoconf
	sys-devel/make
	dev-util/pkgconfig
	dev-lang/perl
	~kde-base/kde-env-3
	>=kde-base/unsermake-7-r1"

RDEPEND="~kde-base/kde-env-3"

# overridden in other places like kde-dist, kde-source and some individual ebuilds
SLOT="0"

kde_pkg_setup() {
	if [ "${PN}" != "arts" ] && [ "${PN}" != "kdelibs" ] ; then
		use arts && if ! built_with_use kdelibs arts ; then
			eerror "You are trying to compile ${CATEGORY}/${P} with the \"arts\" USE flag enabled."
			eerror "However, $(best_version kdelibs) was compiled with this flag disabled."
			eerror
			eerror "You must either disable this use flag, or recompile"
			eerror "$(best_version kdelibs) with this use flag enabled."
			die
		fi
	fi
}

kde_src_unpack() {

	debug-print-function $FUNCNAME $*
	
	# call base_src_unpack, which implements most of the functionality and has sections,
	# unlike this function. The change from base_src_unpack to kde_src_unpack is thus
	# wholly transparent for ebuilds.
	base_src_unpack $*
	
	# kde-specific stuff stars here
	
	# Don't touch anything if we're keeping files
	if [ ! $(keepobj_enabled) ]
	then
		# fix the 'languageChange undeclared' bug group: touch all .ui files, so that the
		# makefile regenerate any .cpp and .h files depending on them.
		cd $S
		debug-print "$FUNCNAME: Searching for .ui files in $PWD"
		UIFILES="`find . -name '*.ui' -print`"
		debug-print "$FUNCNAME: .ui files found:"
		debug-print "$UIFILES"
		# done in two stages, because touch doens't have a silent/force mode
		if [ -n "$UIFILES" ]; then
			debug-print "$FUNCNAME: touching .ui files..."
			touch $UIFILES
		fi
	fi

	# Visiblity stuff is way broken! Just disable it when it's present
	# until upstream finds a way to have it working right.
	if grep KDE_ENABLE_HIDDEN_VISIBILITY configure.in &> /dev/null || ! [[ -f configure ]]; then
		find ${S} -name configure.in.in | xargs sed -i -e 's:KDE_ENABLE_HIDDEN_VISIBILITY::g'
		rm -f configure
	fi
}

kde_src_compile() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && kde_src_compile all

	# Ugly, ugly, ugly hack to make apps use qt-7
	has_version '>=x11-libs/qt-7' && export QTDIR="/usr/qt/devel" || export QTDIR="/usr/qt/3"

	cd ${S}
	export kde_widgetdir="$KDEDIR/$(get_libdir)/kde3/plugins/designer"

	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox, so that the build process
	# can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"
	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"	
	
	while [ "$1" ]; do

		case $1 in
			myconf)
				debug-print-section myconf
				myconf="$myconf --host=${CHOST} --prefix=${PREFIX} --with-x --enable-mitshm $(use_with xinerama) --with-qt-dir=${QTDIR} --enable-mt --enable-pch --with-qt-libraries=${QTDIR}/$(get_libdir)"
				if use debug ; then
					myconf="$myconf --enable-debug=full --with-debug"
				else
					myconf="$myconf --disable-debug --without-debug"
				fi
				if [ $(keepcache_enabled) ]; then
					myconf="$myconf --config-cache"
				fi
				if [ ! $(keepobj_enabled) ]; then
					myconf="$myconf --disable-dependency-tracking"
				fi
				if useq kdeenablefinal && [ ! $(keepobj_enabled) ] && [ -n "$KDEBASE" ]; then
					myconf="$myconf --enable-final"
				else
					myconf="$myconf --disable-final"
				fi
				[ -z "$KDEBASE" ] && myconf="$myconf $(use_with arts)"
				[ -n "$KDEBASE" -a "$KDEMINORVER" -ge 3 ] && myconf="$myconf $(use_with arts)"
				[ -n "$KDEBASE" -a "$KDEMAJORVER" -ge 4 ] && myconf="$myconf $(use_with arts)"
				debug-print "$FUNCNAME: myconf: set to ${myconf}"
				;;
			configure)
				debug-print-section configure
				debug-print "$FUNCNAME::configure: myconf=$myconf"

				# rebuild configure script, etc
				# This can happen with e.g. a cvs snapshot			
				if [ ! -f "./configure" ]; then
					for x in Makefile.cvs admin/Makefile.common; do
						if [ -f "$x" ] && [ -z "$makefile" ]; then makefile="$x"; fi
					done
					if [ -f "$makefile" ]; then
						debug-print "$FUNCNAME: configure: generating configure script, running $(automake_cmd) $makefile"
						$(automake_cmd) $makefile
					fi
					[ -f "./configure" ] || die "no configure script found, generation unsuccessful"
				fi

				export PATH="${KDEDIR}/bin:${PATH}"
				
				# configure doesn't need to know about the other KDEs installed.
				# in fact, if it does, it sometimes tries to use the wrong dcopidl, etc.
				# due to the messed up way configure searches for things
				export KDEDIRS="${PREFIX}:${KDEDIR}"

				cd $S

				# If we're not a kde-base ebuild, then set up the /usr directories properly
				# Perhaps this could get changed later to use econf instead?
				if [ $PREFIX = "/usr" ]; then
					myconf="${myconf} --mandir=/usr/share/man --infodir=/usr/share/info --datadir=/usr/share --sysconfdir=/etc --localstatedir=/var/lib"
				fi

				# Use libsuffix instead of libdir to keep kde happy
				if [ $(get_libdir) != "lib" ] ; then
					myconf="${myconf} --enable-libsuffix=$(get_libdir | sed s/lib//)"
				fi

				keepobj $(srcdir)/configure ${myconf} || die "died running $(srcdir)/configure, $FUNCNAME:configure"
					
				# Seems ./configure add -O2 by default but hppa don't want that but we need -ffunction-sections
				if [ "${ARCH}" = "hppa" ]
				then
					einfo Fixating Makefiles
					find $(objdir) -name Makefile | while read a; do sed -e s/-O2/-ffunction-sections/ -i "${a}" ; done
				fi
				;;
			make)
				export PATH="${KDEDIR}/bin:${PATH}"
				debug-print-section make
				if [ "$UNSERMAKE" != "no" ] ; then
					# Some apps use KSCM to state directories
					if [ -z "$MODULE_DIR" -a -n "$KSCM_SUBDIR" ]; then
						MODULE_DIR="$KSCM_SUBDIR"
					fi

					# unsermake expects to be called from within module directory, so ...
					if [ -n "$MODULE_DIR" -a -d "$MODULE_DIR" ]; then
						cd "$MODULE_DIR" || die "Cannot cd to $MODULE_DIR"
					fi

				fi
				keepobj $(emake_cmd) || die "died running $(emake_cmd), $FUNCNAME:make"
				;;
			all)
				debug-print-section all
				kde_src_compile myconf configure make
				;;
		esac

	shift
	done

}

kde_src_install() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && kde_src_install all

	cd ${S}

	while [ "$1" ]; do

		case $1 in
			make)
				debug-print-section make
				keepobj $(make_cmd) install DESTDIR=${D} destdir=${D} || die "died running $(make_cmd) install, $FUNCNAME:make"
				;;
	    	dodoc)
				debug-print-section dodoc
				for doc in AUTHORS ChangeLog* README* COPYING NEWS TODO; do
					[ -s "$doc" ] && dodoc $doc
				done
				;;
	    	all)
				debug-print-section all
				kde_src_install make dodoc
				;;
		esac

	shift
	done

}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install
