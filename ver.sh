
# Input DEF file for: mkver.pl.  All variables must have "export "
# at the beginning.  No spaces around the "=".  And all values
# enclosed with double quotes.  Variables may include other variables
# in their values.

# Set this to latest version of mkver.pl (earlier DEF files should
# still work with newer versions of mkver.pl)
export MkVer="2.2"

export ProdName="epm-helper"
# One word [-a-z0-9]
# Required
# %provides ProdName

export ProdAlias=""
# One word [-a-z0-9]

export ProdVer="1.6.1"
# [0-9]*.[0-9]*{.[0-9]*}
# Requires 2 numbers, 3'rd number is optional
# %version ProdVer

export ProdRC=""
# Release Candidate ver. Can be one or two numbers. If set:
#  %release rc.ProdRC

export ProdBuild="1"
# [0-9.]*
# Required
# If RELEASE=1
#  %release ProdBuild

# Generated ProdBuildTime=YYYY.MM.DD.hh.mm
# If RELEASE=0 or unset, then use current time (UTC): %Y.%m.%d.%H.%M
#  %release t.ProdBuildTime

export ProdSummary="epm-helper are programs work with the EPM tool."
# All on one line (< 80 char)
# %product ProdSummary

export ProdDesc="EPM will build packages across many non-windows platforms. There are a lot of meta-data about products that needs to be kept consistent acrross all the files in the product. The ver.sh file will define a single place for all meta-data variables. mkver.sh will generate the different types of include files that may be used across the different languges. Run 'mkver.sh -h" for details."
# All on one line

export ProdVendor="TurtleEngr"
# Required
# %vendor ProdVendor

export ProdPackager="RE"
# %packager ProdPackager
# Required

export ProdSupport="turtle.engr\@gmail.com"
# Appended to %vendor

export ProdCopyright="2021"
# Current year if not defined
# %copyright ProdCopyright

export ProdDate=""
# 20[0-9][0-9]-[01][0-9]-[0123][0-9]
# Current date (UTC) if empty

export ProdLicense="dist/usr/local/share/doc/epm-helper/LICENSE"
# Required
# %license ProdLicense

export ProdReadMe="dist/usr/local/share/doc/epm-helper/README.md"
# Required
# %readme ProdReadMe

# Third Party (if any) If repackaging a product, define these:
export ProdTPVendor=""
# Appended to 
export ProdTPVer=""
# Appended to 
export ProdTPCopyright=""
# Appended to %copyright

export ProdRelServer="moria.whyayh.com"
export ProdRelRoot="/rel"
export ProdRelCategory="software/ThirdParty/$ProdName/$ProdOS"
# Generated: ProdRelDir=$ProdRelRoot/released/$ProdRelCategory
# Generated: ProdDevDir=$ProdRelRoot/development/$ProdRelCategory

# Generated: ProdTag=tag-ProdVer
# (All "." in ProdVer converted to "-")

# Generated: ProdOSDist
# Generated: ProdOSVer
# Generated: ProdOS=mx19.4
#	OSDist	OSVer
# linux
# 	deb
#	ubuntu	16,18
#	mx	19,20
# 	rhes
# 	cent
# 	fc
# cygwin
#	cygwin
# mswin32
#	win	xp
# solaris
#	sun
# darwin
#	mac

# Generated: ProdArch
# i386
# x86_64

# Output file control variables. (Unused types can be removed.)
# The *File vars can include dir. names
# The *Header and *Footer defaults are more complete than what is
# shown here.

export envFile="ver.env"
export envHeader=""
export envFooter=""

export epmFile="ver.epm"
export epmHeader="%include epm.require"
export epmFooter="%include epm.list"

export makFile="ver.mak"
export makHeader=""
export makFooter=""
