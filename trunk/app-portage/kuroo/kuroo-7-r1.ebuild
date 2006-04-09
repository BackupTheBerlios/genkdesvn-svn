# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_PROJECT="${PN}-svn"
ESVN_REPO_URI="svn://kuroo.org/repos/kuroo/branches/0.80.0"
ESVN_STORE_DIR="${DISTDIR}/svn-src"
ESVN_BOOTSTRAP="make -f Makefile.cvs"
inherit kdesvn svn 

DESCRIPTION="A KDE Portage frontend"
HOMEPAGE="http://kuroo.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE="debug"

RDEPEND="!app-portage/guitoo
	|| (kde-misc/kdiff3 kde-base/kdesdk)"

PATCHES="${FILESDIR}/${PN}-detect-automake.patch"

KMTARGETS=(
	'src/config .ui .kcfgc'
)

need-kde 3.4

src_compile() {
	kde_src_compile myconf configure

	einfo "generating headers in src/config"
	cd ${S}/src/config && ${QTDIR}/bin/uic -o options1.h options1.ui
	cd ${S}/src/config && ${QTDIR}/bin/uic -o options2.h options2.ui
	cd ${S}/src/config && ${QTDIR}/bin/uic -o options7.h options7.ui
	cd ${S}/src/config && ${KDEDIR}/bin/kconfig_compiler kurooconfig.kcfg settings.kcfgc

	einfo "generating moc files in src/config"
	cd ${S}/src/config && ${QTDIR}/bin/moc -o configdialog.moc configdialog.h

	einfo "generating headers in src/intro"
	cd ${S}/src/intro && ${QTDIR}/bin/uic -o intro.h intro.ui

	einfo "generating moc files in src/intro"
	cd ${S}/src/intro && ${QTDIR}/bin/moc -o introdlg.moc introdlg.h

	einfo "generating headers in src/core"
	cd ${S}/src/core && ${QTDIR}/bin/uic -o inspectorbase.h inspectorbase.ui

	einfo "generating moc files in src/core"
	cd ${S}/src/core && ${QTDIR}/bin/moc -o scanupdatesjob.moc scanupdatesjob.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o scanhistoryjob.moc scanhistoryjob.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o emerge.moc emerge.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o scanportagejob.moc scanportagejob.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o signalist.moc signalist.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o threadweaver.moc threadweaver.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o portagedb.moc portagedb.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o cacheportagejob.moc cacheportagejob.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o etcupdate.moc etcupdate.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o packagelistview.moc packagelistview.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o categorieslistview.moc categorieslistview.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o portagefiles.moc portagefiles.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o images.moc images.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o packageinspector.moc packageinspector.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o versionview.moc versionview.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o filewatcher.moc filewatcher.h
	cd ${S}/src/core && ${QTDIR}/bin/moc -o global.moc global.h

	einfo "generating headers in src/history"
	cd ${S}/src/history && ${QTDIR}/bin/uic -o historybase.h historybase.ui
	cd ${S}/src/history && ${QTDIR}/bin/uic -o mergebase.h mergebase.ui

	einfo "generating moc files in src/history"
	cd ${S}/src/history && ${QTDIR}/bin/moc -o history.moc history.h
	cd ${S}/src/history && ${QTDIR}/bin/moc -o historylistview.moc historylistview.h
	cd ${S}/src/history && ${QTDIR}/bin/moc -o historytab.moc historytab.h
	cd ${S}/src/history && ${QTDIR}/bin/moc -o mergelistview.moc mergelistview.h
	cd ${S}/src/history && ${QTDIR}/bin/moc -o mergetab.moc mergetab.h

	einfo "generating headers in src/logs"
	cd ${S}/src/logs && ${QTDIR}/bin/uic -o logsbase.h logsbase.ui

	einfo "generating moc files in src/logs"
	cd ${S}/src/logs && ${QTDIR}/bin/moc -o log.moc log.h
	cd ${S}/src/logs && ${QTDIR}/bin/moc -o logstab.moc logstab.h

	einfo "generating headers in src/portage"
	cd ${S}/src/portage && ${QTDIR}/bin/uic -o portagebase.h portagebase.ui
	cd ${S}/src/portage && ${QTDIR}/bin/uic -o uninstallbase.h uninstallbase.ui

	einfo "generating moc files in src/portage"
	cd ${S}/src/portage && ${QTDIR}/bin/moc -o portagelistview.moc portagelistview.h
	cd ${S}/src/portage && ${QTDIR}/bin/moc -o portagetab.moc portagetab.h
	cd ${S}/src/portage && ${QTDIR}/bin/moc -o portage.moc portage.h
	cd ${S}/src/portage && ${QTDIR}/bin/moc -o uninstallinspector.moc uninstallinspector.h

	einfo "generating headers in src/queue"
	cd ${S}/src/queue && ${QTDIR}/bin/uic -o queuebase.h queuebase.ui

	einfo "generating moc files in src/queue"
	cd ${S}/src/queue && ${QTDIR}/bin/moc -o queuetab.moc queuetab.h
	cd ${S}/src/queue && ${QTDIR}/bin/moc -o queue.moc queue.h
	cd ${S}/src/queue && ${QTDIR}/bin/moc -o queuelistview.moc queuelistview.h
	cd ${S}/src/queue && ${QTDIR}/bin/moc -o results.moc results.h

	einfo "generating headers in src"
	cd ${S}/src && ${QTDIR}/bin/uic -o kurooviewbase.h kurooviewbase.ui
	cd ${S}/src && ${QTDIR}/bin/uic -o messagebase.h messagebase.ui

	einfo "generating moc files in src"
	cd ${S}/src && ${QTDIR}/bin/moc -o kuroo.moc kuroo.h
	cd ${S}/src && ${QTDIR}/bin/moc -o kurooview.moc kurooview.h
	cd ${S}/src && ${QTDIR}/bin/moc -o mainwindow.moc mainwindow.h
	cd ${S}/src && ${QTDIR}/bin/moc -o statusbar.moc statusbar.h
	cd ${S}/src && ${QTDIR}/bin/moc -o kurooinit.moc kurooinit.h
	cd ${S}/src && ${QTDIR}/bin/moc -o systemtray.moc systemtray.h
	cd ${S}/src && ${QTDIR}/bin/moc -o message.moc message.h

	einfo "making kuroo"
	kde_src_compile make
}
