#!/bin/bash

# Check if directory is provided
if [ -z "$1" ]; then
  echo "Please provide directory"
  return 1
fi

# Help message
if [ "$1" == "help" ]; then
  echo "This is a WordPress installation script."
  echo "To install: vsh install wordpress <PATH> <FOLDER NAME<optional>>"
  exit 0
fi

# Download WordPress
echo "Downloading WordPress..."
if ! wget https://wordpress.org/latest.tar.gz; then
  echo "Failed to download WordPress."
  exit 1
fi

# Extract files
echo "Extracting WordPress..."
if ! sudo tar -xvzf latest.tar.gz -C "$1"; then
  echo "Failed to extract WordPress."
  exit 1
fi

# Cleanup
rm latest.tar.gz

# Change to target directory
cd "$1" || exit

# Rename folder if second argument is provided
if [ -n "$2" ]; then
sudo mv wordpress "$(basename "$2")"
fi

echo "WordPress installation completed successfully."

