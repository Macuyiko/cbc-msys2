#!/bin/bash

: ${1?"Usage: $0 <download dirname> <src dirname> <build dirname> <deploy dirname>"}
: ${2?"Usage: $0 <download dirname> <src dirname> <build dirname> <deploy dirname>"}
: ${3?"Usage: $0 <download dirname> <src dirname> <build dirname> <deploy dirname>"}
: ${4?"Usage: $0 <download dirname> <src dirname> <build dirname> <deploy dirname> <deploy dirname>"}

DOWNLOADDIR=$1
SRCDIR=$2
BUILDDIR=$3
DEPLOYDIR=$HOME/$4

rm -R ${DEPLOYDIR}
mkdir ${DEPLOYDIR}

./download-prerequisites.sh ${DOWNLOADDIR}
./inflate-prerequisites.sh ${DOWNLOADDIR} ${SRCDIR}
./compile-openblas.sh --32

# Static CBC
./compile-cbc.sh src build --32 --threadsafe --openblas
./compile-jcbc.sh src build --32 --openblas

cp ${HOME}/${BUILDDIR}/jcbcbuild/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/cbc.exe ${DEPLOYDIR}/cbc-static.exe
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/clp.exe ${DEPLOYDIR}/clp-static.exe

# Shared trunk-cbc
./compile-cbc.sh src build --threadsafe --shared --openblas --use-trunk

cp ${HOME}/${BUILDDIR}/cbcbuild/bin/* ${DEPLOYDIR}
cp ${HOME}/${BUILDDIR}/openblasbuild/bin/* ${DEPLOYDIR}

echo 
echo Done, here is the cygcheck output for the static CBC:
echo 

cygcheck ${DEPLOYDIR}/cbc-static.exe

echo
echo Make sure to move the necessary DLLs to deployment directory
echo 