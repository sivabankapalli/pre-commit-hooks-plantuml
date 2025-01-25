#!/bin/bash

# Constants
SOURCE_EXTENSION=".puml"
TARGET_EXTENSION=".svc"
PLANTUML_SERVER="http://www.plantuml.com/plantuml/svg/"

# Function to process a .puml file
process_puml_file() {
  local file="$1"
  local target_file="${file%$SOURCE_EXTENSION}$TARGET_EXTENSION"

  # Encode the .puml content for URL-safe transmission
  encoded_content=$(cat "$file" | tr -d '\n' | sed 's/ /%20/g; s/(/%28/g; s/)/%29/g')

  # Send the .puml content to the PlantUML server and fetch the .svc file
  curl -s "${PLANTUML_SERVER}${encoded_content}" -o "$target_file"

  # Check if the .svc file was generated successfully
  if [[ -f "$target_file" ]]; then
    git add "$target_file"
    echo "Processed: $file -> $target_file"
  else
    echo "Error: Failed to process $file. Check the syntax and try again."
    exit 1
  fi
}

# Find all staged .puml files
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep "$SOURCE_EXTENSION$")

if [[ -n "$staged_files" ]]; then
  echo "Processing .puml files with PlantUML..."
  for file in $staged_files; do
    process_puml_file "$file"
  done
else
  echo "No .puml files found for processing."
fi

exit 0
