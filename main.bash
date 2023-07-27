#                             Online Bash Shell.
#                 Code, Compile, Run and Debug Bash script online.
# Write your code in this editor and press "Run" button to execute it.


#!/bin/bash

# Function to calculate the average time difference in a log file
calculate_average_time_difference() {
    local log_file="$1"
    local previous_time=""
    local total_lines=0
    local total_time_diff=0

    while IFS= read -r line; do
        ((total_lines++))
        timestamp=$(echo "$line" | awk '{print $1}')  # Assuming the timestamp is the first field in each line

        if [[ -n "$previous_time" ]]; then
            time_diff=$(($(date -d "$timestamp" +%s) - $(date -d "$previous_time" +%s)))
            ((total_time_diff += time_diff))
        fi

        previous_time="$timestamp"
    done < "$log_file"

    if [ "$total_lines" -gt 1 ]; then
        echo "scale=2; $total_time_diff / ($total_lines - 1)" | bc
    else
        echo "0"
    fi
}

# Initialize variables to store the maximum average time difference and its corresponding log file
max_average_time_diff=0
max_average_time_log=""

# Specify your target directory
target_directory="/path/to/logs/"

# Iterate through each log file in the target directory and its subdirectories
find "$target_directory" -type f -name "*.log" | while read -r log_file; do
    # Calculate the average time difference in the log file
    average_time_diff=$(calculate_average_time_difference "$log_file")

    # Compare the average time difference with the current maximum
    if (( $(echo "$average_time_diff > $max_average_time_diff" | bc -l) )); then
        max_average_time_diff=$average_time_diff
        max_average_time_log="$log_file"
    fi
done

# Print the log file with the maximum average time difference
echo "Log file with the maximum average time difference:"
echo "$max_average_time_log ($max_average_time_diff seconds per entry)"

