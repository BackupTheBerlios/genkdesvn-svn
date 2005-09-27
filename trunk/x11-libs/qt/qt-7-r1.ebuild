# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KSCM_ROOT="branches/qt/3.3/"
KSCM_MODULE="qt-copy"
inherit eutils flag-o-matic toolchain-funcs kde-repo

SRCTYPE="free"
DESCRIPTION="QT version ${PV}"
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( QPL-1.0 GPL-2 )"

SLOT="${PV}"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="cups debug doc examples firebird gif ipv6 mysql nas odbc opengl postgres sqlite symbol_visibility xinerama zlib"

DEPEND="virtual/x11 virtual/xft
	media-libs/libpng
	media-libs/jpeg
	media-libs/libmng
	>=media-libs/freetype-2
	nas? ( >=media-libs/nas-1.5 )
	mysql? ( dev-db/mysql )
	firebird? ( dev-db/firebird )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( dev-db/postgresql )
	cups? ( net-print/cups )
	zlib? ( sys-libs/zlib )"
PDEPEND="odbc? ( ~dev-db/qt-unixODBC-3.3.5)"

QTBASE=/usr/qt/devel

pkg_setup() {
	export QTDIR=${S}

	CXX=$(tc-getCXX)
	if [[ ${CXX/g++/} != ${CXX} ]]; then
		PLATCXX="g++"
	elif [[ ${CXX/icc/} != ${CXX} ]]; then
		PLATCXX="icc"
	else
		die "Unknown compiler ${CXX}."
	fi

	if use kernel_linux; then
		PLATNAME="linux"
	elif use kernel_FreeBSD && use elibc_FreeBSD; then
		PLATNAME="freebsd"
	elif use kernel_Darwin && use elibc_Darwin; then
		PLATNAME="darwin"
	else
		die "Unknown platform."
	fi

	# probably this should be '*-64' for 64bit archs
	# in a fully multilib environment (no compatibility symlinks)
	export PLATFORM="${PLATNAME}-${PLATCXX}"
}

src_unpack() {
	kde-repo_src_unpack
	mkdir ${S}/include/private
	cd ${S}
	./apply_patches || die "apply_patches failed"
	make -f Makefile.cvs

	sed -i -e 's:read acceptance:acceptance=yes:' configure

	# Do not link with -rpath. See bug #75181.
	find ${S}/mkspecs -name qmake.conf | xargs \
		sed -i -e 's:QMAKE_RPATH.*:QMAKE_RPATH =:'

	# patches for gcc4
	epatch "${FILESDIR}/${P}-gcc4.patch"

	# patch for qt symbol visibilty support, if >=gcc-4.0.0
	# see http://bugs.kde.org/show_bug.cgi?id=109386
	if use symbol_visibility; then
		if [[ "$(gcc-major-version)" == "4" ]]; then
			epatch "${FILESDIR}/${P}-visibility.patch"
			einfo "Symbol visibility support: auto"
			USE_SYBMBOL_VISIBILITY="yes"
		else
			einfo "Symbol visibility support: disabled"
			ewarn "You need >=sys-devel/gcc-4.0.0 for symbol visibility"
			ewarn "Then recompile qt AND kdelibs with the rest of KDE"
			ewarn "Dont try if you dont know what you're doing"
		fi
	else
		einfo "Symbol visibility support: disabled"
	fi

	if use ppc-macos ; then
		epatch ${FILESDIR}/${P}-macos.patch
	fi

	# known working flags wrt #77623
	use sparc && export CFLAGS="-O1" && export CXXFLAGS="${CFLAGS}"
	# set c/xxflags and ldflags
	strip-flags
	sed -i -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
	       -e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
	       -e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		${S}/mkspecs/${PLATFORM}/qmake.conf || die

	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e "s:/lib$:/$(get_libdir):" \
			${S}/mkspecs/${PLATFORM}/qmake.conf || die
	fi
}

