#!/bin/bash

# Check if the input file is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Input file provided as an argument
input_file="$1"

# Check if the file has a .adoc extension
if [[ "$input_file" =~ \.adoc$ ]]; then
  # Temporary file for storing modified content
  temp_file="$(mktemp)"

  # Use awk to process the file and put each sentence on its own line
  awk '{
    gsub("\\. ", ".\n")
    print
  }' "$input_file" > "$temp_file"

  # Replace the original file with the modified content
  mv "$temp_file" "$input_file"

  # Clean up temporary file
  rm -f "$temp_file"

  # Fun emoji 🎉
  echo "🚀 Sentences have been separated in $input_file 📜"
else
  # Skip emoji 😄
  echo "🛑 Skipping $input_file as it does not have a .adoc extension 🙃"
fi
