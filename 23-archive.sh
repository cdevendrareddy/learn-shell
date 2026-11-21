#!/bin/bash

# Archive script

source_dir=$1
dest_dir=$2
days=${3:-14}  # Default to 14 days if not provided

usage() {
    echo "Usage: $0 <source_directory> <destination_directory> [days]"
    exit 1
}

if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then  # Check if source_dir or dest_dir is empty
    echo "Either source or destination directory is missing"
    usage
fi

if [ ! -d "$source_dir" ]; then  # Check if source_dir is a valid directory
    echo "Error: '$source_dir' is not a valid directory"
    usage
fi

if [ ! -d "$dest_dir" ]; then  # Check if dest_dir is a valid directory
    echo "Error: '$dest_dir' is not a valid directory"
    usage
fi

echo "Scanning files in $source_dir older than $days days to archive to $dest_dir"
files_to_archive=$(find "$source_dir" -type f -name "*.log" -mtime +$days) # Find log files older than specified days

if [ -z "$files_to_archive" ]; then  # Check if any files were found
    echo "No log files older than $days days found in $source_dir"
    exit 0
fi

timestamp=$(date +%Y%m%d%H%M%S)  # Get current timestamp
file_name="$dest_dir/logs_$timestamp.tar.gz"  # Create a unique archive file name

tar -czf $file_name $files_to_archive  # Create a tar.gz archive of the files

if [ $? -ne 0 ]; then  # Check if the tar command was successful
    echo "Error: Failed to create archive"
    exit 1
else
    echo "Archive created successfully: $file_name"
    while IFS= read -r line
    do
        echo "Deleting: $line"
        rm -f "$line"  # Delete the file after archiving
        echo "Deleted: $line"
    done <<< "$files_to_archive"
fi