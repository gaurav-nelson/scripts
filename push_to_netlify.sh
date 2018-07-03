#!/bin/bash
set -ev

NC='\033[0m' # No Color
#RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

PREVIEW_URL=https://${PR_BRANCH}--ocpdocs.netlify.com
NEW_BRANCH=''

echo -e "${YELLOW}==== RESETTING REMOTES ====${NC}"
git remote rm origin
git remote add origin https://"${GH_TOKEN}"@github.com/openshift-docs-preview-bot/openshift-docs.git > /dev/null 2>&1

echo -e "${YELLOW}==== SETTING GIT USER ====${NC}"
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

#set the remote to user repository
echo -e "${YELLOW}==== SETTING REMOTE FOR ${BLUE}$REPO_NAME:$PR_BRANCH ====${NC}"
git remote add userrepo https://github.com/"$REPO_NAME".git

#add branch to remote
echo "${YELLOW}==== SETTING REMOTE BRANCH TRACKING ====${NC}"
git remote set-branches --add userrepo "$PR_BRANCH"

#fetch updated changes
echo "${YELLOW}==== FETCHNING the BRANCH ${BLUE}$PR_BRANCH ====${NC}"
git fetch userrepo "$PR_BRANCH"

#checkout branch
echo "${YELLOW}==== Checking out ${BLUE}$PR_BRANCH ====${NC}"
git checkout -b preview_branch userrepo/"$PR_BRANCH"

echo "${YELLOW}==== CHANGING NAME OF THE BRANCH ====${NC}"
git branch -m "$PR_BRANCH"

echo "${YELLOW}==== PUSHING TO GITHUB ====${NC}"
git push origin -f "$PR_BRANCH" --quiet

echo "${YELLOW}==== CHECKING IF BRANCH ALREADY EXIST ====${NC}"
if curl --output /dev/null --silent --head --fail "$PREVIEW_URL"; then
    echo "${GREEN}Branch exists. No new comment on the PR."
    NEW_BRANCH=false
    else
    echo "${GREEN}Branch does not exist. Add a new comment on the PR."
    NEW_BRANCH=true
fi

if [[ "$NEW_BRANCH" = true ]]; then
    echo "${YELLOW}FINDING MODIFIED FILES${NC}"
    COMMIT_HASH="$(git rev-parse @~)"
    #COMMITS_IN_PR=$(git rev-list --count HEAD ^master)
    #FILES_CHANGED=( $(git diff --name-only $COMMIT_HASH) )
    mapfile -t FILES_CHANGED < <(git diff --name-only "$COMMIT_HASH")
    echo -e "${GREEN} CHANGED FILES: ${BLUE}"
    printf '%s\n' "${FILES_CHANGED[@]}"
    echo -e "${NC}"
    #FILES_CHANGED=$(git diff --name-only HEAD HEAD~"${COMMITS_IN_PR}")
    COMMENT_DATA1='The preview of modified files will be availble at: \n'
    COMMENT_DATA2=''

    #only list the individual urls if modified files is upto 5
    if [ ${#FILES_CHANGED[@]} -lt 6 ] ; then
        for i in "${FILES_CHANGED[@]}"
            do
                #only do this for adoc files
                if [ "${i: -5}" == ".adoc" ] ; then
                    #ignore adoc files which are modules or topics
                    if [[ ${i} != *"topic"* || ${i} != *"module"* ]] ; then
                        FILE_NAME="${i::-5}"
                        CHECK_DOCS_URL="https://docs.openshift.com/container-platform/3.9/$FILE_NAME.html"
                        if curl --output /dev/null --head --fail "$CHECK_DOCS_URL"; then
                            FINAL_URL="https://${PR_BRANCH}--ocpdocs.netlify.com/openshift-enterprise/(head detached at fetch_head)/$FILE_NAME.html"
                            COMMENT_DATA2="$i: ${COMMENT_DATA2}${FINAL_URL}\\n"
                        fi
                    fi
                fi
            done
    fi
        
    echo "${YELLOW}ADDING COMMENT on PR${NC}"
    if [ -z "$COMMENT_DATA2" ]
        then
            COMMENT_DATA="${COMMENT_DATA1}https://${PR_BRANCH}--ocpdocs.netlify.com/"
        else
            COMMENT_DATA="${COMMENT_DATA1}${COMMENT_DATA2}"
    fi
    curl -H "Authorization: token ${GH_TOKEN}" -X POST -d "{\"body\": \"${COMMENT_DATA}\"}" "https://api.github.com/repos/${BASE_REPO}/issues/${PR_NUMBER}/comments"
    #echo -e "\033[31m COMMENT DATA: $COMMENT_DATA"
fi

echo "${GREEN}DONE!${NC}"
