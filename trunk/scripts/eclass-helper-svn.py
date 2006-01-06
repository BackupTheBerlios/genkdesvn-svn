#!/usr/bin/python

import sys, os, output, commands, types, re, time, shutil

from os import *
from os.path import *
from commands import *
from popen2 import *
from select import *
from re import match
from optparse import OptionParser

err_closed = re.compile(".*Connection closed unexpectedly.*")
err_timeout = re.compile(".*Connection timed out.*")
err_malformed = re.compile(".*Malformed.*")
err_validate = re.compile("$Error validating server certificate for.*")
err_locked = re.compile(".*Working copy.*locked.*")
err_nonexistent = re.compile("(.*Not a versioned resource.*)|(.*Not a valid URL.*)|(.*File not found.*)|(.*is not a working copy.*)")
sleep_time=30

def einfo(message):
	sys.stdout.write(output.green(" * ") + message + "\n")

def ewarn(message):
	sys.stderr.write(output.yellow(" * ") + message + "\n")

def eerror(message):
	sys.stderr.write(output.red(" * ") + message + "\n")

def svninfo(message):
		sys.stdout.write(output.teal("   SVN: ") + message + "\n")

def svnwarn(message):
		sys.stderr.write(output.yellow("   SVN: ") + message + "\n")

def svnerr(message):
		sys.stderr.write(output.red("   SVN: ") + message + "\n")


## Class item_info encapsulates information from the svn info command regarding a module
class item_info:

	def __init__(self, handler, item):
		self.handler = handler
		self.item = item.strip("/ ")
		self.wc = self.handler.base + "/" + self.item
		self.tags = {}
		self.update(False)
		if not self.handler.offline:
			self.update(True)
	
	def info(self, item, local=False):
		tags = {}
			
		def on_output(line, tags=tags):
			line=line.strip()
			if err_nonexistent.match(line):
				tags["Node Kind"] = "nonexistent"
			elif line != "":
				(tag, value) = line.split(":", 1)
				tags[tag] = value.strip()

		def on_error(line, tags=tags):
			if err_nonexistent.match(line):
				tags["Node Kind"] = "nonexistent"
		
		if local and not exists(item):
			tags["Node Kind"] = "nonexistent"
		else:
			command="svn info " + item
			self.handler.perform(command, on_output, on_error)

		return tags

	def modifiedP(self):
		return (not self.existsP(False)) or (self.existsP(True) and self.revision(False) != self.revision(True))

	# Determine type of module (file, directory or missing)
	def type(self, remote=None):
		if remote == None:
			remote = not self.handler.offline
		return self.tags[remote]["Node Kind"]
		
	# Determine if module is a file
	def fileP(self, remote=None):
		if remote == None:
			remote = not self.handler.offline
		return self.type(remote) == "file"

	# Determine if module is a directory
	def directoryP(self, remote=None):
		if remote == None:
			remote = not self.handler.offline
		return self.type(remote) == "directory"

	# Determine if module exists
	def existsP(self, remote=None):
		if remote == None:
			remote = not self.handler.offline
		return not self.type(remote) == "nonexistent"

	def revision(self, remote=None):
		if remote == None:
			remote = not self.handler.offline
		for tag in "Last Changed Rev", "Revision":
			if tag in self.tags[remote]:
				return self.tags[remote][tag]
		else:
			eerror("QA notice: revision could not be determined")

	def mode(self, oldmode):
		modepath = self.wc + "/.svn.eclass.mode"
		if isfile(modepath):
			modefile = file(modepath, "r")
			mode = {"deep":True, "shallow":False}[modefile.readline().strip()]
			modefile.close()
			return mode
		elif self.directoryP(False):
			return True
		else:
			return oldmode

	def setmode(self, mode):
		modepath = self.wc + "/.svn.eclass.mode"
		modefile = file(modepath, "w")
		modefile.write({True:"deep", False:"shallow"}[mode])
		modefile.close()

	def remove(self):
		ewarn("Deleting " + self.wc)
		shutil.rmtree(self.wc)
		self.update(False)

	def update(self, remote=False):
		if not remote:
			self.tags[False] = self.info(self.wc, True)
		else:
			if self.existsP(False):
				self.repository = self.tags[False]["URL"].strip("/ ")
			else:
				self.repository = self.handler.repository + "/" + self.item
			self.tags[True] = self.info(self.repository)

	def log(self, revision):
		einfo("Differences between revision " + revision + " and latest revision " + self.revision())
		def on_output(line):
			if line!="":
				svninfo(line)
		command="svn log --revision " + str(int(revision)+1) + ":" + self.revision() + " " + self.repository
		self.handler.perform(command, on_output)

