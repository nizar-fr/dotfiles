#!/bin/bash

# Check if a file name is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# The file to be processed
FILE="$1"

# Temporary file to store results
TMP_FILE=$(mktemp)

# Ensure temporary file gets deleted on script exit
trap "rm -f $TMP_FILE" EXIT

# awk script to remove the content inside `workspaces = {}`
awk '
  BEGIN { print_it = 1 }
  /workspaces = \{/ { print_it = 0 }
  /},/ { if (!print_it) { print_it = 1; next } }
  print_it { print }
' "$FILE" > "$TMP_FILE"

# Overwrite the original file with the modified content
mv "$TMP_FILE" "$FILE"

echo "Updated $FILE."
