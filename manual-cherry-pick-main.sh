#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW} Checking out main branch.${NC}"
git checkout main

echo -e "${YELLOW} Syncing main branch.${NC}"
git syncupstreammain

read -p "$(echo -e "${YELLOW}🌟 Enter the name of the branch in which you want to cherry-pick: ${NC} ")" cp_branch

echo -e "${YELLOW} Checking out ${cp_branch} branch.${NC}"
git checkout ${cp_branch}

echo -e "${YELLOW} Syncing ${cp_branch} branch.${NC}"
git syncupstreambranch

read -p "$(echo -e "${YELLOW}🌟 Enter the commit hash you want to cherry-pick: ${NC} ")" commit_hash

git cherry-pick ${commit_hash}

echo -e "${GREEN}✅ ${cp_branch} is ready for fixing conflicts!${NC}"
