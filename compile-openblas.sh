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
NUM_THREADS=2

for i in "$@"
do
case $i in
    --32)
    THIRTYTWOBIT=1
    ;;
	--threads=*)
    NUM_THREADS="${i#*=}"
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
echo NUM_THREADS = ${NUM_THREADS}
echo 

cd $SRCDIR/OpenBLAS-*

# Previous version required this fix:
# sed -i 's/-DCR/-DCR=CR/g' ./driver/level3/Makefile

MAKE=$'make DYNAMIC_ARCH=1 \
  NUM_THREADS='"${NUM_THREADS}"' \'

if [ $THIRTYTWOBIT == 1 ] 
then
	MAKE=$"${MAKE}"'
  BINARY=32'
else
	MAKE=$"${MAKE}"'
  BINARY=64'
fi

echo 
echo Using make invocation:
echo 
echo "${MAKE}"
echo 

eval "$MAKE"
make PREFIX=$BLASBUILDDIR install

cd $HOME
