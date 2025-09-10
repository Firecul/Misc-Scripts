#!/usr/bin/env python3
import os
import hashlib
import zlib
import argparse
from collections import defaultdict

def hash_file(path, algo="md5", chunk_size=8192):
    """Return hash string for a file."""
    if algo == "crc32":
        crc = 0
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(chunk_size), b""):
                crc = zlib.crc32(chunk, crc)
        return f"{crc & 0xFFFFFFFF:08x}"
    else:
        h = hashlib.new(algo)
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(chunk_size), b""):
                h.update(chunk)
        return h.hexdigest()

def find_duplicates(root_path, algo="md5"):
    seen = defaultdict(list)

    for dirpath, _, filenames in os.walk(root_path):
        for name in filenames:
            filepath = os.path.join(dirpath, name)
            try:
                h = hash_file(filepath, algo)
                seen[h].append(filepath)
            except (PermissionError, OSError):
                print(f"Skipping {filepath} (unreadable)")

    return {h: files for h, files in seen.items() if len(files) > 1}

def main():
    parser = argparse.ArgumentParser(description="Find duplicate files by hash.")
    parser.add_argument("path", nargs="?", help="Root directory to scan")
    parser.add_argument("--algo", choices=["md5", "sha1", "sha256", "crc32"], default="md5",
                        help="Hash algorithm (default: md5)")
    args = parser.parse_args()

    # Ask interactively if no path provided
    if not args.path:
        args.path = input("Enter the path to scan for duplicates: ").strip()

    if not os.path.isdir(args.path):
        print(f"Error: {args.path} is not a valid directory.")
        return

    duplicates = find_duplicates(args.path, args.algo)

    if not duplicates:
        print("No duplicates found.")
        return

    print(f"\nDuplicate files found (algorithm: {args.algo}):\n")
    for h, files in duplicates.items():
        short_hash = h[:10]
        print(f"Hash: {short_hash} ...")
        for f in files:
            folder = os.path.dirname(f)
            name = os.path.basename(f)
            print(f"  {name:<30} | {folder}")
        print()

if __name__ == "__main__":
    main()
