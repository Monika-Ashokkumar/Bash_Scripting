#!/bin/bash

# Threshold values (modify as needed)
CPU_THRESHOLD=80 # Percentage
MEMORY_THRESHOLD=80 # Percentage
DISK_THRESHOLD=80 # Percentage

# Output file path
OUTPUT_FILE="output_file.txt"

# Function to check usage and send alert if needed
check_and_alert() {
  local usage_name=$1
  local usage_value=$2
  local threshold=$3

  # Convert floating-point numbers to integers for comparison using awk
  local usage_int=$(awk -v usage="$usage_value" 'BEGIN{ printf "%.0f", usage }')
  local threshold_int=$(awk -v thresh="$threshold" 'BEGIN{ printf "%.0f", thresh }')

  if (( usage_int >= threshold_int )); then
    echo "ALERT: High ${usage_name} usage - ${usage_value}%" >> "$OUTPUT_FILE"
  fi
}


# Function to collect and format usage data
collect_usage() {
  echo "Timestamp: $(date)" >> "$OUTPUT_FILE"
  echo "+------+----------------+---------------+--------------+" >> "$OUTPUT_FILE"
  echo "| CPU  | Memory (Used%) | Disk (Used%)  |" >> "$OUTPUT_FILE"
  echo "+------+----------------+---------------+--------------+" >> "$OUTPUT_FILE"

  local cpu_usage=$(top -bn 1 | awk '/%Cpu/{print 100-$8}')
  local memory_usage=$(free | awk '/Mem/{printf "%.2f", $3/$2*100}')
  local disk_usage=$(df -h --output=pcent / | awk 'NR==2{print $1}')

  echo "| $cpu_usage% | $memory_usage%  | $disk_usage  |" >> "$OUTPUT_FILE"
  echo "+------+----------------+---------------+--------------+" >> "$OUTPUT_FILE"

  check_and_alert "CPU" "$cpu_usage" "$CPU_THRESHOLD"
  check_and_alert "Memory" "$memory_usage" "$MEMORY_THRESHOLD"
  check_and_alert "Disk" "$disk_usage" "$DISK_THRESHOLD"
}

# Execute the data collection function
collect_usage

