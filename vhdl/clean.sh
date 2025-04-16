#!/bin/bash

for folder in 1 2 3 4 5 6 7 
do

  cd "ex$folder"
  ../make.sh clean
  cd ..

done