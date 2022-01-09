# Directions

# Run this first to check for dependencies and to setup meta-date for packaging
# make first

# Collect the files for the package into pseudo root dist/
# make build

# Run unit tests
# make test

# Use this to start with a fresh build (build always runs this)
# make clean

# Use this to clean up all unversioned files (after making and releasing
# packages)
# make dist-clean

# Create the native and portable packages.
# Packages versions use the ProdSemVer var
# make test-package

# Push the packages to a test "release" server and/or apt repository
# make test-release

# Remove all but the last test package
# make clean-test-release

# Create the native and portable packages
# Production packages versions use the ProdBuild var
# make package

# Push the packages to a "release" server and/or apt repository
# make release

# --------------------
include ver.mak

# --------------------
# Config

mHtmlOpt = --cachedir=/tmp --index --backlink

mDoc = \
	src/doc/mkver.pl.html \
	src/doc/patch-epm-list.html \
	src/doc/mkver.pl.md \
	src/doc/patch-epm-list.md

# --------------------
# Main targets

first : ver.mak ver.epm
	@which epm
	@which epminstall
	@which perl
	@which pod2usage
	@which pod2text
	@which pod2man
	@which pod2html
	@which pod2markdown

build epm.list : clean doc ver.mak ver.epm
	-rm -rf dist >/dev/null 2>&1
	-mkdir -p doc
	mkdir -p dist/usr/local/bin
	mkdir -p dist/usr/local/man/man1
	mkdir -p dist/usr/local/share/doc/epm-helpers
	cd src/bin; chmod a+rx *
	cp src/bin/* dist/usr/local/bin
	pod2man src/bin/mkver.pl >dist/usr/local/man/man1/mkver.pl.1
	pod2man src/bin/patch-epm-list >dist/usr/local/man/man1/patch-epm-list.1
	gzip dist/usr/local/man/man1/*
	cp src/doc/* dist/usr/local/share/doc/epm-helpers
	cp README.md dist/usr/local/share/doc/epm-helpers
	find dist -executable -exec chmod a+rx {} \;
	mkepmlist -u root -g root --prefix / dist | src/bin/patch-epm-list -f ./epm.patch >epm.list

test :
	cd test; make

clean :
	-rm epm.list ver.cs ver.env ver.epm ver.h ver.java ver.pl ver.xml >/dev/null 2>&1
	-rm -rf dist tmp >/dev/null 2>&1
	-find * -name '*~' -exec rm {} \; >/dev/null 2>&1

dist-clean : clean
	-cd test; make clean
	-rm -rf pkg >/dev/null 2>&1

test-package : epm.list ver.epm epm.require
	-rm -rf pkg >/dev/null 2>&1
	mkdir pkg
	export RELEASE=0; . ./ver.env; epm -v -f native -m linux-noarch --output-dir pkg epm-helpers ver.epm
	export RELEASE=0; . ./ver.env; epm -v -f portable -m linux-noarch --output-dir pkg epm-helpers ver.epm

test-release :

clean-test-release :

package : epm.list ver.epm epm.require
	-rm -rf pkg >/dev/null 2>&1
	mkdir pkg
	export RELEASE=1; . ./ver.env; epm -v -f native -m linux-noarch --output-dir pkg epm-helpers ver.epm
	export RELEASE=1; . ./ver.env; epm -v -f portable -m linux-noarch --output-dir pkg epm-helpers ver.epm

release :

# --------------------
# Work Targets

ver.mak ver.epm ver.env : ver.sh src/bin/mkver.pl src/bin/patch-epm-list
	src/bin/mkver.pl -d ver.sh -e 'mak env epm'

doc : $(mDoc) src/doc/ver.sh.default

src/doc/ver.sh.default : src/bin/mkver.pl
	-mkdir tmp
	cd tmp; ../src/bin/mkver.pl -e env >/dev/null 2>&1
	cp -f tmp/ver.sh src/doc/ver.sh.default

src/doc/mkver.pl.html : src/bin/mkver.pl
	pod2html --title="$(notdir $?)" $(mHtmlOpt) $? >$@

src/doc/patch-epm-list.html : src/bin/patch-epm-list
	pod2html --title="$(notdir $?)" $(mHtmlOpt) $? >$@

src/doc/mkver.pl.md : src/bin/mkver.pl
	pod2markdown $? >$?

src/doc/patch-epm-list.md : src/bin/patch-epm-list
	pod2markdown $? >$?
