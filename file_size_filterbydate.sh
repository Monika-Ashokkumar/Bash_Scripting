#!/bin/bash

usage() {
    echo "Usage: $0 [-d <number_of_days>] [-f <from_date>] [-t <to_date>]"
    exit 1
}

while getopts ":d:f:t:" opt; do
    case $opt in
        d) number_of_days="$OPTARG";;
        f) from_date="$OPTARG";;
        t) to_date="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage;;
    esac
done

if [[ -n "$number_of_days" && ( -n "$from_date" || -n "$to_date" ) ]]; then
    echo "Error: Please provide either '-d' or '-f' and '-t', not both." >&2
    usage
fi

if [[ -z "$number_of_days" && ( -z "$from_date" || -z "$to_date" ) ]]; then
    echo "Error: Please provide either '-d' or '-f' and '-t'." >&2
    usage
fi

if [[ -n "$number_of_days" ]]; then
    # Find files created in the last 'number_of_days' days
    find . -type f -ctime "-$number_of_days" -exec du -h {} \;
else
    # Find files created between 'from_date' and 'to_date'
    from_timestamp=$(date -d "$from_date" +%s)
    to_timestamp=$(date -d "$to_date" +%s)
    
    if [[ "$from_timestamp" -ge "$to_timestamp" ]]; then
        echo "Error: 'from_date' should be earlier than 'to_date'." >&2
        usage
    fi
    
    find . -type f -newermt "$from_date" ! -newermt "$to_date" -exec du -h {} \;
fi
