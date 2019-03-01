#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}
: ${3?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}

SRCDIR=$1
BUILDDIR=$2
DEPLOYDIR=$HOME/$3

rm -R ${BUILDDIR}
mkdir ${BUILDDIR}
rm -R ${DEPLOYDIR}
mkdir ${DEPLOYDIR}

# OpenBlas
./compile-openblas.sh ${SRCDIR} ${BUILDDIR} --32

# Static CBC and jCbc
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --32 --threadsafe --openblas
./compile-jcbc.sh ${SRCDIR} ${BUILDDIR} --32 --openblas

# Move to deployment directory
cp ${HOME}/${BUILDDIR}/openblasbuild/bin/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/jcbcbuild/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/cbc.exe ${DEPLOYDIR}/cbc-static.exe
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/clp.exe ${DEPLOYDIR}/clp-static.exe

# Shared CBC
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --32 --nopar --threadsafe --shared --openblas

# Move to deployment directory
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/* ${DEPLOYDIR}

echo 
echo Done, cygcheck output follows below:
echo 

cd $DEPLOYDIR
python2 $HOME/check-arch.py ./jCbc.dll
cygcheck ./jCbc.dll
python2 $HOME/check-arch.py ./cbc-static.exe
cygcheck ./cbc-static.exe
cd $HOME

echo
echo Make sure to move the necessary DLLs to deployment directory
echo 
