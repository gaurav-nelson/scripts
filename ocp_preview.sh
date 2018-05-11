#!/bin/bash
set -ev

# Download the preview page
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/_previewpage

# Copy preview page into the _preview folder
cp --verbose _previewpage _preview/index.html

# Show file paths
find _preview/ -maxdepth 3
