#!/bin/bash

# Log cleanup script

source_dir=$1
days=${2:-14}  # Default to 14 days if not provided
usage() {
    echo "Usage: $0 <source_directory> [days]"
    echo "  <source_directory>: Directory containing log files to clean up"
    echo "  [days]: Number of days to keep logs (default: 14)"
    exit 1
}

if [ -z "$source_dir" ]; then  # Check if source_dir is empty
    echo "Error: Missing Parameters"
    usage
fi

if [ ! -d "$source_dir" ]; then  # Check if source_dir is a valid directory
    echo "Error: '$source_dir' is not a valid directory"
    usage
fi

echo "scanning files in $source_dir older than $days days"

files_to_delete=$(find "$source_dir" -type f -name "*.log" -mtime +$days) # Find log files older than specified days

if [ -z "$files_to_delete" ]; then  # Check if any files were found
    echo "No log files older than $days days found in $source_dir"
    exit 0
fi

while IFS= read -r file; do  # Loop through each file found
    echo "Deleting: $file"
    rm "$file"  # Delete the file
done <<< "$files_to_delete"