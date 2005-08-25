# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author:
#	Mario Tanev <mtanev@csua.berkeley.edu>
#
# Purpose:
# 	Provide common functionality to handle choice between make, unsermake or
# 	other make tools, and provide ability to use builddir != srcdir,
#	and to store object files in a repository so that they can be reused.
#	This class supersedes keepobj.eclass and unsermake.eclass
#
# Notes:
#	This eclass requires keepobj_prepare be called in initialization
#

ECLASS="kde-make"
INHERITED="$INHERITED $ECLASS"

[ "${UNSERMAKE}" != no ] && DEPEND="${DEPEND} >=kde-base/unsermake-7-r1"

function debug-print-function-context {
	
	debug-print "${1}: invoked in ${PWD}"
	debug-print-function ${*}

}

function is_keepobj_enabled {

	if ( hasq keepobj ${FEATURES} ) && ( ! hasq keepobj ${RESTRICT} )
	then
		debug-print "${FUNCNAME}: enabled"		
		return 0
	else
		debug-print "${FUNCNAME}: disabled"		
		return 1
	fi

}

function is_confcache_enabled {

	if ( hasq confcache ${FEATURES} ) && ( ! hasq confcache ${RESTRICT} )
	then
		debug-print "${FUNCNAME}: enabled"		
		return 0
	else
		debug-print "${FUNCNAME}: disabled"		
		return 1
	fi

}

is_keepobj_enabled && objdir="${PORTAGE_OBJDIR}/${CATEGORY}/${P}" || objdir="${S}"


function keepobj_execute {

	# Log function tracing information
	debug-print-function-context ${FUNCNAME} ${*}

	if is_keepobj_enabled
	then
		if [ -z "${PWD##${S}*}" ]
		then
			rel="${PWD##${S}}"
		elif [ -z "${PWD##${objdir}*}" ]
		then
			rel="${PWD##${objdir}}"
		else
			die "${FUNCNAME}: cannot run on this directory"
		fi
		dir="$(strip_duplicate_slashes ${objdir}/${rel})"
		pushd "${dir}" >/dev/null || die "${FUNCNAME}: unable to change to directory ${dir}"
		debug-print "${FUNCNAME}: executing in ${PWD}"
		${*}
		retcode=${?}
		popd >/dev/null
		return ${retcode}
	else
		debug-print "${FUNCNAME}: executing in ${PWD}"
		command ${*}
	fi
	
}

function ./configure {

	# Log function tracing information
	debug-print-function-context ${FUNCNAME} ${*}

	myconf=""
	if is_keepobj_enabled
	then
		for flag in ${*}
		do
			case ${flag} in
				"--disable-dependency-tracking") ;;
				"--enable-dependency-tracking") ;;
				"--disable-final") ;;
				"--enable-final") ;;
				*) myconf="${myconf} ${flag}" ;;
			esac
		done
		myconf="${myconf} --disable-final"
		is_confcache_enabled && myconf="${myconf} --config-cache"
	else
		myconf=${*}
	fi

	keepobj_execute ${PWD}/configure ${myconf}

}

function make {

	# Log function tracing information
	debug-print-function-context ${FUNCNAME} ${*}

	if [ "${1}" == "-f" ]
	then
	
		# In case make executed to generate makefiles, run literally
		command env UNSERMAKE=${UNSERMAKE} AUTOMAKE=automake-1.7 make ${*}
		
	elif [ "${UNSERMAKE}" == no ]
	then
	
		keepobj_execute command make ${*}
		
	else
	
		keepobj_execute unsermake ${UNSERMAKEOPTS} ${*}
		
	fi

}

function emake {

	# Log function tracing information
	debug-print-function-context ${FUNCNAME} ${*}

	[ "${UNSERMAKE}" == no ] && MAKE=make || MAKE=unsermake
	
	keepobj_execute command env MAKE=${MAKE} emake ${*}

}

function kde-make_pkg_setup {

	# Log function tracing information
	debug-print-function ${FUNCNAME} ${*}

	if [ ! -d ${objdir} ]
	then
		mkdir -p ${objdir}
	else
		for item in ${KEEPOBJ_EXEMPT}
		do
			if [ -d "${objdir}/${item}" ]
			then
				debug-print "${FUNCNAME}: removing ${objdir}/${item}"
				rm -rf "${objdir}/${item}"
			fi
		done
		ewarn "WARNING: object storage and reuse functionality has been enabled."
	fi

}

EXPORT_FUNCTIONS pkg_setup
