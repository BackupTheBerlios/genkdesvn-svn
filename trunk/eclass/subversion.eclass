# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/subversion.eclass,v 1.18 2005/01/20 09:53:16 hattya Exp $

## --------------------------------------------------------------------------- #
# Author: Akinori Hattori <hattya@gentoo.org>
# 
# The subversion eclass is written to fetch the software sources from
# subversion repositories like the cvs eclass.
#
#
# Description:
#   If you use this eclass, the ${S} is ${WORKDIR}/${P}.
#   It is necessary to define the ESVN_REPO_URI variable at least.
#
## --------------------------------------------------------------------------- #

inherit eutils scm

ECLASS="subversion"
INHERITED="${INHERITED} ${ECLASS}"
ESVN="subversion.eclass"

EXPORT_FUNCTIONS src_unpack
export LANG=en_US

DESCRIPTION="Based on the ${ECLASS} eclass"


## -- add subversion in DEPEND
#
DEPEND=">=dev-util/subversion-1.2.0"


## -- ESVN_STORE_DIR:  subversion sources store directory
#
ESVN_STORE_DIR="${DISTDIR}/svn-src"


## -- ESVN_FETCH_CMD:  subversion fetch command
#
# default: svn checkout
#
[ -z "${ESVN_FETCH_CMD}" ]  && ESVN_FETCH_CMD="svn checkout"

## -- ESVN_UPDATE_CMD:  subversion update command
#
# default: svn update
#
[ -z "${ESVN_UPDATE_CMD}" ] && ESVN_UPDATE_CMD="svn update"


## -- ESVN_REPO_URI:  repository uri
#
# e.g. http://foo/trunk, svn://bar/trunk
#
# supported protocols:
#   http://
#   https://
#   svn://
#
[ -z "${ESVN_REPO_URI}" ]  && ESVN_REPO_URI=""


## -- ESVN_PROJECT:  project name of your ebuild
#
# subversion eclass will check out the subversion repository like:
#
#   ${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}
#
# so if you define ESVN_REPO_URI as http://svn.collab.net/repo/svn/trunk or
# http://svn.collab.net/repo/svn/trunk/. and PN is subversion-svn.
# it will check out like:
#
#   ${ESVN_STORE_DIR}/subversion/trunk
#
# default: ${PN/-svn}.
#
[ -z "${ESVN_PROJECT}" ] && ESVN_PROJECT="${PN/-svn}"


## -- ESVN_BOOTSTRAP:
#
# bootstrap script or command like autogen.sh or etc..
#
[ -z "${ESVN_BOOTSTRAP}" ] && ESVN_BOOTSTRAP=""


## -- ESVN_PATCHES:
#
# subversion eclass can apply pathces in subversion_bootstrap().
# you can use regexp in this valiable like *.diff or *.patch or etc.
# NOTE: this patches will apply before eval ESVN_BOOTSTRAP.
#
# the process of applying the patch is:
#   1. just epatch it, if the patch exists in the path.
#   2. scan it under FILESDIR and epatch it, if the patch exists in FILESDIR.
#   3. die.
#
[ -z "${ESVN_PATCHES}" ] && ESVN_PATCHES=""

declare svn_result
declare error
declare errormsg
readonly ERR_DNE=3
readonly ERR_NETWORK=4
readonly ERR_LOCKED=5
readonly ERR_PARSER=12
readonly SLEEP_INTERVAL=30
readonly MODE_SHALLOW="shallow"
readonly MODE_DEEP="deep"
readonly MODE_NONE="none"

readonly modefile=".svn.eclass.mode"
readonly errorfile="$T/.svn.lasterror"
function subversion_handle_error() {

	read errormsg < $errorfile

	case "" in
	"${errormsg##*locked}") return $ERR_LOCKED ;;
	"${errormsg##*Connection closed unexpectedly}") return $ERR_NETWORK ;;
	"${errormsg##*Malformed*}") return $ERR_NETWORK ;;
	"${errormsg##*Connection timed out}") return $ERR_NETWORK ;;
	"${errormsg##*XML parser*}")
		eerror "Parsing errors performing \"$execute\"" 1>&2
		eerror "If you're using apr-0.9.6-r3, please downgrade!" 1>&2
		die "$errormsg"
	;;
	"${errormsg##*No such revision*}")
		eerror "Server problems performing \"$execute\"" 1>&2
		eerror "Use repository's web interface $ESVN_WEBINT to verify that server is down, and contact its maintainer" 1>&2
		die "$errormsg"
	;;
	esac
	
	eerror "Failed in `pwd` during \"$execute\"" 1>&2 && die "$errormsg"

}

