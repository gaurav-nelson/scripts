#!/bin/bash
set -ev

# Download the preview page
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/_previewpage

# Copy preview page into the _preview folder
cp --verbose _previewpage _preview/index.html

#Download robots.txt
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/robots.txt

# Copy robots into the _preview folder
cp --verbose robots.txt _preview/robots.txt

# Show file paths
find _preview/ -maxdepth 3
