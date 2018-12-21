#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <options>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <options>"}

SRCDIR=$HOME/$1
BUILDDIR=$HOME/$2

CBCBUILDDIR=$BUILDDIR/cbcbuild
CBCORIGPATH=$SRCDIR/Cbc-*
CBCCOPYPATH=$BUILDDIR/cbcsrc

echo 
echo Setting up build directory
mkdir $BUILDDIR
rm -R $CBCBUILDDIR
mkdir $CBCBUILDDIR
rm -R $CBCCOPYPATH
cp -R $CBCORIGPATH $CBCCOPYPATH

OPENBLAS=0
SHARED=0
THREADSAFE=0
PARALLEL=1
OPENBLAS_LIB_PATH=$SRCDIR/Library/lib
OPENBLAS_INC_PATH=$SRCDIR/Library/include/openblas

for i in "$@"
do
case $i in
    --openblas)
    OPENBLAS=1
    ;;
    --openblas-lib=*)
    OPENBLAS_LIB_PATH="${i#*=}"
    ;;
    --openblas-inc=*)
    OPENBLAS_INC_PATH="${i#*=}"
    ;;
    --shared)
    SHARED=1
    ;;
    --nopar)
    PARALLEL=0
    ;;
    --threadsafe)
    THREADSAFE=1
    ;;
    *)
    # Ignored
    ;;
esac
done

echo 
echo Using the following settings to configure CBC:
echo SRCDIR = ${SRCDIR}
echo BUILDDIR = ${BUILDDIR}
echo CBCBUILDDIR = ${CBCBUILDDIR}
echo CBCORIGPATH = ${CBCORIGPATH}
echo CBCCOPYPATH = ${CBCCOPYPATH}
echo OPENBLAS = ${OPENBLAS}
echo OPENBLAS_LIB_PATH = ${OPENBLAS_LIB_PATH}
echo OPENBLAS_INC_PATH = ${OPENBLAS_INC_PATH}
echo SHARED = ${SHARED}
echo THREADSAFE = ${THREADSAFE}

echo 
echo Obtaining third party libs
cd ${CBCCOPYPATH}/ThirdParty/Mumps
./get.Mumps
cd ${CBCCOPYPATH}/ThirdParty/Metis
./get.Metis

if [ $OPENBLAS == 0 ] 
then
cd ${CBCCOPYPATH}/ThirdParty/Blas
./get.Blas
cd ${CBCCOPYPATH}/ThirdParty/Lapack
./get.Lapack
fi

CONFIGURATION=$'./configure \
  --prefix='"${CBCBUILDDIR}"' \'

if [ $PARALLEL == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  --enable-cbc-parallel \'
fi

if [ $SHARED == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --enable-shared --disable-static \
  --enable-dependency-linking lt_cv_deplibs_check_method=pass_all \
  --with-pic \'
fi

if [ $OPENBLAS == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  --with-blas-lib="-L'"${OPENBLAS_LIB_PATH}"' -lopenblas" \
  --with-lapack-lib="-L'"${OPENBLAS_LIB_PATH}"' -lopenblas" \
  --with-blas-incdir="${OPENBLAS_INC_PATH}" \
  --with-lapack-incdir="${OPENBLAS_INC_PATH}" \'
fi

if [ $THREADSAFE == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  CDEFS="-DCBC_THREAD_SAFE -DCBC_NO_INTERRUPT -DHAVE_STRUCT_TIMESPEC" \
  CXXDEFS="-DCBC_THREAD_SAFE -DCBC_NO_INTERRUPT -DHAVE_STRUCT_TIMESPEC" \'
fi

CONFIGURATION=$"${CONFIGURATION}"'
  '

echo 
echo Config invocation:
echo "${CONFIGURATION}"

cd ${CBCCOPYPATH}

eval "$CONFIGURATION"
make -j 2
make install