src_compile() {
	export SYSCONF=${D}${QTBASE}/etc/settings

	# Let's just allow writing to these directories during Qt emerge
	# as it makes Qt much happier.
	addwrite "${QTBASE}/etc/settings"
	addwrite "${HOME}/.qt"

	[ $(get_libdir) != "lib" ] && myconf="${myconf} -L/usr/$(get_libdir)"

	# unixODBC support is now a PDEPEND on dev-db/qt-unixODBC; see bug 14178.
	use nas		&& myconf="${myconf} -system-nas-sound"
	use gif		&& myconf="${myconf} -qt-gif" || myconf="${myconf} -no-gif"
	use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/$(get_libdir)/mysql" || myconf="${myconf} -no-sql-mysql"
	use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/server -I/usr/include/postgresql/pgsql -I/usr/include/postgresql/pgsql/server" || myconf="${myconf} -no-sql-psql"
	use firebird    && myconf="${myconf} -plugin-sql-ibase" || myconf="${myconf} -no-sql-ibase"
	use sqlite	&& myconf="${myconf} -plugin-sql-sqlite" || myconf="${myconf} -no-sql-sqlite"
	use cups	&& myconf="${myconf} -cups" || myconf="${myconf} -no-cups"
	use opengl	&& myconf="${myconf} -enable-module=opengl" || myconf="${myconf} -disable-opengl"
	use debug	&& myconf="${myconf} -debug" || myconf="${myconf} -release -no-g++-exceptions"
	use xinerama    && myconf="${myconf} -xinerama" || myconf="${myconf} -no-xinerama"
	use zlib	&& myconf="${myconf} -system-zlib" || myconf="${myconf} -qt-zlib"
	use ipv6        && myconf="${myconf} -ipv6" || myconf="${myconf} -no-ipv6"

	if use ppc-macos ; then
		myconf="${myconf} -no-sql-ibase -no-sql-mysql -no-sql-psql -no-cups -lresolv -shared"
		myconf="${myconf} -I/usr/X11R6/include -L/usr/X11R6/lib"
		myconf="${myconf} -L${S}/lib -I${S}/include"
		sed -i -e "s,#define QT_AOUT_UNDERSCORE,," mkspecs/${PLATFORM}/qplatformdefs.h || die
	fi

	export YACC='byacc -d'

	./configure -sm -thread -stl -system-libjpeg -verbose -largefile \
		-qt-imgfmt-{jpeg,mng,png} -tablet -system-libmng \
		-system-libpng -xft -platform ${PLATFORM} -xplatform \
		${PLATFORM} -xrender -prefix ${QTBASE} -libdir ${QTBASE}/$(get_libdir) \
		-fast -no-sql-odbc ${myconf} -dlopen-opengl || die

	emake src-qmake src-moc sub-src || die

	export DYLD_LIBRARY_PATH="${S}/lib:/usr/X11R6/lib:${DYLD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	emake sub-tools || die

	if use examples; then
		emake sub-tutorial sub-examples || die
	fi

	# Make the msg2qm utility (not made by default)
	cd ${S}/tools/msg2qm
	../../bin/qmake
	emake

}

