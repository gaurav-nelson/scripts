#!/bin/bash
set -ev

cat _external.txt
cat _internal.txt

#COMMENT_DATA=`cat _external.txt _internal.txt`

#curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST \
#-d "{\"body\": \"$COMMENT_DATA\"}" \
#"https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
