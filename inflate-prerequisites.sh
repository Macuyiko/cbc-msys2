#!/bin/bash

: ${1?"Usage: $0 <download dirname> <src dirname>"}
: ${2?"Usage: $0 <download dirname> <src dirname>"}

DOWNLOADDIR=$HOME/$1
SRCDIR=$HOME/$2

rm -R $SRCDIR
mkdir $SRCDIR

echo 
echo 'Extracting prerequisites (CBC, trunk-cbc, jCbc, swigwin, OpenBLAS)'
echo 

unzip $DOWNLOADDIR/cbc.zip -d $SRCDIR
unzip $DOWNLOADDIR/jcbc.zip -d $SRCDIR
unzip $DOWNLOADDIR/swigwin.zip -d $SRCDIR
unzip $DOWNLOADDIR/openblas.zip -d $SRCDIR
mv $DOWNLOADDIR/trunk-cbc $SRCDIR/trunk-cbc