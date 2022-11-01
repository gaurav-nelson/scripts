#!/bin/bash
set -ev

#set the remote to user repository
git remote add userrepo https://github.com/$REPO_NAME.git

#add branch to remote
git remote set-branches --add userrepo $PR_BRANCH

#fetch updated changes
git fetch userrepo $PR_BRANCH

#checkout branch
git checkout -b pr_branch userrepo/$PR_BRANCH