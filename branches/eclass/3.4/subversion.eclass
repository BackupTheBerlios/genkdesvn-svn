# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Author: Mario Tanev
# Original Author: Akinori Hattori
# Purpose: 
#

inherit scm libtool

ECLASS="subversion"
INHERITED="$INHERITED $ECLASS"

DEPEND="$DEPEND
	>=dev-util/subversion-1.2.0"

## ESVN_STORE_DIR: Central repository for working copies
## ${DISTDIR} is no longer used in portage; we must now use ${PORTAGE_ACTUAL_DISTDIR}
[ -z "${ESVN_STORE_DIR}" ] && ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR}/svn-src"

## ESVN_REPO_URI: Repository URL
[ -z "${ESVN_REPO_URI}" ]  && ESVN_REPO_URI=""

## ESVN_PROJECT: Project name 
#[ -z "${ESVN_PROJECT}" ] && ESVN_PROJECT="${PN/-svn}"


function subversion_obtain_certificates() {
	debug-print-function $FUNCNAME $*

	## ${DISTDIR} is no longer used in portage; we must now use ${PORTAGE_ACTUAL_DISTDIR}
	_DISTDIR=$PORTAGE_ACTUAL_DISTDIR
	DISTDIR="$HOME/.subversion/auth/svn.ssl.server"
	for URI in $ESVN_CERTIFICATES
	do
		[ ! -f $DISTDIR/`basename $URI` ] && einfo "Obtaining SSL certificate $URI" && `eval $FETCHCOMMAND`
	done
	DISTDIR=$_DISTDIR

}

SCRIPT_DIR="$(dirname $(dirname $(dirname $FILESDIR)))/scripts"

function subversion_deep_copy() {
	debug-print-function $FUNCNAME $*

	local item="$1"
	local src="$2"
	local dest="$3"

	#einfo "Copying $item to working directory"
	debug-print "$FUNCNAME: Deep-copying $item from $src to $dest, omitting .svn*"

	## TODO; is finding .svn.eclass.mode important ??

	pushd $src >/dev/null
	debug-print `find $item \( -path "*.svn*" -type d ! -name . -prune \) -o \( -exec \cp -p --parents {} $dest/ \;  \) 2>&1`
	#debug-print `find $item \( -path "*.svn*" ! -name . -prune \) -o \( -exec \cp -p --parents {} $dest/ \;  \) 2>&1`
	popd >/dev/null

}

