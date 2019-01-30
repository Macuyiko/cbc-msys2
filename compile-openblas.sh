#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <options>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <options>"}

SRCDIR=$HOME/$1
BUILDDIR=$HOME/$2

BLASBUILDDIR=$BUILDDIR/openblasbuild

mkdir $BUILDDIR
rm -R $BLASBUILDDIR
mkdir $BLASBUILDDIR

THIRTYTWOBIT=0
USE_OPENMP=1
NUM_THREADS=8
TARGET="SKYLAKE"

for i in "$@"
do
case $i in
    --32)
    THIRTYTWOBIT=1
    ;;
	--without-openmp)
    USE_OPENMP=0
    ;;
	--threads=*)
    NUM_THREADS="${i#*=}"
    ;;
    --target=*)
    TARGET="${i#*=}"
    ;;
    *)
    # Ignored
    ;;
esac
done

echo 
echo Building OpenBlas with the following settings:
echo 
echo THIRTYTWOBIT = ${THIRTYTWOBIT}
echo USE_OPENMP = ${USE_OPENMP}
echo NUM_THREADS = ${NUM_THREADS}
echo TARGET = ${TARGET}
echo 

cd $SRCDIR/OpenBLAS-*

# Previous version required this fix:
# sed -i 's/-DCR/-DCR=CR/g' ./driver/level3/Makefile

MAKE=$'make TARGET='"${TARGET}"' \
  USE_OPENMP='"${USE_OPENMP}"' \
  NUM_THREADS='"${NUM_THREADS}"' \'

if [ $THIRTYTWOBIT == 1 ] 
then
	MAKE=$"${MAKE}"'
  BINARY=32'
else
	MAKE=$"${MAKE}"'
  BINARY=64'
fi

make clean

echo 
echo Using make invocation:
echo 
echo "${MAKE}"
echo 

eval "$MAKE"
make PREFIX=$BLASBUILDDIR install

cd $HOME
