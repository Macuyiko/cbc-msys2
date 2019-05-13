#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}
: ${3?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SRCDIR=$1
BUILDDIR=$2
DEPLOYDIR=$3

rm -R ${BUILDDIR}
mkdir ${BUILDDIR}
rm -R ${DEPLOYDIR}
mkdir ${DEPLOYDIR}

# OpenBlas
./compile-openblas.sh ${SRCDIR} ${BUILDDIR}

# Static CBC and jCbc
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --threadsafe --openblas
./compile-jcbc.sh ${SRCDIR} ${BUILDDIR} --openblas

# Move to deployment directory
cp ${BUILDDIR}/openblasbuild/bin/* ${DEPLOYDIR}
cp ${BUILDDIR}/jcbcbuild/* ${DEPLOYDIR}
cp ${BUILDDIR}/cbcbuild/bin/cbc.exe ${DEPLOYDIR}/cbc-static.exe
cp ${BUILDDIR}/cbcbuild/bin/clp.exe ${DEPLOYDIR}/clp-static.exe

# Shared CBC
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --threadsafe --shared --openblas

# Move to deployment directory
cp ${BUILDDIR}/cbcbuild/bin/* ${DEPLOYDIR}

echo 
echo Done, cygcheck output follows below:
echo 

cd $DEPLOYDIR
python2 $SCRIPTPATH/check-arch.py ./jCbc.dll
cygcheck ./jCbc.dll
python2 $SCRIPTPATH/check-arch.py ./cbc-static.exe
cygcheck ./cbc-static.exe

echo
echo Make sure to move the necessary DLLs to deployment directory
echo 

cd $SCRIPTPATH
