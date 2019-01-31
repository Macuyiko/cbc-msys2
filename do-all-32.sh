#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}
: ${3?"Usage: $0 <src dirname> <build dirname> <deploy dirname>"}

SRCDIR=$1
BUILDDIR=$2
DEPLOYDIR=$HOME/$3

rm -R ${DEPLOYDIR}
mkdir ${DEPLOYDIR}

# OpenBlas
./compile-openblas.sh ${SRCDIR} ${BUILDDIR} --32

# Static CBC and jCbc
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --32 --threadsafe --openblas
./compile-jcbc.sh ${SRCDIR} ${BUILDDIR} --32 --openblas

cp ${HOME}/${BUILDDIR}/jcbcbuild/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/cbc.exe ${DEPLOYDIR}/cbc-static.exe
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/clp.exe ${DEPLOYDIR}/clp-static.exe

# Shared trunk-cbc
./compile-cbc.sh ${SRCDIR} ${BUILDDIR} --threadsafe --shared --openblas --use-trunk

cp ${HOME}/${BUILDDIR}/cbcbuild/bin/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/openblasbuild/bin/* ${DEPLOYDIR}

echo 
echo Done, here is the cygcheck output for the static CBC:
echo 

cygcheck ${DEPLOYDIR}/cbc-static.exe

echo
echo Make sure to move the necessary DLLs to deployment directory
echo 