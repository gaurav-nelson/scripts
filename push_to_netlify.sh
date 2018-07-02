    #!/bin/bash
    set -ev

    PREVIEW_URL=https://${PR_BRANCH}--ocpdocs.netlify.com
    NEW_BRANCH=''

    echo "RESETTING REMOTES"
    git remote rm origin
    git remote add origin https://"${GH_TOKEN}"@github.com/openshift-docs-preview-bot/openshift-docs.git > /dev/null 2>&1

    echo "SETTING GIT USER"
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"

    #set the remote to user repository
    echo "SETTING REMOTE FOR $REPO_NAME:$PR_BRANCH"
    git remote add userrepo https://github.com/"$REPO_NAME".git

    #add branch to remote
    echo "SETTING REMOTE BRANCH TRACKING"
    git remote set-branches --add userrepo "$PR_BRANCH"

    #fetch updated changes
    echo "FETCHNING the BRANCH $PR_BRANCH"
    git fetch userrepo "$PR_BRANCH"

    #checkout branch
    echo "Checking out $PR_BRANCH"
    git checkout -b preview_branch userrepo/"$PR_BRANCH"

    echo "CHANGING NAME OF THE BRANCH"
    git branch -m "$PR_BRANCH"

    echo "PUSHING TO GITHUB"
    git push origin -f "$PR_BRANCH" --quiet

    echo "CHECKING IF BRANCH ALREADY EXIST"
    if curl --output /dev/null --silent --head --fail "$PREVIEW_URL"; then
    echo "Branch exists."
    NEW_BRANCH=false
    else
    echo "Branch does not exist"
    NEW_BRANCH=true
    fi

    if [[ "$NEW_BRANCH" = true ]]; then
        echo "FINDING MODIFIED FILES"
        COMMIT_HASH="$(git rev-parse @~)"
        #COMMITS_IN_PR=$(git rev-list --count HEAD ^master)
        FILES_CHANGED=( $(git diff --name-only $COMMIT_HASH) )
        #FILES_CHANGED=$(git diff --name-only HEAD HEAD~"${COMMITS_IN_PR}")
        COMMENT_DATA1='The preview of modified files will be availble at: \n'
        COMMENT_DATA2=''
        
        for i in "${FILES_CHANGED[@]}"
        do
            if [ "${i: -5}" == ".adoc" ] ; then
                FILE_NAME="${i::-4}"
                CHECK_DOCS_URL="https://docs.openshift.com/container-platform/3.9/$FILE_NAME.html"
                if curl --output /dev/null --silent --head --fail "$CHECK_DOCS_URL"; then
                    FINAL_URL="https://${PR_BRANCH}--ocpdocs.netlify.com/openshift-enterprise/(head detached at fetch_head)/$FILE_NAME.html"
                    COMMENT_DATA2="${COMMENT_DATA2}${FINAL_URL}\\n"
                fi
            fi
        done
        

        echo "ADDING COMMENT on PR"
        if [ -z "$COMMENT_DATA2" ]
            then
                COMMENT_DATA="${COMMENT_DATA1}https://${PR_BRANCH}--ocpdocs.netlify.com/"
            else
                COMMENT_DATA="${COMMENT_DATA1}${COMMENT_DATA2}"
        fi
        curl -H "Authorization: token ${GH_TOKEN}" -X POST -d "{\"body\": \"${COMMENT_DATA}\"}" "https://api.github.com/repos/${BASE_REPO}/issues/${PR_NUMBER}/comments"
    fi

    echo "DONE!"
