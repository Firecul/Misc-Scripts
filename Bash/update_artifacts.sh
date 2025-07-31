#!/bin/bash

# --- Color codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

ARTIFACTS_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
TMP_HTML="/tmp/fivem_artifacts.html"

# --- Parse arguments ---
MODE=""
CUSTOM_BUILD=""

for arg in "$@"; do
  case $arg in
    --recommended) MODE="recommended" ;;
    --optional) MODE="optional" ;;
    --latest) MODE="latest" ;;
    --build=*) MODE="custom"; CUSTOM_BUILD="${arg#*=}" ;;
    *)
      echo -e "${RED}Unknown option:${NC} $arg"
      echo -e "${YELLOW}Valid options:${NC} --recommended, --optional, --latest, --build=12345"
      exit 1
      ;;
  esac
done

# --- Fetch artifact page ---
echo -e "${CYAN}Fetching latest FiveM artifact list...${NC}"
if ! curl -fsSL "$ARTIFACTS_URL" -o "$TMP_HTML"; then
  echo -e "${RED}Failed to fetch artifact list.${NC} Please check your internet connection or try again later."
  exit 1
fi

# --- Extract builds ---
RECOMMENDED=$(grep -oP '(?<=LATEST RECOMMENDED \()\d+(?=\))' "$TMP_HTML" | head -n1)
RECOMMENDED_URL=$(grep -oP '(?<=href=")\./'"$RECOMMENDED"'-[^/]+/fx\.tar\.xz(?=")' "$TMP_HTML" | head -n1)

OPTIONAL=$(grep -oP '(?<=LATEST OPTIONAL \()\d+(?=\))' "$TMP_HTML" | head -n1)
OPTIONAL_URL=$(grep -oP '(?<=href=")\./'"$OPTIONAL"'-[^/]+/fx\.tar\.xz(?=")' "$TMP_HTML" | head -n1)

LATEST_BUILD=$(grep -oP 'href="\./\K\d+-[^/]+(?=/fx\.tar\.xz)' "$TMP_HTML" | cut -d- -f1 | sort -nr | head -n1)
LATEST_URL=$(grep -oP "./${LATEST_BUILD}-[^/]+/fx\.tar\.xz" "$TMP_HTML" | head -n1)

# --- Determine build ---
case $MODE in
  recommended)
    BUILD=$RECOMMENDED
    URL="$ARTIFACTS_URL${RECOMMENDED_URL#./}"
    ;;
  optional)
    BUILD=$OPTIONAL
    URL="$ARTIFACTS_URL${OPTIONAL_URL#./}"
    ;;
  latest)
    BUILD=$LATEST_BUILD
    URL="$ARTIFACTS_URL${LATEST_URL#./}"
    ;;
  custom)
    BUILD=$CUSTOM_BUILD
    MATCH=$(grep -oP "./${BUILD}-[^/]+/fx\.tar\.xz" "$TMP_HTML" | head -n1)
    if [ -z "$MATCH" ]; then
      echo -e "${RED}Build $BUILD not found on the server.${NC}"
      exit 1
    fi
    URL="$ARTIFACTS_URL${MATCH#./}"
    ;;
  *)
    echo
    echo -e "${CYAN}No flag provided. Entering interactive mode.${NC}"
    echo
    echo -e "${YELLOW}Select a build to download:${NC}"
    echo "1) Recommended Build ($RECOMMENDED)"
    echo "2) Optional Build    ($OPTIONAL)"
    echo "3) Latest Listed     ($LATEST_BUILD)"
    echo "4) Manually enter a build number"
    echo
    read -rp "Enter choice [1-4]: " CHOICE
    case $CHOICE in
      1) BUILD=$RECOMMENDED; URL="$ARTIFACTS_URL${RECOMMENDED_URL#./}" ;;
      2) BUILD=$OPTIONAL; URL="$ARTIFACTS_URL${OPTIONAL_URL#./}" ;;
      3) BUILD=$LATEST_BUILD; URL="$ARTIFACTS_URL${LATEST_URL#./}" ;;
      4)
        read -rp "Enter the build number: " BUILD
        MATCH=$(grep -oP "./${BUILD}-[^/]+/fx\.tar\.xz" "$TMP_HTML" | head -n1)
        if [ -z "$MATCH" ]; then
          echo -e "${RED}Build $BUILD not found on the server.${NC}"
          exit 1
        fi
        URL="$ARTIFACTS_URL${MATCH#./}"
        ;;
      *)
        echo -e "${RED}Invalid option.${NC}"
        exit 1
        ;;
    esac
    ;;
esac

# --- Download & Setup ---
TARGET_DIR="server$BUILD"
FILENAME="fx_$BUILD.tar.xz"

echo
echo -e "${BLUE}Downloading FiveM server artifacts for build $BUILD...${NC}"
if ! wget "$URL" -O "$FILENAME"; then
  echo -e "${RED}Download failed.${NC}"
  exit 1
fi

echo -e "${BLUE}Creating directory:${NC} $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo -e "${BLUE}Extracting archive into:${NC} $TARGET_DIR"
if ! tar -xf "$FILENAME" -C "$TARGET_DIR"; then
  echo -e "${RED}Extraction failed.${NC}"
  exit 1
fi

echo -e "${BLUE}Removing old 'server' symlink or directory...${NC}"
rm -rf server

echo -e "${BLUE}Creating symlink:${NC} server → $TARGET_DIR"
ln -sf "$TARGET_DIR" server

echo -e "${BLUE}Cleaning up archive...${NC}"
rm -f "$FILENAME"

echo -e "${GREEN}Setup complete!${NC} 'server' now points to ./$TARGET_DIR"