# Construct complete list of improper ancestors of item

class subversion_handler:

	def __init__(self, repository, path, offline):
		self.repository = repository
		self.path = path
		self.offline = offline
		self.infos = {}
		self.base = repository[repository.rfind("/")+1:]
		chdir(path)

	def handle_error(self, error, command, on_output, on_error):

		if err_closed.match(error) or err_timeout.match(error) or err_malformed.match(error): 
			ewarn("Subversion has reported the following network error:")
			svnwarn(error.split(":")[1].strip())
			einfo("Retrying in " + str(sleep_time) + " seconds")
			time.sleep(sleep_time)
			self.perform(command, on_output, on_error)
		elif err_locked.match(error):
			ewarn("Subversion reports a lock, another ebuild might be active.")
			ewarn("If no other ebuilds are active, interrupt, and execute svn cleanup on the reported directory:")
			svnwarn(error.split(":")[1].strip())
			einfo("Retrying in " + str(sleep_time) + " seconds")
			time.sleep(sleep_time)
			self.perform(command, on_output, on_error)
		else:
			on_error(error)
		return True
		
	def perform(self, command, on_output=svninfo, on_error=svnerr):
		process=Popen3(command, True)
		(stdin, stdout, stderr) = (process.tochild, process.fromchild, process.childerr)
		error = False
		while not error:
			(readables, writables, errors) = select([stdout, stderr], [], [stdin, stdout, stderr])
			for stream in readables:
				for line in stream:
					if stream == stdout:
						on_output(line.strip())
					elif stream == stderr:
						error = self.handle_error(line.strip(), command, on_output, on_error)
						if error:
							break
			if stderr.readline() == "" and stdout.readline() == "": break
		else:
			stdin.close and stdout.close and stderr.close

	def checkout(self, module="", recurse=False, ignore_externals=False):
		url=(self.repository + module).rstrip("/ ")
		einfo("Performing initial " + {True:"recursive "}.get(recurse, "") + "checkout of " + url)
		command="svn checkout --ignore-externals " + {False:"-N "}.get(recurse, "") + url
		self.perform(command)

	def update(self, module="", recurse=False, ignore_externals=False):
		if not self.offline:
			url=(self.base + "/" + module).rstrip("/ ")
			einfo("Updating working copy of " + url + {True:" recursively"}.get(recurse, ""))
			command="svn update --ignore-externals " + {False:"-N "}.get(recurse, "") + url
			self.perform(command)
	  
	def info(self, item=""):
		if item in self.infos:
			return self.infos[item]
		else:
			return item_info(self, item)

def ancestors(item, recurse, descendents=[]):
	if item == "":
		return descendents[0]
	else:
		return ancestors(dirname(item), False, [[[[item, recurse]] + descendents]])

# Create tree of ancestries
def ancestree(ancestries, ancestors):
	for ancestry in ancestries:
		if ancestry[0][0] == ancestors[0][0][0]:
			if ancestors[0][0][1] or ancestry[0][1]:
				ancestry[0][1] = True
				if len(ancestry) >= 1:
					del ancestry[1:]
			elif len(ancestry) == 1:
				ancestry.append(ancestors[0][1])
			elif len(ancestors[0]) > 1:
				ancestree(ancestry[1], ancestors[0][1])
			break
	else:
		ancestries += ancestors

def print_ancestries(ancestries, indent=0):
	for ancestry in ancestries:
		if type(ancestry[0][0]) == types.StringType:
			tabspace = ""
			for i in range(indent):
				tabspace += "  "
			print tabspace + {True:output.red, False:output.blue}[ancestry[0][1]](ancestry[0][0])
			if len(ancestry) > 1:
				print_ancestries(ancestry[1], indent+1)
		else:
			print_ancestries(ancestry[1:], indent+1)

