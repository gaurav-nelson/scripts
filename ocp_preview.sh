#!/bin/bash
set -ev

# Download the preview page
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/_previewpage

# Copy preview page into the _preview folder
cp --verbose _pr_preview _preview/index.html

# Replace path name in _preview directory
find . -depth -name '(HEAD detached at FETCH_HEAD)' -execdir bash -c 'mv "$0" "${0//(HEAD detached at FETCH_HEAD)/preview}"' {} \;

# Show file paths
find _preview/ -maxdepth 3