[ -z $ESVN_INTERVAL ] && ESVN_INTERVAL=1800
function subversion_perform() {

	debug-print-function $FUNCNAME $*

	local command="$1"
	local options="$2"
	local args="$3"

	# Translate options
	case $options in
		"$MODE_NONE") options="";;
		"$MODE_DEEP") options="";;
		"$MODE_SHALLOW") options="-N";;
	esac

	local execute=`echo svn $command $options $args | sed -e "s/^ *//"`
	debug-print "$FUNCNAME: Performing \"$execute\""
	$execute 2> $errorfile
	[ $? -eq 1 ] && subversion_handle_error

	case $? in
	$ERR_LOCKED)

		ewarn "Subversion repository is currently locked; retrying in $SLEEP_INTERVAL seconds" 1>&2
		sleep 30
		subversion_perform $1 $2 $3

	;;	
	$ERR_NETWORK)

		ewarn "Subversion is experiencing network errors ($errormsg); retrying in $SLEEP_INTERVAL seconds" 1>&2
		sleep 30
		subversion_perform $1 $2 $3
	
	;;
	esac

}

function subversion_modules_fetch() {

	debug-print-function $FUNCNAME $*

	local mode="$1"
	local modules=$2

	for module in $modules
	do
	
		local lastmode
		local entry
		local currentmode=$mode
		local method="recursively"

		[ "$module" == "." ] && entry="trunk" || entry="$module"
		previous_update_mode $module

		lastmode=$result
		if [ "$lastmode" == "$MODE_SHALLOW" ] && [ "$currentmode" == "$MODE_DEEP" ]; then

			ewarn "Removing $entry since previously fetched non-recursively (workaround a subversion issue)"
			rm -r $module

		fi

		# If a module has been fetched recursively at some point, continue doing
		# so, as this will avoid a cycle of remove and refetch
		[ "$lastmode" == "$MODE_DEEP" ] && currentmode="$MODE_DEEP"
		[ "$currentmode" == "$MODE_SHALLOW" ] && method="non-recursively"

		is_recently_updated $module
		if [ $? == $TRUE ] && [ "$currentmode" == "$MODE_SHALLOW" -o "$currentmode" == "$lastmode" ]; then
		
			ewarn "Updating $entry $method (skipped: last performed within $ESVN_INTERVAL seconds)"
		
		else 
		
			einfo "Updating $entry $method"
			subversion_perform "--ignore-externals update" "$currentmode" "$module"
			echo $currentmode > "$module/$modefile"

		fi

	done

}

function previous_update_mode() {

	local dir=""
	local mode=$DEEP

	[ -n $1 ] && dir="$1/"
	if [ -d "$dir" ] && [ -f "$dir/$modefile" ]; then

		read mode < "$dir/$modefile"

	fi

	result=$mode

}

function is_recently_updated() {

	local dir=""
	
	[ -n $1 ] && dir="$1/"
	if [ -e "$dir.svn/entries" ] && (( $(date +%s) - $(date -r $dir.svn/entries +%s) < $ESVN_INTERVAL )); then

		return $TRUE

	else

		return $FALSE

	fi

}

# Constants
readonly DNE=0 FIL=1 DIR=2
readonly FALSE=0 TRUE=1

