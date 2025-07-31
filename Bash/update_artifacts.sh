#!/bin/bash

ARTIFACTS_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
TMP_HTML="/tmp/fivem_artifacts.html"

# Fetch the artifacts page
echo "Fetching latest FiveM artifact list..."
if ! curl -fsSL "$ARTIFACTS_URL" -o "$TMP_HTML"; then
  echo "Failed to fetch artifact list. Please check your internet connection or try again later."
  exit 1
fi

# Extract recommended and optional builds
RECOMMENDED=$(grep -oP '(?<=LATEST RECOMMENDED \()\d+(?=\))' "$TMP_HTML" | head -n1)
RECOMMENDED_URL=$(grep -oP '(?<=href=")\./'"$RECOMMENDED"'-[^/]+/fx\.tar\.xz(?=")' "$TMP_HTML" | head -n1)

OPTIONAL=$(grep -oP '(?<=LATEST OPTIONAL \()\d+(?=\))' "$TMP_HTML" | head -n1)
OPTIONAL_URL=$(grep -oP '(?<=href=")\./'"$OPTIONAL"'-[^/]+/fx\.tar\.xz(?=")' "$TMP_HTML" | head -n1)

# Extract last 10 build numbers and URLs
mapfile -t RECENT_BUILDS < <(grep -oP 'href="\./\K\d+-[^/]+(?=/fx\.tar\.xz)' "$TMP_HTML" | cut -d- -f1 | sort -nr | uniq | head -n 10)
mapfile -t RECENT_URLS < <(grep -oP 'href="\./\K\d+-[^/]+(?=/fx\.tar\.xz)' "$TMP_HTML" | sort -nr | uniq | head -n 10)

# Show menu
echo
echo "Select a build to download:"
echo "1) Recommended Build ($RECOMMENDED)"
echo "2) Optional Build    ($OPTIONAL)"
echo "3) Choose from recent builds"
echo "4) Manually enter a build number"
echo

read -rp "Enter choice [1-4]: " CHOICE

case $CHOICE in
  1)
    BUILD=$RECOMMENDED
    URL="$ARTIFACTS_URL${RECOMMENDED_URL#./}"
    ;;
  2)
    BUILD=$OPTIONAL
    URL="$ARTIFACTS_URL${OPTIONAL_URL#./}"
    ;;
  3)
    echo
    echo "Available recent builds:"
    for i in "${!RECENT_BUILDS[@]}"; do
      echo "$((i+1))) Build ${RECENT_BUILDS[$i]}"
    done
    echo
    read -rp "Choose a build [1-${#RECENT_BUILDS[@]}]: " IDX
    IDX=$((IDX-1))
    BUILD="${RECENT_BUILDS[$IDX]}"
    MATCH=$(grep -oP "./${BUILD}-[^/]+/fx\.tar\.xz" "$TMP_HTML" | head -n1)
    URL="$ARTIFACTS_URL${MATCH#./}"
    ;;
  4)
    read -rp "Enter the build number: " BUILD
    MATCH=$(grep -oP "./${BUILD}-[^/]+/fx\.tar\.xz" "$TMP_HTML" | head -n1)
    if [ -z "$MATCH" ]; then
      echo "Build $BUILD not found on the server."
      exit 1
    fi
    URL="$ARTIFACTS_URL${MATCH#./}"
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac

echo
echo "Selected build: $BUILD"
echo "Download URL: $URL"
echo

TARGET_DIR="server$BUILD"
FILENAME="fx_$BUILD.tar.xz"

echo "Downloading FiveM server artifacts..."
if ! wget "$URL" -O "$FILENAME"; then
  echo "Download failed."
  exit 1
fi

echo "Creating directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "Extracting into $TARGET_DIR..."
if ! tar -xf "$FILENAME" -C "$TARGET_DIR"; then
  echo "Extraction failed."
  exit 1
fi

echo "Removing old 'server' link if it exists..."
rm -rf server

echo "Creating symlink: server → $TARGET_DIR"
ln -sf "$TARGET_DIR" server

echo "Cleaning up archive..."
rm -f "$FILENAME"

echo "Setup complete. 'server' now points to ./$TARGET_DIR"
