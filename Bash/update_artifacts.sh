#!/bin/bash

# Prompt for URL
read -p "Enter the URL to the .tar.xz file: " URL

# Prompt for build number
read -p "Enter the build number: " BUILD_NUMBER

# Construct target directory
TARGET_DIR="server$BUILD_NUMBER"

# Extract filename from URL
FILENAME=$(basename "$URL")

echo "Downloading $FILENAME..."
wget "$URL" -O "$FILENAME"

# Check if download was successful
if [ $? -ne 0 ]; then
  echo "Download failed."
  exit 1
fi

echo "Creating directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "Extracting $FILENAME into $TARGET_DIR..."
tar -xf "$FILENAME" -C "$TARGET_DIR"

# Check if extraction was successful
if [ $? -eq 0 ]; then
  echo "Extraction complete. Files are in ./$TARGET_DIR"
else
  echo "Extraction failed."
  exit 2
fi
