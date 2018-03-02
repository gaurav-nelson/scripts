#!/bin/bash
set -ev

touch _external.txt
touch _internal.txt

PR_URL="https://api.github.com/repos/gaurav-nelson/openshift-docs/commits/$TRAVIS_PULL_REQUEST_SHA"
PR_DATA=$(curl -s "$PR_URL")
PR_FILES=$( echo "$PR_DATA" | jq '.files' | grep 'filename' | cut -c 18- | tr -d '",')

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  for i in $PR_FILES ; do
      fileList[$N]="$i"
      echo -e "\e[32mHYPERLINKS CHECK\e[0m"
      echo "$(asciidoc-link-check $i)" &>> _external.txt
      echo -e "\e[32mXREFS CHECK\e[0m"
      echo "$(node scripts/xrefcheck.js $i)" &>> _internal.txt
      echo $'\n'
      let "N= $N + 1"
  done
fi
echo -e "\e[32mDONE!\e[0m"
