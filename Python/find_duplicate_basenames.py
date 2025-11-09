import os
import sys
import subprocess
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


def print_file_group(folder, name, file_list):
    """Pretty-print a group of duplicate-name files."""
    print(f"\n📂 Folder: {folder}")
    print(f"🔸 {name}")
    for ext, path, size in sorted(file_list, key=lambda x: x[0]):
        print(f"     └── .{ext:<5} | {size:>10,d} bytes | {path}")


def open_folder(folder):
    """Open a folder in the file explorer."""
    try:
        if os.name == "nt":
            os.startfile(folder)
        elif os.name == "posix":
            subprocess.run(["open" if sys.platform == "darwin" else "xdg-open", folder])
    except Exception as e:
        print(f"⚠️ Could not open folder {folder}: {e}")


def delete_files_by_ext(file_list, target_ext):
    """Delete files with a specific extension in the given file list."""
    for ext, path, _ in file_list:
        if ext == target_ext:
            try:
                os.remove(path)
                print(f"🗑️ Deleted: {path}")
            except Exception as e:
                print(f"⚠️ Could not delete {path}: {e}")


def interactive_mode(results):
    """Provide an interactive menu for each group of duplicate-name files."""
    for folder in sorted(results.keys()):
        for name in sorted(results[folder].keys()):
            files = results[folder][name]
            print_file_group(folder, name, files)

            # Gather available extensions for deletion menu
            exts = sorted(set(ext for ext, _, _ in files))
            ext_str = ", ".join(f".{e}" for e in exts)

            print("\nOptions:")
            print(" [O] Open this folder")
            print(" [S] Skip this group")
            for e in exts:
                print(f" [D{e.upper()}] Delete .{e} files")

            choice = input("Enter choice: ").strip().lower()

            if choice == "o":
                open_folder(folder)
            elif choice.startswith("d"):
                target_ext = choice[1:]
                if target_ext in exts:
                    confirm = input(f"Are you sure you want to delete all '.{target_ext}' files here? [y/N]: ").strip().lower()
                    if confirm == "y":
                        delete_files_by_ext(files, target_ext)
                    else:
                        print("❌ Deletion cancelled.")
                else:
                    print(f"⚠️ Unknown extension: .{target_ext}")
            else:
                print("⏩ Skipped.")


def batch_delete_mode(results, delete_ext):
    """Batch deletion with confirmation."""
    delete_ext = delete_ext.lower().lstrip(".")
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

    ans = input("\nDo you want to proceed with deletion? [y/N]: ").strip().lower()
    if ans == "y":
        for path, _ in files_to_delete:
            try:
                os.remove(path)
                print(f"🗑️ Deleted: {path}")
            except Exception as e:
                print(f"⚠️ Could not delete {path}: {e}")
    else:
        print("❌ Deletion cancelled.")


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Find files with the same name but different extensions.")
    parser.add_argument("directory", help="Root directory to scan")
    parser.add_argument("--delete-ext", help="Delete files with this extension (batch mode)")
    parser.add_argument("--interactive", action="store_true", help="Interactive review/delete mode")

    args = parser.parse_args()

    results = find_files_with_same_name_diff_ext(args.directory)

    if not results:
        print("✅ No duplicate-named files with different extensions found.")
        return

    if args.interactive:
        interactive_mode(results)
    elif args.delete_ext:
        batch_delete_mode(results, args.delete_ext)
    else:
        # Just print report
        for folder in sorted(results.keys()):
            for name in sorted(results[folder].keys()):
                print_file_group(folder, name, results[folder][name])


if __name__ == "__main__":
    main()