ESVN_CO_DIR="${ESVN_PROJECT}/${ESVN_REPO_URI##*/}"
function subversion_src_fetch() {
	debug-print-function $FUNCNAME $*

	# Check for empty ESVN_REPO_URI
	[ -z "${ESVN_REPO_URI}" ] && die "${ESVN}: ESVN_REPO_URI is empty."
	
	if [ ! -d "${ESVN_STORE_DIR}" ]; then
		debug-print "${FUNCNAME}: Creating subversion storage directory"
		addwrite /
		mkdir -p "${ESVN_STORE_DIR}"      || die "${ESVN}: can't mkdir ${ESVN_STORE_DIR}."
		chmod -f o+rw "${ESVN_STORE_DIR}" || die "${ESVN}: can't chmod ${ESVN_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi


	# Enable writes
	addwrite "/etc/subversion"
	addwrite "${ESVN_STORE_DIR}"
	! has userpriv ${FEATURE} && addwrite "/root/.subversion"
	
	ARGUMENTS="$ARGUMENTS $ESVN_RUN_ARGS"
	ARGUMENTS="$ARGUMENTS --repository=${ESVN_REPO_URI}"
	ARGUMENTS="$ARGUMENTS --work-base=${ESVN_STORE_DIR}/${ESVN_PROJECT}"
	ARGUMENTS="$ARGUMENTS --revdb-out=${T}/SVNREVS"
	if [ "$ESVN_OFFLINE" ]
	then
		ARGUMENTS="$ARGUMENTS --offline"
	fi
	REVDB_IN="${ROOT}/var/db/pkg/${CATEGORY}/${PF}/SVNREVS"
	if [ -f $REVDB_IN ]; then
		ARGUMENTS="$ARGUMENTS --revdb-in=$REVDB_IN"
		if ( hasq autoskipcvs ${FEATURES} ) || ( hasq logonly ${FEATURES} ); then
			if ( hasq autoskipcvs ${FEATURES} ); then
				ewarn "WARNING: Previous merge of ${CATEGORY}/${PF} exists and autoskipcvs has been set."
				ewarn "WARNING: Emerge will be aborted if there have been no relevant changes since last merge."
				ewarn "WARNING: Note, that this is not, and should not be the default behavior."
				ewarn "WARNING: Items to be inspected are $ESCM_CHECKITEMS"
				ARGUMENTS="$ARGUMENTS --checkrevs"
			else
				ewarn "Log check started for ${CATEGORY}/${PF}"
				ARGUMENTS="$ARGUMENTS --logonly"
			fi
		fi
	elif ( hasq logonly $FEATURES ); then
		ewarn "No previous revision recorded for ${CATEGORY}/${PF}"
		exit 1
	fi
	
	for item in $ESCM_CHECKITEMS; do ARGUMENTS="$ARGUMENTS --check=$item"; done
	for item in $ESCM_DEEPITEMS;	do ARGUMENTS="$ARGUMENTS --deep=$item";		done
	for item in $ESCM_SHALLOWITEMS;	do ARGUMENTS="$ARGUMENTS --shallow=$item";	done

	HELPER="env LANGUAGE=en_US $SCRIPT_DIR/eclass-helper-svn.py"
	${HELPER} ${ARGUMENTS}
	err=$?
	if [ $err -ne 0 ]
	then
		if [ $err -eq 16 ]
		then
			if ( hasq autoskipcvs ${FEATURES} ); then
				ewarn "WARNING: Revisions for ${CATEGORY}/${PF} have not changed since last merge."
				ewarn "WARNING: This merge will be aborted immediately."
				ewarn "WARNING: To avoid this in the FUTURE, unset autoskipcvs from your FEATURES"
			fi
			touch "/tmp/.svn.uptodate.${CATEGORY}.${PF}"
			exit 1
		elif [ $err -eq 17 ]
		then
			ewarn "Log check complete for ${CATEGORY}/${PF}"
			exit 1
		else
			die "${HELPER} ${ARGUMENTS} has failed with exit code $err"
		fi
	fi
}

function subversion_src_extract() {
	debug-print-function $FUNCNAME $*
	src_to_workdir "$ESVN_STORE_DIR/$ESVN_CO_DIR" subversion_deep_copy
}

function subversion_src_bootstrap() {
	debug-print-function $FUNCNAME $*

	cd $S
	for patch in ${ESVN_PATCHES}; do
		[ -f "${patch}" ] && epatch ${patch}
	done
	
	if [ "${ESVN_BOOTSTRAP}" ]
	then
		einfo "Bootstrapping with ${ESVN_BOOTSTRAP}"
		if [ -x "${ESVN_BOOTSTRAP}" ]
		then
			./${ESVN_BOOTSTRAP} || die "${ESVN}: cannot execute $ESVN_BOOTSTRAP"
		else
			${ESVN_BOOTSTRAP} || die "${ESVN}: cannot execute $ESVN_BOOTSTRAP"
		fi
	fi
}

function subversion_src_unpack() {
	debug-print-function $FUNCNAME $*
	subversion_src_fetch
	subversion_src_extract
	subversion_src_bootstrap
}

function subversion_pkg_postinst() {
	debug-print-function $FUNCNAME $*
	cp $T/SVNREVS "${ROOT}/var/db/pkg/${CATEGORY}/${PF}/"
}

# Export unpack
EXPORT_FUNCTIONS src_unpack pkg_postinst
