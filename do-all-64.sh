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
./compile-openblas.sh ${SRCDIR} ${BUILDDIR}

# Static CBC and jCbc
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --threadsafe --openblas
./compile-jcbc.sh ${SRCDIR} ${BUILDDIR} --openblas

# Move to deployment directory
cp ${HOME}/${BUILDDIR}/openblasbuild/bin/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/jcbcbuild/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/cbc.exe ${DEPLOYDIR}/cbc-static.exe
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/clp.exe ${DEPLOYDIR}/clp-static.exe

# Shared trunk-cbc
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --threadsafe --shared --openblas --use-trunk

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