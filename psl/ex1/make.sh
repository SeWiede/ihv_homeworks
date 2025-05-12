#!/bin/bash

if [[ "$1" == "clean" ]]; then
  rm -rf work
  exit
fi

source ../settings.make

"$MODELSIM_PATH" -batch -do "do run.do; quit"

