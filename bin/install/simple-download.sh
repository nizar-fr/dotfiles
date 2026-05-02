#!/bin/bash

# The URL provided by the user
URL="$1"

# Ensure that a URL is provided
if [ -z "$URL" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

# Fetch the HTML content, find .flac file links, and download them
wget -qO- "$URL" | \
grep -oP 'href="\K([^"]+\.flac)' | \
while read -r line; do
    # Construct the absolute URL if necessary
    if [[ "$line" == http* ]]; then
        FILE_URL="$line"
    else
        FILE_URL="$(dirname "$URL")/$line"
    fi
    
    echo "Downloading: $FILE_URL"
    wget "$FILE_URL"
done

echo "Download completed."