def update_modules(ancestries, svnrevs):
	for ancestry in ancestries:
		module=ancestry[0][0]
		info = subversion.info(module)
		if type(module == types.StringType):
			recurse=ancestry[0][1]
			if info.directoryP():
				if info.mode(recurse):
					recurse = True
				elif recurse:
					info.remove()
				#if info.modifiedP():
				# Unfortunately there is no way to determine if files have been erased
				# So update always
				subversion.update(module, recurse)
				info.update()
				info.setmode(recurse)
				if svnrevs:
					svnrevs.write(module + ":" + info.revision(False) + "\n")
			if len(ancestry) > 1:
				update_modules(ancestry[1], svnrevs)
		else:
			update_modules(ancestry[1:], svnrevs)

if __name__ == "__main__":

	parser = OptionParser()
	parser.add_option("--work-base", action="store", type="string", dest="work_base", help="local storage for working copies")
	parser.add_option("--repository", action="store", type="string", dest="repository", help="repository to check out from")
	parser.add_option("--revdb-in", action="store", type="string", dest="revdb_in", help="path to file to read revision numbers from")
	parser.add_option("--revdb-out", action="store", type="string", dest="revdb_out", help="path to file to record revision numbers in")
	parser.add_option("--deep", action="append", type="string", dest="deep", default=[], help="item to be checked out recursively")
	parser.add_option("--shallow", action="append", type="string", dest="shallow", default=[], help="item to be checked out non-recursively")
	parser.add_option("--check", action="append", type="string", dest="check", default=[], help="item to be checked for revision changes")
	parser.add_option("--logonly", action="store_true", dest="logonly", help="")
	parser.add_option("--checkrevs", action="store_true", dest="checkrevs", help="")
	parser.add_option("--offline", action="store_true", dest="offline", help="specify if operation is to be in offline mode")
	(values, args) = parser.parse_args()

	work_base = values.work_base
	repository = values.repository
	revdb_in = values.revdb_in and file(values.revdb_in, "r")
	revdb_out = values.revdb_out and file(values.revdb_out, "w")
	deep = [ deep.strip("/ ") for deep in values.deep ]
	shallow = [ shallow.strip("/ ") for shallow in values.shallow ]
	check = [ check.strip("/ ") for check in values.check ]
	checkrevs = values.checkrevs
	logonly = values.logonly
	revisions = {}

	base_module=repository[repository.rfind("/")+1:]
	working_copy=work_base + "/" + base_module

	if not isdir(work_base):
		einfo("Creating local repository for working copies in " + work_base)
		mkdir(work_base)
	
	subversion = subversion_handler(repository, work_base, values.offline)

	# Extract revisions from input revision database of item:revision pairs
	if revdb_in:
		for line in revdb_in:
			(item, revision) = line.split(":")
			revisions[item] = revision.strip()
		revdb_in.close()

	if checkrevs and len(check) > 0:
		for item in check:
			einfo({True:"(offline) "}.get(values.offline, "") + "Comparing installed vs. latest revision of " + item)
			info = subversion.info(item)
			# If repository claims item as directory, compare its revision to revision provided
			if info.directoryP():
				if item not in revisions:
					break
				elif info.revision() != revisions[item]:
					if logonly:
						info.log(revisions[item])
					else:
						break
			# If repository claims item as file, compare its topdir's revision to revision provided for topdir
			elif info.fileP():
				topdir = dirname(item)
				einfo({True:"(offline) "}.get(values.offline, "") + "Comparing installed vs. latest revision of " + topdir)
				topdir_info = subversion.info(topdir)
				if topdir not in revisions:
					break
				elif topdir_info.revision() != revisions[topdir]:
					if logonly:
						topdir_info.log(revisions[topdir])
					else:
						break
			# If repository claims item does not exist, see if it is in provided revision
			elif item in revisions:
				if not logonly:
					break
		else:
			if logonly:
				sys.exit(17)
			else:
				einfo("Revisions have NOT changed")
				sys.exit(16)
		einfo("Revisions have changed")
	if logonly:
		sys.exit(17)
		
	if not values.offline:
		einfo("Synchronizing with repository at " + repository + " in " + work_base)
		if isdir(working_copy + "/.svn"):
			if subversion.info().modifiedP():
				subversion.update()
		else:
			subversion.checkout()

	ancestries=[]
	for item in deep:
		ancestree(ancestries, ancestors(item, True))
	for item in shallow:
		ancestree(ancestries, ancestors(item, False))

	#print_ancestries(ancestries)
	update_modules(ancestries, revdb_out)