# item_type_from_listing(): Determine if item is a file, directory, or doesn't exist.
# Do so by quering the server/work copy listing of files.
#
# Requirements:
#	Running folder must be a subversion folder.
#
# Parameters:
#	$1 - item to inspect
#	$2 - Repository URL
#
# Return:
#	$DNE - item does not exist
#	$FIL - item is a file
#	$DIR - item is a directory
#
function item_type_from_listing() {

	debug-print-function $FUNCNAME $*

	# Item to search listings for
	local item=$1

	# Repository URL
	local url=""

	# If URL passed to function, append /
	[ -n "$2" ] && url="$2/"

	# Base name of item (with its location stripped)
	local name=`basename $item`

	# Directory above item in the file hierarchy
	local topdir=`dirname $item`

	# Grab list of contents of $topdir from cached server results if posible
	# Cache consists of lines of the form $topdir item1 item2 ... itemN
	local cachefile="$T/.svn.list.cache"
	local topdirlist=""

	# If cache exists
	if [ -f $cachefile ]; then
	
		# Read all lines from the cache file, until an entry is found
		exec < $cachefile
		while read pivot entry && [ "$topdirlist" == "" ]
		do

			#echo "pivot=$pivot topdir="$topdir" entry=$entry"
			[ $pivot == "$topdir" ] && topdirlist="$entry" && break

		done

	fi
	
	# If cache entry for listing of $topdir found
	if [ "$topdirlist" != "" ]; then

		debug-print "$FUNCNAME: Found cache entry for listing of $topdir in $cachefile"

	# If cache entry for listing of $topdir not found
	else 

		# Grab list of contents of $topdir from server
		#echo "Executing svn list $url$topdir"
		debug-print "$FUNCNAME: Querying $url$topdir for listing"
		topdirlist=`subversion_perform list $DEEP $url$topdir`

		# Create listing cache entry for $topdir
		local cacheentry="$topdir"
		for cacheitem in $topdirlist
		do

			cacheentry="$cacheentry $cacheitem"

		done

		# Add entry for $topdir to listing cachefile
		debug-print "$FUNCNAME: Adding cache entry for $topdir to $cachefile"
		echo $cacheentry >> $cachefile

	fi

	# If item $name is present in list, claim it is a file
	if ( hasq "$name" $topdirlist ); then

		debug-print "$FUNCNAME: Determined that $item is a file on server"
		return $FIL

	# If item $name with a trailing / is present in list, claim it is a directory
	elif ( hasq "$name/" $topdirlist ); then

		debug-print "$FUNCNAME: Determined that $item is a directory on server"
		return $DIR

	# Otherwise, claim $item does not exist
	else

		debug-print "$FUNCNAME: Determined that $item does not exist on server"
		return $DNE

	fi

}

# item_type(): Determine if item is a file, directory, or doesn't exist.
# Attempt to determine said information from file-system if possible,
# otherwise query the subversion repository for that information.
#
# Requirements:
#	Running folder must be a subversion folder.
#
# Parameters:
#	$1 - item to inspect
#	$2 - Repository URL
#
# Return:
#	$DNE - item does not exist
#	$FIL - item is a file
#	$DIR - item is a directory
#
function item_type() {

	debug-print-function $FUNCNAME $*

	# Item to inspect
	local item=$1

	# Repository URL
	local url=$2

	# Base name of item (with its location stripped)
	local name=`basename $item`

	# Directory above item in the file hierarchy
	local topdir=`dirname $item`

	# If $item exists locally, and is a file, claim it is a file
	if [ -f $item ]; then
	
		debug-print "$FUNCNAME: Determined that $item is a local file"
		return $FIL

	# If $item exists locally, and is a directory, claim it is a directory
	elif [ -d $item ]; then

		debug-print "$FUNCNAME: Determined that $item is a local directory"
		return $DIR
	
	# If $topdir is actually a file, claim $item does not exist
	elif [ -f $topdir ]; then

		debug-print "$FUNCNAME: Determined that $topdir is a file, thus $item does not exist"
		return $DNE

	# If $topdir is a working copy query it about the status of $item
	elif [ -f "$topdir/.svn/entries" ]; then
	
		# echo "Performing listing on $item with topdir=$topdir"
		item_type_from_listing $item
		return $?
		

	# If still undetermined, fully query server repository
	else

		# First determine if $topdir exists and is a folder
		item_type $topdir $url

		case $? in
		$DIR)

			# If $topdir is directory on server	repository, determine what $item
			# really is
			item_type_from_listing $item $url
			return $?

		;;
		$FIL)

			# If $topdir does exist on server repository, but is a file, claim
			# $item does not exist
			debug-print "$FUNCNAME: Determined that $topdir is a file, thus $item cannot exist"
			return $DNE

		;;
		$DNE)

			# If $topdir does not exist in server repository, claim neither it
			# nor $item exist
			debug-print "$FUNCNAME: Determined that $topdir and thus $item do not exist"
			return $DNE

		;;
		esac
			
	fi
 
}

