#! /usr/bin/bash

make clean
make cleanall
CC=icx-cc CXX=icpx make linux
./skynet ./benchmark/etc/config