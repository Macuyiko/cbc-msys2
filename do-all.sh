#!/bin/bash

: ${1?"Usage: $0 <download dirname> <src dirname> <build dirname>"}
: ${2?"Usage: $0 <download dirname> <src dirname> <build dirname>"}
: ${3?"Usage: $0 <download dirname> <src dirname> <build dirname>"}

DOWNLOADDIR=$1
SRCDIR=$2
BUILDDIR=$3

OPENBLAS_LIB=$HOME/openblasbuild/lib
OPENBLAS_INC=$HOME/openblasbuild/include

echo 'This compiles CBC-trunk with self-compiled OpenBLAS'
echo 'To change prerequisites version, modify download-prerequisites script'
echo 'To change OpenBLAS version (coin, conda binary or self-compiled) or CBC version, modify this script'
read -n1 -r -p "Press any key to continue..." key

echo 
echo Downloading and compiling OpenBLAS...
./compile-openblas.sh

echo 
echo Downloading prerequisites...
./download-prerequisites.sh ${DOWNLOADDIR}

echo 
echo Inflating prerequisites...
./inflate-prerequisites.sh ${DOWNLOADDIR} ${SRCDIR}

echo 
echo Downloading CBC-trunk...
./download-cbc-trunk.sh ${DOWNLOADDIR} ${SRCDIR}

echo 
echo Building static CBC...
./compile-cbc.sh src build --threadsafe --openblas --openblas-lib=${OPENBLAS_LIB} --openblas-inc=${OPENBLAS_INC}

echo 
echo Building jCBC...
./compile-jcbc.sh src build --openblas --openblas-lib=${OPENBLAS_LIB} --openblas-inc=${OPENBLAS_INC}

rm -R ${HOME}/${BUILDDIR}/deployment
mkdir ${HOME}/${BUILDDIR}/deployment

cp ${HOME}/${BUILDDIR}/jcbcbuild/* ${HOME}/${BUILDDIR}/deployment/
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/cbc.exe ${HOME}/${BUILDDIR}/deployment/cbc-static.exe
cp ${HOME}/${BUILDDIR}/cbcbuild/bin/clp.exe ${HOME}/${BUILDDIR}/deployment/clp-static.exe

echo 
echo Building shared CBC...
./compile-cbc.sh src build --threadsafe --shared --openblas --openblas-lib=${OPENBLAS_LIB} --openblas-inc=${OPENBLAS_INC}

cp ${HOME}/${BUILDDIR}/cbcbuild/bin/* ${HOME}/${BUILDDIR}/deployment/
cp ${OPENBLAS_LIB}/../bin/* ${HOME}/${BUILDDIR}/deployment/

echo 
echo Done, here is the cygcheck output:
cygcheck ${HOME}/${BUILDDIR}/deployment/cbc.exe

echo Make sure to move the necessary DLLs to deployment directory