function subversion_deep_copy() {

	debug-print-function $FUNCNAME $*

	local item="$1"
	local src="$2"
	local dest="$3"

	einfo "Copying $item to $dest"
	debug-print "$FUNCNAME: Deep-copying $item from $src to $dest, omitting .svn*"
	pushd $src >/dev/null
	debug-print `find $item \( -path "*.svn*" ! -name . -prune \) -o \( -exec \cp --parents {} $dest/ \;  \) 2>&1`
	popd >/dev/null

}

declare -a deep_items shallow_items
declare -i deep_levels shallow_levels


function sort_items() {

	debug-print-function $FUNCNAME $*

	url=$1

	deep_levels=0
	shallow_levels=0

	for item in $ESCM_SHALLOWITEMS $ESCM_DEEPITEMS
	do
		
		declare -i token=0 offset=-1 level=0

		local path="$item"

		while [ $offset != 0 ]
		do

			# Determine index of character after next /
			offset=`expr index ${path:$token} "/"`

			# Move $token index by $offset
			token=$token+$offset

			local topdir=`echo ${path:0:$token} | sed -e "s/\/*$//g"`

			# If last level in hierarchy of $path
			if [ $offset == 0 ]; then
			
				item_type $path $url
				case $? in
				$DNE)
					
					debug-print "$FUNCNAME: $item does not exist and will not be added for checkout/update"
				
				;;	
				$FIL)

					debug-print "$FUNCNAME: $item is a file, and will not be added for checkout/update"

				;;
				$DIR)

					# If item is deep, add $level ancestor to array of deep items at $level
					if ( hasq "$item" $ESCM_DEEPITEMS ); then

						if ( ! hasq "$path" ${deep_items[$level]} ); then

							local items="${deep_items[$level]}"
							debug-print "$FUNCNAME: Adding $path to array of deep items at level $level"
							[ $deep_levels -le $level ]  && deep_items[$level]="" && deep_levels=$level
							deep_items[$level]="$path $items"

						fi

					else
					
						if ( ! hasq "$path" ${shallow_items[$level]} ); then
				
							local items="${shallow_items[$level]}"
							debug-print "$FUNCNAME: Adding $path to array of shallow items at level $level"
							[ $shallow_levels -le $level ] && shallow_items[$level]="" && shallow_levels=$level
							shallow_items[$level]="$path $items"
	
						fi
	
					fi
					
				;;
				esac

			else

				if ( ! hasq "$topdir" ${shallow_items[$level]} ${deep_items[$level]} ); then
				
					local items="${shallow_items[$level]}"
					debug-print "$FUNCNAME: Adding $topdir to array of shallow items at level $level"
					[ $shallow_levels -le $level ] && shallow_items[$level]="" && shallow_levels=$level
					shallow_items[$level]="$topdir $items"

				fi

			fi 

			# Advance to next $level
			level=$level+1
			
		done

	done

}

## -- subversion_svn_fetch() ------------------------------------------------- #

