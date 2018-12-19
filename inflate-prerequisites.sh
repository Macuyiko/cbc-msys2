#!/bin/bash

: ${1?"Usage: $0 <download dirname> <src dirname>"}
: ${2?"Usage: $0 <download dirname> <src dirname>"}

DOWNLOADDIR=$HOME/$1
SRCDIR=$HOME/$2

mkdir $SRCDIR
rm -R $SRCDIR/*

unzip $DOWNLOADDIR/cbc.zip -d $SRCDIR
unzip $DOWNLOADDIR/jcbc.zip -d $SRCDIR
unzip $DOWNLOADDIR/swigwin.zip -d $SRCDIR

tar xvfj $DOWNLOADDIR/openblas.tar.bz2 --directory $SRCDIR
tar xvfj $DOWNLOADDIR/libflang.tar.bz2 --directory $SRCDIR
tar xvfj $DOWNLOADDIR/openmp.tar.bz2 --directory $SRCDIR