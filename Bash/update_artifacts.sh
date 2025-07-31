#!/bin/bash

# Prompt for URL
read -p "Enter the URL to the .tar.xz file: " URL

# Extract build number from the URL
BUILD_NUMBER=$(echo "$URL" | grep -oP '/\K[0-9]+(?=-[^/]+/fx\.tar\.xz)')

# Check if build number was found
if [ -z "$BUILD_NUMBER" ]; then
  echo "Error: Could not extract build number from URL."
  exit 1
fi

# Define target directory
TARGET_DIR="server$BUILD_NUMBER"

# Extract filename from URL
FILENAME=$(basename "$URL")

echo "Downloading FiveM server artifacts (build $BUILD_NUMBER)..."
wget "$URL" -O "$FILENAME"

# Check if download was successful
if [ $? -ne 0 ]; then
  echo "Download failed."
  exit 1
fi

echo "Creating directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "Extracting FiveM server artifacts into $TARGET_DIR..."
tar -xf "$FILENAME" -C "$TARGET_DIR"

if [ $? -ne 0 ]; then
  echo "Extraction failed."
  exit 2
fi

# Remove existing 'server' symlink or directory
if [ -e "server" ] || [ -L "server" ]; then
  echo "Removing existing 'server' link or directory..."
  rm -rf server
fi

# Create new symbolic link
echo "Linking $TARGET_DIR to ./server"
ln -sf "$TARGET_DIR" server

# Delete the downloaded tar.xz file
echo "Cleaning up downloaded file..."
rm -f "$FILENAME"

echo "Setup complete. 'server' now points to ./$TARGET_DIR"
