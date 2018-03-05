#!/bin/bash
set -ev

#set the upstream project
git remote add upstream git@github.com:openshift/openshift-docs.git

#download the pull request data
git fetch upstream pull/$PR_NUMBER/head:PR_$PR_NUMBER

#switch to the PR branch
git checkout PR_$PR_NUMBER