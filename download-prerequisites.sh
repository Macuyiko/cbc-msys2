#!/bin/bash

: ${1?"Usage: $0 <download dirname>"}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
DOWNLOADDIR=$1

rm -R -f $DOWNLOADDIR
mkdir $DOWNLOADDIR

echo 
echo 'Downloading prerequisites (CBC, trunk-cbc, jCbc, swigwin, OpenBLAS)'
echo 'Modify this script in case you want to change versions'
echo 

wget https://www.coin-or.org/download/source/Cbc/Cbc-2.10.5.zip -O $DOWNLOADDIR/cbc.zip
wget https://github.com/JNICbc/jCbc/archive/master.zip -O $DOWNLOADDIR/jcbc.zip
wget http://prdownloads.sourceforge.net/swig/swigwin-4.0.1.zip -O $DOWNLOADDIR/swigwin.zip
wget https://github.com/xianyi/OpenBLAS/archive/v0.3.9.zip -O $DOWNLOADDIR/openblas.zip

wget https://raw.githubusercontent.com/coin-or/coinbrew/master/coinbrew -O $DOWNLOADDIR/coinbrew.sh
chmod u+x $DOWNLOADDIR/coinbrew.sh

cd $DOWNLOADDIR
svn co https://projects.coin-or.org/svn/Cbc/trunk/ -r HEAD
mv trunk trunk-cbc

cd $SCRIPTPATH
