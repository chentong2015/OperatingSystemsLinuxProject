#!/bin/bash
#set -x
#set +H

# --- Load credentials ---
CRED_FILE=".oracle_creds"
if [ ! -f "$CRED_FILE" ]; then
  echo "Error: Credentials file '$CRED_FILE' not found."
  exit 1
fi

source "$CRED_FILE"

# --- Check required variables ---
if [ -z "$ora_user" ] || [ -z "$ora_pass" ] || [ -z "$ora_db" ] || [ -z "$ora_db_srv" ]; then
  echo "Error: Missing credentials in $CRED_FILE"
  exit 2
fi

# --- Check SQL file argument ---
if [ $# -lt 1 ]; then
  echo "Usage: $0 <sql_script.sql>"
  exit 3
fi

SQL_FILE="$1"
OUTPUT_FILE="sql_output.log"
DELETED_FILES_LOG="deleted_files.log"

if [ ! -f "$SQL_FILE" ]; then
  echo "Error: SQL file '$SQL_FILE' not found."
  exit 4
fi

# --- Check for sqlplus ---
if ! command -v sqlplus &> /dev/null; then
  echo "Error: sqlplus is not installed or not in PATH."
  exit 5
fi

# --- Run SQLPlus and save output ---
sqlplus -s "${ora_user}/${ora_pass}@//${ora_db}:1521/${ora_db_srv}" <<EOF > "$OUTPUT_FILE"
@"${SQL_FILE}"
EXIT
EOF
sqlplus_exit_code=$?

if [ $sqlplus_exit_code -ne 0 ]; then
  echo "SQLPlus failed with exit code $sqlplus_exit_code"
  exit $sqlplus_exit_code
fi
echo "SQL script executed successfully. Output saved to $OUTPUT_FILE"





# --- Create deleted files log if it doesn't exist ---
if [ ! -f "$DELETED_FILES_LOG" ]; then
  touch "$DELETED_FILES_LOG"
  echo "Created deleted files log: $DELETED_FILES_LOG"
fi

# --- Function to check if file was already deleted ---
is_already_deleted() {
  local filepath="$1"
  grep -Fxq "$filepath" "$DELETED_FILES_LOG"
}

# --- Function to add file to deleted log ---
add_to_deleted_log() {
  local filepath="$1"
  echo "$filepath" >> "$DELETED_FILES_LOG"
}



# --- Parse output and delete files ---
echo "Deleting files listed in SQL output..."

BASE_DIR=<shared-drive.location>/work/db/

while IFS= read -r file; do
  # Skip empty lines
  [[ -z "$file" ]] && continue

  # Remove Windows carriage return
  # file="${file%$'\r'}"

  # Convert filename to lowercase for case-insensitive matching
  file_lower="${file,,}"
  if [[ "$file_lower" =~ ^#?.*\.(xlsx|kz)$ ]]; then
    
    # Search for the file in BASE_DIR and all subdirectories
    found_files=$(find "$BASE_DIR" -type f -name "$file" 2>/dev/null)
    
    if [[ -z "$found_files" ]]; then
        echo "File not found in directory or subdirectories: $file"
        # Try the original location as fallback
        full_path="$BASE_DIR$file"
        if is_already_deleted "$full_path"; then
          echo "Already deleted previously: $full_path"
        else
          add_to_deleted_log "$full_path"
        fi

    else
        # Process each found file (in case of duplicates in different subdirectories)
        while IFS= read -r full_path; do
          # Check if file was already deleted in a previous run
          if is_already_deleted "$full_path"; then
            echo "Already deleted previously: $full_path"
            continue
          fi

          if [[ -f "$full_path" ]]; then
  #          rm "$full_path" && echo "Deleted: $full_path" && add_to_deleted_log "$full_path" || echo "Failed to delete: $full_path"
            echo "Deleted: $full_path"
            add_to_deleted_log "$full_path"
          else
            echo "File not found: $full_path"
            add_to_deleted_log "$full_path"
          fi

        done <<< "$found_files"
    fi

  else
    echo "Skipping non-target file: $file"
  fi
done < "$OUTPUT_FILE"

exit 0