src_install() {
	# binaries
	into ${QTBASE}
	dobin bin/*
	dobin tools/msg2qm/msg2qm

	# libraries
	if use ppc-macos; then
		# dolib is broken on BSD because of missing readlink(1)
		dodir ${QTBASE}/$(get_libdir)
		cp -fR lib/*.{dylib,la,a} ${D}/${QTBASE}/$(get_libdir) || die

		cd ${D}/${QTBASE}/$(get_libdir)
		for lib in libqt-mt* ; do
			ln -s ${lib} ${lib/-mt/}
		done
	else
		dolib lib/lib{editor,qassistantclient,designercore}.a
		dolib lib/libqt-mt.la
		dolib lib/libqt-mt.so.3.3.5 lib/libqui.so.1.0.0
		cd ${D}/${QTBASE}/$(get_libdir)

		for x in libqui.so ; do
			ln -s $x.1.0.0 $x.1.0
			ln -s $x.1.0 $x.1
			ln -s $x.1 $x
		done

		# version symlinks - 3.3.5->3.3->3->.so
		ln -s libqt-mt.so.3.3.5 libqt-mt.so.3.3
		ln -s libqt-mt.so.3.3 libqt-mt.so.3
		ln -s libqt-mt.so.3 libqt-mt.so

		# libqt -> libqt-mt symlinks
		ln -s libqt-mt.so.3.3.5 libqt.so.3.3.5
		ln -s libqt-mt.so.3.3 libqt.so.3.3
		ln -s libqt-mt.so.3 libqt.so.3
		ln -s libqt-mt.so libqt.so
	fi

	# plugins
	cd ${S}
	local plugins=$(find plugins -name "lib*.so" -print)
	for x in ${plugins}; do
		exeinto ${QTBASE}/$(dirname ${x})
		doexe ${x}
	done

	# Past this point just needs to be done once
	is_final_abi || return 0

	# includes
	cd ${S}
	dodir ${QTBASE}/include/private
	cp include/* ${D}/${QTBASE}/include/
	cp include/private/* ${D}/${QTBASE}/include/private/

	# prl files
	sed -i -e "s:${S}:${QTBASE}:g" ${S}/lib/*.prl
	insinto ${QTBASE}/$(get_libdir)
	doins ${S}/lib/*.prl

	# pkg-config file
	insinto ${QTBASE}/$(get_libdir)/pkgconfig
	doins ${S}/lib/*.pc

	# List all the multilib libdirs
	local libdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${libdirs}:${QTBASE}/${libdir}"
	done

	# environment variables
	if use ppc-macos; then
		cat <<EOF > ${T}/30qt7
PATH=${QTBASE}/bin
ROOTPATH=${QTBASE}/bin
DYLD_LIBRARY_PATH=${libdirs:1}
QMAKESPEC=${PLATFORM}
MANPATH=${QTBASE}/doc/man
EOF
	else
		cat <<EOF > ${T}/30qt7
PATH=${QTBASE}/bin
ROOTPATH=${QTBASE}/bin
LDPATH=${libdirs:1}
QMAKESPEC=${PLATFORM}
MANPATH=${QTBASE}/doc/man
EOF
	fi
	cat <<EOF > ${T}/33qtdir7
QTDIR=${QTBASE}
EOF
	insinto /etc/env.d
	doins ${T}/30qt7 ${T}/33qtdir7

	if [ "${SYMLINK_LIB}" = "yes" ]; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) ${QTBASE}/lib
	fi

	insinto ${QTBASE}/tools/designer
	doins -r tools/designer/templates

	insinto ${QTBASE}
	doins -r translations

	keepdir ${QTBASE}/etc/settings

	if use doc; then
		insinto ${QTBASE}
		doins -r ${S}/doc
	fi

	if use examples; then
		find ${S}/examples ${S}/tutorial -name Makefile | \
			xargs sed -i -e "s:${S}:${QTBASE}:g"

		cp -r ${S}/examples ${D}${QTBASE}/
		cp -r ${S}/tutorial ${D}${QTBASE}/
	fi

	# misc build reqs
	insinto ${QTBASE}/mkspecs
	doins -r ${S}/mkspecs/${PLATFORM}

	sed -e "s:${S}:${QTBASE}:g" \
		${S}/.qmake.cache > ${D}${QTBASE}/.qmake.cache

	dodoc FAQ README README-QT.TXT changes*
}

pkg_postinst() {
	subversion_pkg_postinst
	echo
	einfo "After a rebuild of Qt, it can happen that Qt plugins (such as Qt/KDE styles,"
	einfo "or widgets for the Qt designer) are no longer recognized.  If this situation"
	einfo "occurs you should recompile the packages providing these plugins,"
	einfo "and you should also make sure that Qt and its plugins were compiled with the"
	einfo "same version of gcc.  Packages that may need to be rebuilt are, for instance,"
	einfo "kde-base/kdelibs, kde-base/kdeartwork and kde-base/kdeartwork-styles."
	einfo "See http://doc.trolltech.com/3.3/plugins-howto.html for more infos."
	echo
	if [[ -n "${USE_SYMBOL_VISIBILITY}" ]]; then
		einfo "You have symbol visibility patch enabled."
		einfo "If this is a new compile of Qt, make sure you recompile the whole of KDE."
		einfo "For bugs and info you can check out the thread at KDE bugtracker:"
		einfo "http://bugs.kde.org/show_bug.cgi?id=109386"
		echo
	fi
}
