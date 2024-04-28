#!/bin/bash

# Read the version from package.json
version=$(jq -r .version package.json)

# Check if the version is not empty
if [ -z "$version" ]; then
  echo "Error: Version not found in package.json"
  exit 1
fi

# Create a git tag with the version
git tag -a "v$version" -m "Release version $version"

# Push the tag to origin
git push origin "v$version"

echo "Tag v$version created and pushed to origin."
