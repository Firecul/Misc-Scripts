import mariadb
import re

# Database connection parameters
DB_CONFIG = {
    "host": "localhost",      # Change if needed
    "user": "username",      # Change to your DB username
    "password": "password",  # Change to your DB password
    "database": "database"     # Database name
}

# Connect to the database
def connect_db():
    try:
        conn = mariadb.connect(**DB_CONFIG)
        return conn
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB: {e}")
        return None

# Function to update tracks
def update_tracks():
    conn = connect_db()
    if not conn:
        return

    cursor = conn.cursor()

    try:
        # Select relevant records
        cursor.execute("SELECT id, title FROM tracks WHERE creator = ?", ("IIlIlIIIlllIlIlI",))
        tracks = cursor.fetchall()

        changes = []

        for track_id, title in tracks:
            matches = re.findall(r"\[(.*?)\]", title)
            if matches:
                new_creator = matches[-1].strip()  # Use only the last set of brackets
                new_title = re.sub(r"\s*\[[^\]]*\]$", "", title).strip()  # Remove only the last set
                changes.append((track_id, title, new_title, new_creator))

        # Display proposed changes
        if changes:
            print("The following changes will be made:")
            for track_id, old_title, new_title, new_creator in changes:
                print(f"ID {track_id}: '{old_title}' -> '{new_title}', Creator: '{new_creator}'")

            confirm = input("Apply changes? (yes/no): ").strip().lower()
            if confirm == "yes":
                for track_id, _, new_title, new_creator in changes:
                    cursor.execute("UPDATE tracks SET title = ?, creator = ? WHERE id = ?", (new_title, new_creator, track_id))
                conn.commit()
                print("Changes applied successfully.")
            else:
                print("No changes were made.")
        else:
            print("No matching records found or no changes required.")

    except mariadb.Error as e:
        print(f"Error updating records: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    update_tracks()
