#!/bin/bash

: ${1?"Usage: $0 <download dirname>"}

DOWNLOADDIR=$HOME/$1

rm -R $DOWNLOADDIR
mkdir $DOWNLOADDIR

echo 
echo 'Downloading prerequisites (CBC, trunk-cbc, jCbc, swigwin, OpenBLAS)'
echo 'Modify this script in case you want to change versions'
echo 'Downloading trunk-cbc uses svnkit, modify the JAVA_HOME if needed'
echo 

wget https://www.coin-or.org/download/source/Cbc/Cbc-2.10.0.zip -O $DOWNLOADDIR/cbc.zip
wget https://github.com/JNICbc/jCbc/archive/master.zip -O $DOWNLOADDIR/jcbc.zip
wget http://prdownloads.sourceforge.net/swig/swigwin-3.0.12.zip -O $DOWNLOADDIR/swigwin.zip
wget https://github.com/xianyi/OpenBLAS/archive/v0.3.5.zip -O $DOWNLOADDIR/openblas.zip

# svn doesn't work quite right on MSYS2, so use svnkit instead
wget https://www.svnkit.com/org.tmatesoft.svn_1.9.3.standalone.zip -O $DOWNLOADDIR/svnkit.zip
unzip $DOWNLOADDIR/svnkit.zip -d $DOWNLOADDIR
export JAVA_HOME="C:/Program Files/Java/jdk1.7.0_80"
cd $DOWNLOADDIR
$DOWNLOADDIR/svnkit-*/bin/jsvn co https://projects.coin-or.org/svn/Cbc/trunk/ -r HEAD
mv $DOWNLOADDIR/trunk $DOWNLOADDIR/trunk-cbc

cd $HOME
