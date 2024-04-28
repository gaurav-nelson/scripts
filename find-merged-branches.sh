#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Get the name of the currently checked out branch
current_branch=$(git symbolic-ref --short HEAD)

# Prompt the user to input the name of the master branch
read -p "$(echo -e "${YELLOW}🌟 Enter the name of the master branch [${current_branch}]:${NC} ")" master_branch

# Use the currently checked out branch as the master branch if the user presses Enter
if [ -z "$master_branch" ]; then
    master_branch=$current_branch
fi

# Check if the master branch is different from the current branch and checkout it if necessary
if [ "$master_branch" != "$current_branch" ]; then
    git checkout $master_branch
fi

# Get all the local branches that have been merged into the current branch
merged_branches=$(git branch --merged | grep -v "\*" | grep -v "$master_branch")

# Count the number of merged branches
merged_branch_count=$(echo "$merged_branches" | grep -c '[^[:space:]]')

if [ "$merged_branch_count" -eq 0 ]; then
    # No merged branches found
    echo -e "${YELLOW}🚫 No merged branches found.${NC}"
    exit 0
else
    # Merged branches found
    # List the merged branches and their count
    echo -e "${GREEN}🎉 The following $merged_branch_count merged branches will be deleted:${NC}"
    echo -e "${RED}$merged_branches${NC}"
fi

# Loop through the merged branches
for branch in $merged_branches; do
    # Prompt the user to delete the branch
    while true; do
        read -p "$(echo -e "${YELLOW}❓ Do you want to delete branch ${NC}${RED}$branch${NC}${YELLOW}? (y/n)${NC} ")" delete_branch
        if [ "$delete_branch" == "y" ]; then
            git branch -d $branch
            echo -e "${GREEN}✅ Branch $branch deleted.${NC}"
            break
        elif [ "$delete_branch" == "n" ]; then
            break
        else
            echo -e "${RED}🚫 Please enter y for yes and n for no.${NC}"
        fi
    done
done
