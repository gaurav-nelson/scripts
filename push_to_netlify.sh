#!/bin/bash
set -ev

BRANCH_ALREADY_EXIST=false

echo "RESETTING REMOTES"
git remote rm origin
git remote add origin https://${GH_TOKEN}@github.com/openshift-docs-preview-bot/openshift-docs.git > /dev/null 2>&1

echo "SETTING GIT USER"
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

echo "CHECKING IF BRANCH ALREADY EXIST"
if [[ $(git ls-remote --heads git@github.com:openshift-docs-preview-bot/openshift-docs.git $PR_BRANCH) ]]; then
    echo "Branch exist."
    BRANCH_ALREADY_EXIST=true
else
    echo "Branch does not exist."
fi

#set the remote to user repository
echo "SETTING REMOTE FOR $REPO_NAME:$PR_BRANCH"
git remote add userrepo https://github.com/$REPO_NAME.git

#add branch to remote
echo "SETTING REMOTE BRANCH TRACKING"
git remote set-branches --add userrepo $PR_BRANCH

#fetch updated changes
echo "FETCHNING the BRANCH $PR_BRANCH"
git fetch userrepo $PR_BRANCH

#checkout branch
echo "Checking out $PR_BRANCH"
git checkout -b preview_branch userrepo/$PR_BRANCH

echo "CHANGING NAME OF THE BRANCH"
git branch -m $PR_BRANCH

echo "PUSHING TO GITHUB"
git push origin -f $PR_BRANCH --quiet

if [ "$BRANCH_ALREADY_EXIST" = false] ; then
    echo "WAITING FOR NETLIFY BUILD"
    sleep 120

    echo "ADDING COMMENT on PR"
    COMMENT_DATA="The preview build for this PR is available at https://${PR_BRANCH}--ocpdocs.netlify.com/"
    curl -H "Authorization: token ${GH_TOKEN}" -X POST -d "{\"body\": \"${COMMENT_DATA}\"}" "https://api.github.com/repos/${BASE_REPO}/issues/${PR_NUMBER}/comments"
fi

echo "DONE!"
