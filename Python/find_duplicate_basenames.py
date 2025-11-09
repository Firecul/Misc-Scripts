import os
import sys
from collections import defaultdict

def find_files_with_same_name_diff_ext(root_dir):
    """
    Recursively finds files in a directory that have the same name but different extensions.
    Returns a dict of {folder_path: {basename: [(ext, full_path, size), ...]}}.
    """
    results = defaultdict(lambda: defaultdict(list))

    for dirpath, _, filenames in os.walk(root_dir):
        seen = defaultdict(list)
        for f in filenames:
            name, ext = os.path.splitext(f)
            ext = ext.lower().lstrip(".")
            full_path = os.path.join(dirpath, f)
            try:
                size = os.path.getsize(full_path)
            except OSError:
                size = 0
            seen[name].append((ext, full_path, size))

        for name, files in seen.items():
            if len(files) > 1:
                results[dirpath][name] = files

    return results


def print_results(results):
    """Pretty-print the results grouped by folder and file name."""
    for folder in sorted(results.keys()):
        print(f"\n📂 Folder: {folder}")
        folder_data = results[folder]
        for name in sorted(folder_data.keys()):
            print(f"  🔸 {name}")
            for ext, path, size in sorted(folder_data[name], key=lambda x: x[0]):
                print(f"     └── .{ext:<5} | {size:>10,d} bytes | {path}")


def confirm(prompt: str) -> bool:
    """Prompt the user for yes/no confirmation."""
    ans = input(f"\n{prompt} [y/N]: ").strip().lower()
    return ans == "y"


def main():
    import argparse
    import subprocess

    parser = argparse.ArgumentParser(description="Find files with the same name but different extensions.")
    parser.add_argument("directory", help="Root directory to scan")
    parser.add_argument("--delete-ext", help="Delete files with this extension (optional)")
    parser.add_argument("--open", action="store_true", help="Open containing folders (optional)")

    args = parser.parse_args()

    results = find_files_with_same_name_diff_ext(args.directory)
    print_results(results)

    # If delete requested, show confirmation screen first
    if args.delete_ext:
        delete_ext = args.delete_ext.lower().lstrip(".")
        files_to_delete = []

        for folder, files in results.items():
            for name, file_list in files.items():
                for ext, path, size in file_list:
                    if ext == delete_ext:
                        files_to_delete.append((path, size))

        if not files_to_delete:
            print(f"\n✅ No files with extension '.{delete_ext}' found for deletion.")
            return

        print(f"\n🚨 The following {len(files_to_delete)} '.{delete_ext}' files would be deleted:")
        for path, size in files_to_delete:
            print(f"  🗑️  {path} ({size:,} bytes)")

        if confirm("Do you want to proceed with deletion?"):
            for path, _ in files_to_delete:
                try:
                    os.remove(path)
                    print(f"🗑️ Deleted: {path}")
                except Exception as e:
                    print(f"⚠️ Could not delete {path}: {e}")
        else:
            print("\n❌ Deletion cancelled.")

    # Optionally open folders that contain duplicates
    if args.open and results:
        for folder in results.keys():
            try:
                if os.name == "nt":
                    os.startfile(folder)
                elif os.name == "posix":
                    subprocess.run(["open" if sys.platform == "darwin" else "xdg-open", folder])
            except Exception as e:
                print(f"⚠️ Could not open folder {folder}: {e}")


if __name__ == "__main__":
    main()