function subversion_svn_fetch() {

	# ESVN_REPO_URI is empty.
	[ -z "${ESVN_REPO_URI}" ] && die "${ESVN}: ESVN_REPO_URI is empty."

	# check for the protocol.
	case ${ESVN_REPO_URI%%:*} in
		http)	;;
		https)	;;
		svn)	;;
		file)	;;
		svn+ssh) ;;
		*)
			die "${ESVN}: fetch from "${ESVN_REPO_URI%:*}" is not yet implemented."
			;;
	esac

	if [ ! -d "${ESVN_STORE_DIR}" ]; then
		debug-print "${FUNCNAME}: initial checkout. creating subversion directory"

		addwrite /
		mkdir -p "${ESVN_STORE_DIR}"      || die "${ESVN}: can't mkdir ${ESVN_STORE_DIR}."
		chmod -f o+rw "${ESVN_STORE_DIR}" || die "${ESVN}: can't chmod ${ESVN_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi

	cd -P "${ESVN_STORE_DIR}" || die "${ESVN}: can't chdir to ${ESVN_STORE_DIR}"
	ESVN_STORE_DIR=${PWD}

	# every time
	addwrite "/etc/subversion"
	addwrite "${ESVN_STORE_DIR}"

	# -userpriv
	! has userpriv ${FEATURE} && addwrite "/root/.subversion"

	[ -z "${ESVN_REPO_URI##*/}" ] && ESVN_REPO_URI="${ESVN_REPO_URI%/}"
	ESVN_CO_DIR="${ESVN_PROJECT}/${ESVN_REPO_URI##*/}"

	ESVN_FETCH_OPTS="$MODE_SHALLOW" && ESVN_UPDATE_OPTS="$MODE_SHALLOW"
	# First update trunk

	# If trunk does not yet exist, perform initial checkout
	if [ ! -d "${ESVN_CO_DIR}/.svn" ]; then

		einfo "Creating $ESVN_PROJECT trunk in $ESVN_STORE_DIR/$ESVN_CO_DIR from $ESVN_REPO_URI"

		mkdir -p "${ESVN_PROJECT}"
		cd "${ESVN_PROJECT}"
		subversion_perform "checkout" $ESVN_FETCH_OPTS "${ESVN_REPO_URI}"
	
	else

		cd $ESVN_STORE_DIR/$ESVN_CO_DIR
		subversion_modules_fetch "$MODE_SHALLOW" "."

	fi


	cd $ESVN_STORE_DIR/$ESVN_CO_DIR
	sort_items $ESVN_REPO_URI
	for (( level=0; $level <= $deep_levels || $level <= $shallow_levels ; level=$level+1 ))
	do

		if (( $level <= $deep_levels )) && [ "${deep_items[$level]}" != "" ]; then

			subversion_modules_fetch "$MODE_DEEP" "${deep_items[$level]}"

		fi

		if (( $level <= $shallow_levels )) && [ "${shallow_items[$level]}" != "" ]; then

			subversion_modules_fetch "$MODE_SHALLOW" "${shallow_items[$level]}"

		fi

	done

	src_to_workdir "$ESVN_STORE_DIR/$ESVN_CO_DIR" subversion_deep_copy

}

## -- subversion_bootstrap() ------------------------------------------------ #

function subversion_bootstrap() {

	local patch lpatch

	cd "${S}"

	if [ "${ESVN_PATCHES}" ]; then
		einfo "apply patches -->"

		for patch in ${ESVN_PATCHES}; do
			if [ -f "${patch}" ]; then
				epatch ${patch}

			else
				for lpatch in ${FILESDIR}/${patch}; do
					if [ -f "${lpatch}" ]; then
						epatch ${lpatch}

					else
						die "${ESVN}; ${patch} is not found"

					fi
				done
			fi
		done
		echo
	fi

	if [ "${ESVN_BOOTSTRAP}" ]; then
		einfo "begin bootstrap -->"

		if [ -f "${ESVN_BOOTSTRAP}" -a -x "${ESVN_BOOTSTRAP}" ]; then
			einfo "   bootstrap with a file: ${ESVN_BOOTSTRAP}"
			eval "./${ESVN_BOOTSTRAP}" || die "${ESVN}: can't execute ESVN_BOOTSTRAP."

		else
			einfo "   bootstrap with commands: ${ESVN_BOOTSTRAP}"
			eval "${ESVN_BOOTSTRAP}" || die "${ESVN}: can't eval ESVN_BOOTSTRAP."

		fi
	fi

}


## -- subversion_src_unpack() ------------------------------------------------ #

function subversion_src_unpack() {

	subversion_svn_fetch
	subversion_bootstrap || die "${ESVN}: unknown problem in subversion_bootstrap()."

}
