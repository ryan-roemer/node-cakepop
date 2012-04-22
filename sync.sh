#!/bin/bash

REPO="../node-cakepop"
SRC_DIR="${REPO}/doc"
HASH=`cd ${REPO} && git rev-parse HEAD`

echo "Check no outstanding changes."
git status | grep "nothing to commit"
if [[ $? -ne "0" ]]; then
  echo "Uncommitted changes."
  exit 1
fi

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

echo "Copied documentation for ${HASH}."
