#!/bin/bash

# --- Log Setup ---
LOG_FILE="fivem_setup.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S.%3N')] $*" >> "$LOG_FILE"
}

# --- Color codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Output echo wrapper respecting dry-run/quiet ---
print() {
  if [ "$DRY_RUN" = true ] || [ "$QUIET" != true ]; then
    echo -e "$@"
  fi
}

ARTIFACTS_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
TMP_HTML="/tmp/fivem_artifacts.html"

# --- Parse arguments ---
MODE=""
CUSTOM_BUILD=""
DRY_RUN=false
QUIET=false

for arg in "$@"; do
  case $arg in
    --recommended) MODE="recommended" ;;
    --optional) MODE="optional" ;;
    --latest) MODE="latest" ;;
    --build=*) MODE="custom"; CUSTOM_BUILD="${arg#*=}" ;;
    --dry-run) DRY_RUN=true ;;
    --quiet) QUIET=true ;;
    *)
      echo -e "${RED}Unknown option:${NC} $arg"
      echo -e "${YELLOW}Valid options:${NC} --recommended, --optional, --latest, --build=12345, --dry-run, --quiet"
      exit 1
      ;;
  esac
done
log "CLI mode selected: --$MODE${CUSTOM_BUILD:+=$CUSTOM_BUILD}"
if [ "$DRY_RUN" = true ]; then log "Dry run mode enabled"; fi
if [ "$QUIET" = true ]; then log "Quiet mode enabled"; fi

# --- Fetch artifact page ---
print "${CYAN}Fetching latest FiveM artifact list...${NC}"
log "Fetching artifact list from $ARTIFACTS_URL"
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
    print
    print "${CYAN}No flag provided. Entering interactive mode.${NC}"
    log "No CLI flags provided — entering interactive mode"
    print
    print "${YELLOW}Select a build to download:${NC}"
    print "1) Recommended Build ($RECOMMENDED)"
    print "2) Optional Build    ($OPTIONAL)"
    print "3) Latest Listed     ($LATEST_BUILD)"
    print "4) Manually enter a build number"
    print
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
          log "Error: Build $BUILD not found on server"
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
log "Selected build: $BUILD"
log "Resolved download URL: $URL"
TARGET_DIR="server$BUILD"
FILENAME="fx_$BUILD.tar.xz"

print
if [ "$DRY_RUN" != true ]; then
  print "${BLUE}Downloading FiveM server artifacts for build $BUILD...${NC}"
  log "Download started for $URL"
  if [ "$QUIET" = true ]; then
    if ! wget --quiet "$URL" -O "$FILENAME"; then
      echo -e "${RED}Download failed.${NC}"
      log "Error: Download failed for $URL"
      exit 1
    fi
  else
    if ! wget --show-progress "$URL" -O "$FILENAME"; then
      echo -e "${RED}Download failed.${NC}"
      log "Error: Download failed for $URL"
      exit 1
    fi
  fi
  log "Download completed: $FILENAME"
fi

if [ "$DRY_RUN" = true ]; then
  print "${YELLOW}[Dry Run] Would create directory:${NC} $TARGET_DIR"
  log "[Dry Run] Skipping directory creation for $TARGET_DIR"
else
  print "${BLUE}Creating directory:${NC} $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
fi

if [ "$DRY_RUN" = true ]; then
  print "${YELLOW}[Dry Run] Would extract archive into:${NC} $TARGET_DIR"
  log "[Dry Run] Skipping extraction of $FILENAME"
else
  print "${BLUE}Extracting archive into:${NC} $TARGET_DIR"
  if ! tar -xf "$FILENAME" -C "$TARGET_DIR"; then
    echo -e "${RED}Extraction failed.${NC}"
    log "Error: Extraction failed for $FILENAME"
    exit 1
  fi
  log "Extracted to $TARGET_DIR"
fi

if [ "$DRY_RUN" = true ]; then
  print "${YELLOW}[Dry Run] Would remove existing 'server' symlink or directory${NC}"
  print "${YELLOW}[Dry Run] Would create symlink:${NC} server → $TARGET_DIR"
  log "[Dry Run] Would replace 'server' symlink → $TARGET_DIR"
else
  print "${BLUE}Removing old 'server' symlink or directory...${NC}"
  rm -rf server
  log "Removed old 'server' link or directory"

  print "${BLUE}Creating symlink:${NC} server → $TARGET_DIR"
  ln -sf "$TARGET_DIR" server
  log "Created symlink: server → $TARGET_DIR"
fi

if [ "$DRY_RUN" = true ]; then
  print "${YELLOW}[Dry Run] Would clean up archive:${NC} $FILENAME"
  log "[Dry Run] Skipping cleanup of $FILENAME"
else
  print "${BLUE}Cleaning up archive...${NC}"
  rm -f "$FILENAME"
  log "Cleaned up archive: $FILENAME"
fi

if [ "$DRY_RUN" = true ]; then
  print "${GREEN}[Dry Run] Simulation complete.${NC} 'server' would point to ./$TARGET_DIR"
  log "[Dry Run] Simulation complete for build $BUILD"
else
  print "${GREEN}Setup complete!${NC} 'server' now points to ./$TARGET_DIR"
  log "Setup complete for build $BUILD"
fi
