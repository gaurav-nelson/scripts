#!/bin/bash
set -ev

touch _external.txt
touch _internal.txt
touch _blocks.txt

COMMIT_HASH="$(git rev-parse @~)" #get the previous commit hash 
git diff --name-only $COMMIT_HASH

for i in $(git diff --name-only "${COMMIT_HASH}") ; do
  fileList[$N]="$i"
  echo -e "\e[32mHYPERLINKS CHECK\e[0m"
  echo "$(node linkcheck.js $i)" &>> _external.txt
  echo -e "\e[32mXREFS CHECK\e[0m"
  echo "$(node xrefcheck.js $i)" &>> _internal.txt
  echo -e "\e[32mBLOCK CHECK\e[0m"
  echo "$(node blockcheck.js $i)" &>> _blocks.txt
  echo $'\n'
  (( N= $N + 1 ))
done


