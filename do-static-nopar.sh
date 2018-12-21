#!/bin/bash

: ${1?"Usage: $0 <download dirname> <src dirname> <build dirname>"}
: ${2?"Usage: $0 <download dirname> <src dirname> <build dirname>"}
: ${3?"Usage: $0 <download dirname> <src dirname> <build dirname>"}

DOWNLOADDIR=$1
SRCDIR=$2
BUILDDIR=$3

OPENBLAS_LIB=$HOME/openblasbuild/lib
OPENBLAS_INC=$HOME/openblasbuild/include

echo 'To change prerequisites version, modify download-prerequisites script'
echo 'To change OpenBLAS version (coin, conda binary or self-compiled), modify this script'
read -n1 -r -p "Press any key to continue..." key

echo 
echo Downloading prerequisites...
./download-prerequisites.sh ${DOWNLOADDIR}

echo 
echo Inflating prerequisites...
./inflate-prerequisites.sh ${DOWNLOADDIR} ${SRCDIR}

echo 
echo Building static CBC...
./compile-cbc.sh src build --nopar

rm -R ${HOME}/${BUILDDIR}/deployment
mkdir ${HOME}/${BUILDDIR}/deployment

cp -R ${HOME}/${BUILDDIR}/cbcbuild/bin/*.exe ${HOME}/${BUILDDIR}/deployment/

echo 
echo Done, here is the cygcheck output:
cygcheck ${HOME}/${BUILDDIR}/deployment/cbc.exe
