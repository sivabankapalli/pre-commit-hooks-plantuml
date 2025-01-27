#!/bin/bash

# Constants
SOURCE_EXTENSION=".puml"
TARGET_EXTENSION=".png"
PLANTUML_JAR_PATH="${PLANTUML_JAR_PATH:-tools/plantuml.jar}" # Supports external configuration

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Generate target file name from source file name
generate_target_file() {
  local file="$1"
  echo "${file%$SOURCE_EXTENSION}$TARGET_EXTENSION"
}

# Check if a target file is missing for a source file
is_target_missing() {
  local file="$1"
  local target_file
  target_file=$(generate_target_file "$file")
  [[ ! -f "$target_file" ]]
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
    git add "$target_file"
    log "Successfully processed: $file -> $target_file"
  else
    log "Error: Failed to generate PNG for $file. Check the syntax and try again."
    exit 1
  fi
}

# Find staged .puml files
find_staged_files() {
  git diff --cached --name-only --diff-filter=ACM | grep "$SOURCE_EXTENSION$" || true
}

# Find all .puml files missing their corresponding .png files
find_missing_png_files() {
  find . -type f -name "*$SOURCE_EXTENSION" | while read -r file; do
    if is_target_missing "$file"; then
      echo "$file"
    fi
  done
}

# Process a list of files
process_files() {
  local files="$1"
  while read -r file; do
    [[ -n "$file" ]] && process_puml_file "$file"
  done <<< "$files"
}

# Main function
main() {
  local staged_files missing_png_files all_files

  # Find staged and missing .puml files
  staged_files=$(find_staged_files)
  missing_png_files=$(find_missing_png_files)

  # Combine both lists and deduplicate
  all_files=$(echo -e "$staged_files\n$missing_png_files" | sort -u)

  # Exit if no files to process
  if [[ -z "$all_files" ]]; then
    exit 0
  fi

  # Process all files
  log "Processing .puml files..."
  process_files "$all_files"
}

# Run the main function
main
