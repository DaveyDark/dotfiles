#!/bin/bash

# Check for directory argument
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/image-directory"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$INPUT_DIR/output"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Process each supported image file
shopt -s nullglob
for file in "$INPUT_DIR"/*.{jpg,jpeg,png,heic,avif}; do
  filename=$(basename "$file")
  magick "$file" -resize 1920x1080^ -gravity center -extent 1920x1080 "$OUTPUT_DIR/$filename"
  echo "Processed: $filename"
done
shopt -u nullglob

echo "All images processed and saved to: $OUTPUT_DIR"
