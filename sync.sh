#!/bin/bash

SRC_DIR="../node-cakepop/doc"

echo "Check no outstanding changes."
# git status | grep "nothing to commit"
# if [[ $? -ne "0" ]]; then
#   echo "Uncommitted changes."
#   exit 1
# fi

echo "Check source destination exists."
if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source directory not found."
  exit 1
fi

echo "Remove existing documentation."
rm -f *.html
rm -rf assets
rm -rf classes

echo "Copy over new documentation."
cp -rp "${SRC_DIR}//" .
