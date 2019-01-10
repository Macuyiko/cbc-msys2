#!/bin/bash

wget https://github.com/xianyi/OpenBLAS/archive/v0.3.5.zip -O $HOME/openblas-src.zip
unzip $HOME/openblas-src.zip -d $HOME
rm $HOME/openblas-src.zip

cd $HOME/OpenBLAS-*

# sed -i 's/-DCR/-DCR=CR/g' ./driver/level3/Makefile

rm -R $HOME/openblasbuild
mkdir $HOME/openblasbuild

make TARGET=SKYLAKE USE_OPENMP=1 NUM_THREADS=8
make PREFIX=$HOME/openblasbuild install

cd $HOME
