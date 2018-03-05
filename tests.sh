#!/bin/bash
set -ev

touch _external.txt
touch _internal.txt

COMMIT_HASH="$(git rev-parse @~)" #get the previous commit hash 

for i in $(git diff --name-only "${COMMIT_HASH}") ; do
  fileList[$N]="$i"
  echo -e "\e[32mHYPERLINKS CHECK\e[0m"
  echo "$(node linkcheck.js $i)" &>> _external.txt
  echo -e "\e[32mXREFS CHECK\e[0m"
  echo "$(node xrefcheck.js $i)" &>> _internal.txt
  echo $'\n'
  let "N= $N + 1"
done


