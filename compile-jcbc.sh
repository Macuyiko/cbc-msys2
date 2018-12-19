#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <options>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <options>"}

SRCDIR=$HOME/$1
BUILDDIR=$HOME/$2

JCBCDIR=$SRCDIR/jCbc-master
SWIGDIR=$SRCDIR/swigwin-*
CBCBUILDDIR=$BUILDDIR/cbcbuild
SWIGBUILDDIR=$BUILDDIR/jcbcbuild

mkdir $BUILDDIR
rm -R $SWIGBUILDDIR
mkdir $SWIGBUILDDIR

PACKAGE=solver.wrapper.backend.jcbc
OPENBLAS=0
COIN_PATH=$CBCBUILDDIR
OPENBLAS_LIB_PATH=$SRCDIR/Library/lib
OPENBLAS_INC_PATH=$SRCDIR/Library/include/openblas
JAVA_PATH="C:/Program Files/Java/jdk1.7.0_80"

for i in "$@"
do
case $i in
    --package=*)
    PACKAGE="${i#*=}"
    ;;
    --openblas)
    OPENBLAS=1
    ;;
    --openblas-lib=*)
    OPENBLAS_LIB_PATH="${i#*=}"
    ;;
    --openblas-inc=*)
    OPENBLAS_INC_PATH="${i#*=}"
    ;;
    --coin-path=*)
    COIN_PATH="${i#*=}"
    ;;
    --java-path=*)
    JAVA_PATH="${i#*=}"
    ;;
    *)
    # Ignored
    ;;
esac
done

echo 
echo Using the following settings to configure jCbc:

echo SRCDIR = ${SRCDIR}
echo BUILDDIR = ${BUILDDIR}
echo JCBCDIR = ${JCBCDIR}
echo SWIGDIR = ${SWIGDIR}
echo CBCBUILDDIR = ${CBCBUILDDIR}
echo SWIGBUILDDIR = ${SWIGBUILDDIR}
echo PACKAGE = ${PACKAGE}
echo OPENBLAS = ${OPENBLAS}
echo OPENBLAS_LIB_PATH = ${OPENBLAS_LIB_PATH}
echo OPENBLAS_INC_PATH = ${OPENBLAS_INC_PATH}
echo COIN_PATH = ${COIN_PATH}
echo JAVA_PATH = ${JAVA_PATH}

SWIGMAKE1=$"${SWIGDIR}"'/swig -c++ -java -package '"${PACKAGE}"' -outdir '"${SWIGBUILDDIR}"' jCbc.i'

SWIGMAKE2=$'g++ -c -fopenmp jCbc.cpp jCbc_wrap.cxx -static -Wl,--kill-at \
  -I "'"${JAVA_PATH}"'/include" \
  -I "'"${JAVA_PATH}"'/include/win32" \
  -I "'"${COIN_PATH}"'/include/coin"'

SWIGMAKE3=$'g++ -shared -fopenmp jCbc.o jCbc_wrap.o -o jCbc.dll -static -Wl,--kill-at \
  -I "'"${JAVA_PATH}"'/include" \
  -I "'"${JAVA_PATH}"'/include/win32" \
  -I "'"${COIN_PATH}"'/include/coin" \
  -L "'"${COIN_PATH}"'/lib" \'
  
if [ $OPENBLAS == 1 ] 
then
	SWIGMAKE3=$"${SWIGMAKE3}"'
  -L "'"${OPENBLAS_LIB_PATH}"'" \
  -I "'"${OPENBLAS_INC_PATH}"'" \'
fi

SWIGMAKE3=$"${SWIGMAKE3}"'
  -lCbcSolver -lCbc -lClp -lOsiClp -lOsi -lOsiCbc -lCgl -lCoinUtils \'

if [ $OPENBLAS == 1 ] 
then
	SWIGMAKE3=$"${SWIGMAKE3}"'
  -lcoinmumps -lopenblas -lcoinmetis \'
else
	SWIGMAKE3=$"${SWIGMAKE3}"'
  -lcoinmumps -lcoinblas -lcoinlapack -lcoinmetis \'
fi

SWIGMAKE3=$"${SWIGMAKE3}"'
  -lgfortran -lz -lbz2 -lquadmath -lpthread'

 
echo 
echo Make invocations:

echo "${SWIGMAKE1}"
echo "${SWIGMAKE2}"
echo "${SWIGMAKE3}"

cd ${JCBCDIR}

eval "$SWIGMAKE1"
eval "$SWIGMAKE2"
eval "$SWIGMAKE3"

cp ${JCBCDIR}/jCbc.dll ${SWIGBUILDDIR}/jCbc.dll

