#!/bin/bash
set -ev

COMMIT_HASH="$(git rev-parse @~)" #get the previous commit hash 
git diff --name-only "$COMMIT_HASH"

for i in $(git diff --name-only "${COMMIT_HASH}") ; do
  fileList[$N]="$i"
  if [ "${i: -5}" == ".adoc" ] ; then
    echo -e "CHECKING REFERENCES for ${i}"
    node checkrefs.js "${i}" >> references.txt
    echo $'\n'
    (( N= $N + 1 ))
  fi
done

#COMMENT_DATA1="Please verify following reference errors: \\n"

#if [ -f references.txt ]; then
#  cat references.txt
#  COMMENT_DATA2=$(cat references.txt)
#  COMMENT_DATA="${COMMENT_DATA1}${COMMENT_DATA2}"
#  echo -e "-----------------COMMENT DATA-----------------"
#  echo $COMMENT_DATA
  #curl -H "Authorization: token ${GH_LINKCHECK_TOKEN}" -X POST -d "{\"body\": \"${COMMENT_DATA}\"}" "https://api.github.com/repos/${BASE_REPO}/issues/${PR_NUMBER}/comments"
#fi
