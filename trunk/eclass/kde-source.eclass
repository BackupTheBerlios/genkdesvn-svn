# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-source.eclass,v 1.20 2004/06/25 00:39:48 vapier Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# This is for kde-base cvs ebuilds. Read comments about settings.
# It uses $S and sets $SRC_URI, so inherit it as late as possible (certainly after any other eclasses).
# See http://www.gentoo.org/~danarmak/kde-cvs.html !
# All of the real functionality is in cvs.eclass; this just adds some trivial kde-specific items

ECLASS=kde-source
INHERITED="$INHERITED $ECLASS"

# --- begin user-configurable settings ---

# Set yours in profile (e.g. make.conf), or export from the command line to override.
# Most have acceptable default values or are set by the ebuilds, but be sure to read the comments
# in cvs.eclass for detailed descriptions of them all.
# You should probably set at least ECVS_SERVER.

# TODO: add options to store the modules as tarballs in $DISTDIR or elsewhere

# Under this directory the cvs modules are stored/accessed
# Storing in tarballs in $DISTDIR to be implemented soon

# Set to name of cvs server. Set to "" to disable fetching (offline mode).
# In offline mode, we presume that modules are already checked out at the specified
# location and that they shouldn't be updated.
# Format example: "anoncvs.kde.org:/home/kde" (without :pserver:anonymous@ part)
# Mirror list is available at http://developer.kde.org/source/anoncvs.html
#[ -z "$ECVS_SERVER" ] && ECVS_SERVER="anoncvs.kde.org:/home/kde"
#[ -z "$ECVS_AUTH" ] && ECVS_AUTH="pserver"
ESVN_PROJECT=""
[ -z "$ESVN_REPO_URI" ] && ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde"
[ -z "$ESVN_SERVER" ] && ESVN_SERVER="svn://anonsvn.kde.org/home/kde/trunk"
ESVN_WEBINT="http://websvn.kde.org/"
ESVN_CERTIFICATES="http://download.berlios.de/genkdesvn/ec08b331e2e6cabccb6c3e17a85e28ce"

# for apps living inside modules like kdenonbeta - see also beginning of our _src_unpack
# KCVS_SUBDIR=...

# If a tag is specified as ECVS_BRANCH, it will be used for the kde-common module
# as well. If that is wrong (fex when checking out kopete branch kopete_0_6_2_release),
# use KCVS_BRANCH instead.

# you can set this variable (in your ebuild, of course) to disable fetching of <module>/doc/*
# under the KCVS_SUBDIR scheme. this is appropriate for kde-i18n stuff, but not for
# eg kdeextragear, kdenonbeta etc.
# KCVS_SUBDIR_NODOC=true

# Other variables: see cvs.eclass

# we do this here and not in the very beginning because we need to keep
# the configuration order intact: env. and profile settings override
# kde-source.eclass defaults, which in turn override cvs.eclass defaults
inherit subversion
#... and reset $ECLASS. Ugly I know, hopefully I can prettify it someday
ECLASS=kde-source

# --- end user-configurable settings ---


# set this to more easily maintain cvs and std ebuilds side-by-side
# (we don't need to remove SRC_URI, kde-dist.eclass, kde.org.eclass etc
# from the cvs ones). To download patches or something, set SRC_URI again after
# inheriting kde_source.
SRC_URI=""
DESCRIPTION="$DESCRIPTION (development version) "

if [ -z $KSCM_ROOT ]; then
	
	ESCM_ROOT="trunk"
	
	# Base KDE modules live under KDE
	[ "$KDEBASE" == "true" ] && ESCM_ROOT="branches/KDE/3.5/"

	# KOffice modules live right in the root of the trunk
	[ "$KMNAME" == "koffice" ] && ESCM_ROOT=""

else

	# Ebuild-set root
	ESCM_ROOT="$KSCM_ROOT/"

fi

# If using meta-ebuilds set KSCM_SUBDIR and KSCM_MODULE
[ -n "$KMNAME" ] && KSCM_SUBDIR="$PN" && KSCM_MODULE="$KMNAME"

if [ -n "$KSCM_SUBDIR" -o -n "$KSCM_MODULE" ]; then
	S="$WORKDIR/$ESCM_ROOT$KSCM_MODULE"
	SVN_MODULE="${ESCM_ROOT}${KSCM_MODULE}"
else
	# default for kde-base ebuilds
	S="$WORKDIR/$ESCM_ROOT${KSCM_MODULE:-$PN}"
	SVN_MODULE="${ESCM_ROOT}${KSCM_MODULE:-$PN}"
fi

