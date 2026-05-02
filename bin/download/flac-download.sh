#!/bin/bash

# Define a log file where all operations will be logged
LOG_FILE="download_script.log"

# Function to log a message with a timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check if at least two arguments were provided
if [ "$#" -lt 2 ]; then
    log_message "Usage: $0 <URL> <File Format> [Folder Name]"
    exit 1
fi

# Ensure wget is installed
if ! command -v wget &> /dev/null; then
    log_message "wget could not be found, please install wget."
    exit 2
fi

# The URL of the webpage you want to scrape files from, provided as the first argument
URL="$1"

# Validate URL format (basic)
if ! [[ $URL =~ ^https?:// ]]; then
    log_message "Invalid URL format. URL should start with http:// or https://"
    exit 3
fi

# The file format to look for, provided as the second argument
FILE_FORMAT="$2"

# The directory where you want to save the downloaded files, provided as the third argument (optional)
# If not provided, use the current directory
DOWNLOAD_DIR="${3:-.}"

log_message "Starting download process for format $FILE_FORMAT from $URL"

# Create the download directory if it doesn't exist
if ! mkdir -p "$DOWNLOAD_DIR"; then
    log_message "Failed to create directory $DOWNLOAD_DIR. Please check permissions."
    exit 4
fi

log_message "Download directory is set to $DOWNLOAD_DIR"

# Fetch the webpage content
if ! PAGE_CONTENT=$(wget -qO- "$URL"); then
    log_message "Failed to fetch webpage content from $URL."
    exit 5
fi

log_message "Successfully fetched webpage content. Processing to find files..."

# Process the fetched webpage content
echo "$PAGE_CONTENT" | grep -oP "href=\"\K[^\"]+\.$FILE_FORMAT" | sed -e 's/&amp;/\&/g' -e 's/&lt;/</g' -e 's/&gt;/>/g' -e 's/&quot;/"/g' -e 's/&#39;/'"'"'/g' | while read -r line; do
    # Check if the extracted link is absolute or relative
    if [[ $line == http* ]]; then
        FILE_URL="$line"
    else
        # Construct the absolute URL (assuming the link is relative to the domain root)
        FILE_URL="${URL%/}/$line"
    fi

    # Extract the file name from the URL
    FILE_NAME=$(basename "$FILE_URL")

    # Check if the file already exists in the download directory
    if [ -f "$DOWNLOAD_DIR/$FILE_NAME" ]; then
        log_message "File already exists, skipping: $FILE_NAME"
        continue # Skip this file
    fi

    # Download the file to the specified directory
    log_message "Downloading $FILE_URL ..."
    if ! wget -P "$DOWNLOAD_DIR" "$FILE_URL"; then
        log_message "Failed to download $FILE_URL"
        # Decide to continue or not based on your preference
        continue
    fi
done

log_message "Download process completed."
