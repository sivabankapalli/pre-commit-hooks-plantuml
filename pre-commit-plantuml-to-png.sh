#!/bin/bash

# Constants
SOURCE_EXTENSION=".puml"
TARGET_EXTENSION=".png"
PLANTUML_JAR_PATH="tools/plantuml.jar"

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Generate target file name from source file name
generate_target_file() {
  local file="$1"
  echo "${file%$SOURCE_EXTENSION}$TARGET_EXTENSION"
}

# Process a single .puml file
process_puml_file() {
  local file="$1"
  local target_file
  target_file=$(generate_target_file "$file")

  log "Processing $file..."

  # Generate the PNG file using PlantUML
  java -jar "$PLANTUML_JAR_PATH" -tpng "$file"

  # Check if the PNG was successfully generated
  if [[ -f "$target_file" ]]; then
    git add "$target_file" 2>/dev/null
    if [[ $? -eq 0 ]]; then
      log "Successfully processed: $file -> $target_file"
    else
      log "Error: Failed to stage $target_file for commit."
      exit 1
    fi
  else
    log "Error: Failed to generate PNG for $file. Check the syntax and try again."
    exit 1
  fi
}

# Main function
main() {
  # Identify staged .puml files
  staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep "$SOURCE_EXTENSION$" || true)

  # Find all .puml files missing corresponding .png files
  missing_png_files=$(find . -type f -name "*$SOURCE_EXTENSION" ! -exec sh -c '
    for file; do
      target_file="${file%'"$SOURCE_EXTENSION"'}'"$TARGET_EXTENSION"'"
      if [[ ! -f "$target_file" ]]; then
        echo "$file"
      fi
    done
  ' sh {} +)

  # Combine staged files and missing PNG files into a single list
  all_files=$(echo -e "$staged_files\n$missing_png_files" | sort -u)

  # Exit if no files to process
  if [[ -z "$all_files" ]]; then
    exit 0
  fi

  # Process all identified .puml files
  log "Processing .puml files..."
  while read -r file; do
    [[ -n "$file" ]] && process_puml_file "$file"
  done <<< "$all_files"
}

# Run the main function
main
