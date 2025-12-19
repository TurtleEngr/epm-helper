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
	touch ver.sh
	make ver.mak
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
	mkdir -p dist/usr/local/bin
	mkdir -p dist/usr/local/man/man1
	mkdir -p dist/usr/local/share/doc/$(ProdName)
	cd src/bin; chmod a+rx *
	cp src/bin/* dist/usr/local/bin
	pod2man src/bin/mkver.pl >dist/usr/local/man/man1/mkver.pl.1
	pod2man src/bin/patch-epm-list >dist/usr/local/man/man1/patch-epm-list.1
	gzip dist/usr/local/man/man1/*
	cp src/doc/* dist/usr/local/share/doc/$(ProdName)
	cp README.md dist/usr/local/share/doc/$(ProdName)
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
	-rm ver.mak
	-rm -rf pkg >/dev/null 2>&1

test-package : epm.list epm.require
	-rm -rf pkg ver.epm >/dev/null 2>&1
	mkdir pkg
	export RELEASE=0; src/bin/mkver.pl -e epm
	epm -v -f native -m linux-noarch --output-dir pkg $(ProdName) ver.epm
	epm -v -f portable -m linux-noarch --output-dir pkg $(ProdName) ver.epm

test-release : TBD

clean-test-release :
	# Remove all epm-helper packages from repo

package : epm.list epm.require
	# Set ProdRC for Release Candidate packages
	-rm -rf pkg ver.epm >/dev/null 2>&1
	mkdir pkg
	export RELEASE=1; src/bin/mkver.pl -e epm
	epm -v -f native -m linux-noarch --output-dir pkg $(ProdName) ver.epm
	epm -v -f portable -m linux-noarch --output-dir pkg $(ProdName) ver.epm

release : ver.env ver.mak
	. ./ver.env; echo "ssh $(ProdRelServer) mkdir -p $(ProdRelRoot)/released/software/ThirdParty/epm"
	-. ./ver.env; ssh $(ProdRelServer) mkdir -p $(ProdRelRoot)/released/software/ThirdParty/epm
	. ./ver.env; ssh $(ProdRelServer) test -d $(ProdRelRoot)/released/software/ThirdParty/epm
	. ./ver.env; rsync -zP pkg/$(ProdName)-* $(ProdRelServer):$(ProdRelRoot)/released/software/ThirdParty/epm

tag : ver.env ver.mak
	-git commit -am Updated
	. ./ver.env; git tag -f -a -m "Released to: $(ProdRelServer):$(ProdRelDir)" $(ProdTag)
	echo "# --------------------" >>VERSION
	date -u +'%F %R UTC' >>VERSION
	. ./ver.env; echo "$(ProdTag)" >>VERSION
	. ./ver.env; echo "Released: $$(ls pkg)" >>VERSION
	. ./ver.env; echo "to: $(ProdRelServer):$(ProdRelRoot)/released/software/ThirdParty/epm" >>VERSION
	#git commit -am Updated
	#git push origin develop
	#git push --tags -f

clean-rc-release :
	# Remove all epm-helper Release Candidates from repo

# --------------------
# Work Targets

ver.mak ver.epm ver.env : ver.sh src/bin/mkver.pl src/bin/patch-epm-list
	src/bin/mkver.pl -e 'mak env epm'

doc : $(mDoc) src/doc/ver.sh.default

src/doc/ver.sh.default : src/bin/mkver.pl
	-mkdir tmp
	cd tmp; ../src/bin/mkver.pl -e env
	cp -f tmp/ver.sh src/doc/ver.sh.default

src/doc/mkver.pl.html : src/bin/mkver.pl
	pod2html --title="$(notdir $?)" $(mHtmlOpt) <$? >$@

src/doc/patch-epm-list.html : src/bin/patch-epm-list
	pod2html --title="$(notdir $?)" $(mHtmlOpt) <$? >$@

src/doc/mkver.pl.md : src/bin/mkver.pl
	pod2markdown <$? >$@

src/doc/patch-epm-list.md : src/bin/patch-epm-list
	pod2markdown <$? >$@
