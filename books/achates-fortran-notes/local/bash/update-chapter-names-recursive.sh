#!/bin/bash

# Check for correct usage
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <old-chapter-prefix> <new-chapter-prefix>"
    echo "Example: $0 ch02- ch04-"
    exit 1
fi

# Assign arguments
old_prefix="$1"
new_prefix="$2"

# Find all .tex files and update references
echo "Recursively updating references from '$old_prefix' to '$new_prefix' in all .tex files..."
find . -type f -name "*.tex" -exec sed -i '' "s/$old_prefix/$new_prefix/g" {} +

echo "Update complete!"
