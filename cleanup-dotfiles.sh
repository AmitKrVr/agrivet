#!/bin/bash

# Script to remove all ._* files and folders from the project
# These are AppleDouble files created by macOS on external drives

PROJECT_DIR="/Volumes/Amit SSD/Bloom IT Solutions/Agrivet"

echo "Cleaning up ._* files and folders..."
echo "Project directory: $PROJECT_DIR"
echo ""

# Count files before cleanup
BEFORE_COUNT=$(find "$PROJECT_DIR" -name "._*" -type f 2>/dev/null | wc -l | tr -d ' ')
BEFORE_DIRS=$(find "$PROJECT_DIR" -name "._*" -type d 2>/dev/null | wc -l | tr -d ' ')

echo "Found $BEFORE_COUNT ._* files and $BEFORE_DIRS ._* directories"
echo ""

if [ "$BEFORE_COUNT" -eq 0 ] && [ "$BEFORE_DIRS" -eq 0 ]; then
    echo "No ._* files or directories found. Nothing to clean."
    exit 0
fi

# Remove all ._* files
echo "Removing ._* files..."
find "$PROJECT_DIR" -name "._*" -type f -delete 2>/dev/null

# Remove all ._* directories
echo "Removing ._* directories..."
find "$PROJECT_DIR" -name "._*" -type d -exec rm -rf {} + 2>/dev/null

# Count files after cleanup
AFTER_COUNT=$(find "$PROJECT_DIR" -name "._*" -type f 2>/dev/null | wc -l | tr -d ' ')
AFTER_DIRS=$(find "$PROJECT_DIR" -name "._*" -type d 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "Cleanup complete!"
echo "Removed: $((BEFORE_COUNT - AFTER_COUNT)) files and $((BEFORE_DIRS - AFTER_DIRS)) directories"
echo "Remaining: $AFTER_COUNT files and $AFTER_DIRS directories"
