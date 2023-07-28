#!/bin/bash

# Set the output file name
output_file="biggest_files.txt"

# Find the first 10 biggest files in the file system and write the output to the file
find / -type f -exec du -h {} + | sort -rh | head -n 10 > "$output_file"

echo "Successfully found and saved the 10 biggest files in $output_file."
