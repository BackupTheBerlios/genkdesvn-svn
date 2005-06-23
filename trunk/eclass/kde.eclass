# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde.eclass,v 1.115 2005/02/17 14:58:30 greg_g Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# Revisions Caleb Tennis <caleb@gentoo.org>
# The kde eclass is inherited by all kde-* eclasses. Few ebuilds inherit straight from here.

inherit base eutils kde-functions
ECLASS=kde
INHERITED="$INHERITED $ECLASS"
DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://www.kde.org/"
IUSE="${IUSE} debug arts xinerama kdeenablefinal"

DEPEND=">=sys-devel/automake-1.7.0
	sys-devel/autoconf
	sys-devel/make
	dev-util/pkgconfig
	dev-lang/perl
	~kde-base/kde-env-3"

RDEPEND="~kde-base/kde-env-3"

# overridden in other places like kde-dist, kde-source and some individual ebuilds
SLOT="0"

function unsermake_setup() {

	make_cmd=make
	make=make
	emake=emake
	unsermake_pkg='~kde-base/unsermake-7'

	if ( hasq unsermake $FEATURES ); then

		if ( has_version $unsermake_pkg ); then

			if ( ! hasq unsermake $RESTRICT ); then

				addwrite "/usr/kde/unsermake"
				export PATH="$PATH:/usr/kde/unsermake"

				make_cmd=unsermake
				make="${make_cmd}"
				emake="${make_cmd}"

				## add UNSERMAKEOPTS if found
				if [ -n ${UNSERMAKEOPTS} ]; then
					make="${make} ${UNSERMAKEOPTS}"
					emake="${emake} ${UNSERMAKEOPTS}"
				fi
				
				if [ -n "$1" ] && [ $1 == info ]; then
				
					ewarn "Unsermake will be used as the make tool for this operation"
					ewarn "To disable it, remove unsermake from FEATURES in /etc/make.conf"

				fi

			elif [ -n "$1" ] && [ $1 == info ]; then

				ewarn "Ebuild prohibits use of unsermake, even though it is installed and enabled"
				ewarn "Unsermake will NOT be used as the make tool for this operation"
			
			fi

		elif [ -n "$1" ] && $1 == info ]; then

			ewarn "FEATURES=unsermake has been set, however $unsermake_pkg is not installed"
			ewarn "Unsermake will NOT be used as the make tool for this operation"

		fi

	elif ( has_version $unsermake_pkg -a $1 == info ); then

		ewarn "$unsermake_pkg is installed, but FEATURES=unsermake has not been set"
		ewarn "Unsermake will NOT be used as the make tool for this operation"

	fi

}

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
	eval unsermake_setup info
}

kde_src_unpack() {

	debug-print-function $FUNCNAME $*
	
	# call base_src_unpack, which implements most of the functionality and has sections,
	# unlike this function. The change from base_src_unpack to kde_src_unpack is thus
	# wholly transparent for ebuilds.
	base_src_unpack $*
	
	# kde-specific stuff stars here
	
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

	# temp fix for bug #78720, until the real bug in gcc gets fixed
	# briefly, -fvisibility-inlines-hidden is broken on amd64 and ppc
	# this only applies to kde 3.4. the grep prevents us from removing configure unnecessarily.
	if useq amd64 || useq ppc; then
		if grep -- '-fvisibility=hidden -fvisibility-inlines-hidden' admin/acinclude.m4.in >/dev/null; then
			sed -i -e 's:-fvisibility=hidden -fvisibility-inlines-hidden:-fvisibility=hidden:' admin/acinclude.m4.in
			rm -f configure
		fi
	fi
}

kde_src_compile() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && kde_src_compile all

	eval unsermake_setup

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
				myconf="$myconf --host=${CHOST} --prefix=${PREFIX} --with-x --enable-mitshm $(use_with xinerama) --with-qt-dir=${QTDIR} --enable-mt --with-qt-libraries=${QTDIR}/$(get_libdir)"
				# calculate dependencies separately from compiling, enables ccache to work on kde compiles
				[ ! $make_cmd == unsermake ] && myconf="$myconf --disable-dependency-tracking"
				if use debug ; then
					myconf="$myconf --enable-debug=full --with-debug"
				else
					myconf="$myconf --disable-debug --without-debug"
				fi
				if useq kdeenablefinal && [ -n "$KDEBASE" ]; then
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
						debug-print "$FUNCNAME: configure: generating configure script, running $make -f $makefile"
						$make -f $makefile
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

				./configure \
					${myconf} \
					--libdir="\${exec_prefix}/$(get_libdir)" \
					|| die "died running ./configure, $FUNCNAME:configure"
					
				# Seems ./configure add -O2 by default but hppa don't want that but we need -ffunction-sections
				if [ "${ARCH}" = "hppa" ]
				then
					einfo Fixating Makefiles
					find ${S} -name Makefile | while read a; do sed -e s/-O2/-ffunction-sections/ -i "${a}" ; done
				fi
				;;
			make)
				export PATH="${KDEDIR}/bin:${PATH}"
				debug-print-section make
				if [ $make_cmd == unsermake ] ; then
					# Some apps use KSCM to state directories
					if [ -z "$MODULE_DIR" -a -n "$KSCM_SUBDIR" ]; then
						MODULE_DIR="$KSCM_SUBDIR"
					fi

					# unsermake expects to be called from within module directory, so ...
					if [ -n "$MODULE_DIR" -a -d "$MODULE_DIR" ]; then
						cd "$MODULE_DIR" || die "Cannot cd to $MODULE_DIR"
					fi

				fi
				$emake || die "died running $emake, $FUNCNAME:make"
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

	eval unsermake_setup

	cd ${S}

	while [ "$1" ]; do

		case $1 in
			make)
				debug-print-section make
				$make install DESTDIR=${D} destdir=${D} || die "died running $make install, $FUNCNAME:make"
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