kde-source_src_unpack() {

	debug-print-function $FUNCNAME $*

	ESCM_EXTERNALS="$ESCM_EXTERNALS branches/KDE/3.5/kde-common/admin"
	ESCM_DEEPITEMS="$ESCM_DEEPITEMS $ESCM_EXTERNALS"
	
	# If submodules are used we fetch the module + specific extra files
	if [ -n "$KSCM_SUBDIR" ]; then
		
		# deeplist stores items to be fetched recursively
		deeplist=""

		# shallowlist stores items to be fetched non-recursively
		shallowlist=""

		# If meta ebuilds are in use (preferrably)
		if [ -n "$KMNAME" ]; then

			# Let kde-meta create deeplist
			kde-meta_src_unpack "prepare"

			# We need Makefile.cvs for meta cvs ebuilds
			deeplist="Makefile.cvs $deeplist"

			KMEXTRA="$KMEXTRA po"

		else
			
			# The main module folder and its doc subfolder are fetched
			# non-recursively
			shallowlist="/ doc"
			deeplist="$deeplist $KSCM_SUBDIR"	

			# Unless documents are pruned, server is online or doc subfolder
			# exists
			if [ -z "$KSCM_SUBDIR_NODOC" ]; then

				deeplist="$deeplist doc/${KSCM_SUBDIR}"

			fi

		fi
		
		# Create module items to fetch recursively
		for item in $deeplist
		do
			ESCM_DEEPITEMS=`echo "$ESCM_DEEPITEMS $ESCM_ROOT$KSCM_MODULE/$item" | sed -e "s/\/*$//g"`
		done

		# Create module items to fetch non-recursively
		# Shallow items are useful if submodules are used, but not meta-ebuilds
		# since meta-ebuilds can pick and choose files and directories
		for item in $shallowlist
		do
			ESCM_SHALLOWITEMS=`echo "$ESCM_SHALLOWITEMS $ESCM_ROOT$KSCM_MODULE/$item" | sed -e "s/\/*$//g"`
		done

		[ -z "$KSCM_L10N_PO" ] && KSCM_L10N_PO="$KSCM_SUBDIR"

	else

		# If submodules are not used, and the module is the same as the ebuild name.
		# Used by monolithic ebuilds with intact names (old kde-base)
		if [ -z "$KSCM_MODULE" ]; then
			
			KSCM_MODULE="$PN"

		fi
		
		ESCM_DEEPITEMS="$ESCM_DEEPITEMS $ESCM_ROOT$KSCM_MODULE"

	fi

	if [ -z "$KSCM_L10N_MODULE" ]; then

		[ "$KSCM_ROOT" == "extragear" ] && KSCM_L10N_MODULE=extragear-$KSCM_MODULE || KSCM_L10N_MODULE=$KSCM_MODULE

	fi

	# Fetch all translations listed in LINGUAS
	for lang in $LINGUAS
	do

		ESCM_DEEPITEMS="$ESCM_DEEPITEMS l10n/$lang/messages/$KSCM_L10N_MODULE"
		#ESCM_DEEPITEMS="$ESCM_DEEPITEMS l10n/$lang/docs/$KSCM_L10N_MODULE/$KSCM"

	done
	
	# Handle patches
	if [ -z "$KMNAME" ]; then

		ESVN_PATCHES="$PATCHES"

	fi

	# Finally fetch needed items
	subversion_src_unpack

	# Make sure to patch and prune makefiles if meta-ebuilds are in use
	if [ -n "$KMNAME" ]; then
	
		# Ask kde-meta to handle patches and prune makefiles as needed
		kde-meta_src_unpack "patches makefiles"

	fi

	for lang in $LINGUAS
	do
	
		local srcdir="$WORKDIR/l10n/$lang/messages/$KSCM_L10N_MODULE"
		local destdir="$S/po/$lang"

		mkdir -p $destdir
		[ -z "$KSCM_L10N_PO" ] && KSCM_L10N_PO="\"*\""

		for po in $KSCM_L10N_PO
		do

			cp $srcdir/`eval echo $po`.po $destdir

		done

		echo "KDE_LANG = $lang" > $destdir/Makefile.am
		echo "SUBDIRS = \$(AUTODIRS)" >> $destdir/Makefile.am
		echo "POFILES = AUTO" >> $destdir/Makefile.am

	done

	[ -d $S/po ] && echo "SUBDIRS = \$(AUTODIRS)" > $S/po/Makefile.am
	
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

	# Visiblity stuff is way broken! Just disable it when it's present
	# until upstream finds a way to have it working right.
	if grep KDE_ENABLE_HIDDEN_VISIBILITY configure.in &> /dev/null || ! [[ -f configure ]]; then
		find ${S} -name configure.in.in | xargs sed -i -e 's:KDE_ENABLE_HIDDEN_VISIBILITY:echo Disabling hidden visibility:g'
		rm -f configure
	fi

}

EXPORT_FUNCTIONS src_unpack

