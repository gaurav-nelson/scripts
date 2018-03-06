#!/bin/bash
set -ev

cat _external.txt
cat _internal.txt
cat _blocks.txt

DATA=''

if [[ -s _external.txt ]]; then 
    DATA=`cat _external.txt`
fi

COMMENT_DATA="@${USER_NAME} following hyperlinks seems dead. :construction: \n${DATA}\n :robot: I could be wrong, but I am learning fast!"

#COMMENT_DATA=`cat _external.txt _internal.txt`

curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"${COMMENT_DATA}\"}" "https://api.github.com/repos/${BASE_REPO}/issues/${PR_NUMBER}/comments"
