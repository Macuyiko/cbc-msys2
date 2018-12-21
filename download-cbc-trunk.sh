#!/bin/bash

: ${1?"Usage: $0 <download dirname> <src dirname>"}
: ${2?"Usage: $0 <download dirname> <src dirname>"}

DOWNLOADDIR=$HOME/$1
SRCDIR=$HOME/$2

mkdir $DOWNLOADDIR
mkdir $SRCDIR

# svn doesn't work quite right on MSYS2, so use svnkit instead
wget https://www.svnkit.com/org.tmatesoft.svn_1.9.3.standalone.zip -O $DOWNLOADDIR/svnkit.zip
unzip $DOWNLOADDIR/svnkit.zip -d $SRCDIR
export JAVA_HOME="C:/Program Files/Java/jdk1.7.0_80"
cd $SRCDIR
$SRCDIR/svnkit-*/bin/jsvn co https://projects.coin-or.org/svn/Cbc/trunk/ -r HEAD

rm -R $SRCDIR/Cbc-*
mv $SRCDIR/trunk $SRCDIR/Cbc-trunk

cd $HOME