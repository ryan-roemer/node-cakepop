#!/bin/bash

# Check no outstanding changes.
git status | grep "nothing to commit"
if [[ $? -ne "0" ]]; then
  echo "Uncommitted changes."
  exit 1
fi
