#!/bin/bash

: ${1?"Usage: $0 <download dirname>"}

DOWNLOADDIR=$HOME/$1

mkdir $DOWNLOADDIR
rm $DOWNLOADDIR/*

wget https://www.coin-or.org/download/source/Cbc/Cbc-2.9.9.zip -O $DOWNLOADDIR/cbc.zip
wget https://github.com/JNICbc/jCbc/archive/master.zip -O $DOWNLOADDIR/jcbc.zip

wget https://anaconda.org/conda-forge/openblas/0.3.4/download/win-64/openblas-0.3.4-h535eed3_1000.tar.bz2 -O $DOWNLOADDIR/openblas.tar.bz2
wget https://anaconda.org/conda-forge/libflang/5.0.0/download/win-64/libflang-5.0.0-h6538335_20180525.tar.bz2 -O $DOWNLOADDIR/libflang.tar.bz2
wget https://anaconda.org/conda-forge/openmp/7.0.0/download/win-64/openmp-7.0.0-h1ad3211_0.tar.bz2 -O $DOWNLOADDIR/openmp.tar.bz2

wget http://prdownloads.sourceforge.net/swig/swigwin-3.0.12.zip -O $DOWNLOADDIR/swigwin.zip