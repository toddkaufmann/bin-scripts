#!/bin/bash

# 2024-03-15 copilot
# prompt:
# given a sequence of lines containing begin and end times, write a function in python that prints the difference in seconds between the previous end time and the next begin time.

# Lines look like this:
#     34  -14 e407e9ce510a4955b78324c111c5d0e7 Thu 2024-03-14 00:28:28 UTC—Thu 2024-03-14 00:44:19 UTC
#     35  -13 81d54fae4c494e5cb99570af58078c25 Thu 2024-03-14 00:47:25 UTC—Thu 2024-03-14 00:48:09 UTC
# ... 
# <python output>
# prompt: Now write it as a bash script
# output below

# Function to parse a time string in the format 'YYYY-MM-DD HH:MM:SS UTC'
parse_time() {
    date -u -d "$1" +%s
}

# Example input lines
lines=(
    "34  -14 e407e9ce510a4955b78324c111c5d0e7 Thu 2024-03-14 00:28:28 UTC—Thu 2024-03-14 00:44:19 UTC"
    "35  -13 81d54fae4c494e5cb99570af58078c25 Thu 2024-03-14 00:47:25 UTC—Thu 2024-03-14 00:48:09 UTC"
    "36  -12 41d9c288b11b4db789ee1d393e3b211f Thu 2024-03-14 00:49:25 UTC—Thu 2024-03-14 00:51:06 UTC"
    "37  -11 416e19f67107469e9b3111f2485bcc3a Thu 2024-03-14 00:52:33 UTC—Thu 2024-03-14 10:36:01 UTC"
)

prev_end_time=""
for line in "${lines[@]}"; do
    begin_time_str=$(echo "$line" | awk '{print $(NF-1)}')
    end_time_str=$(echo "$line" | awk -F "—" '{print $2}')
    begin_time=$(parse_time "$begin_time_str")
    end_time=$(parse_time "$end_time_str")
    
    if [ -n "$prev_end_time" ]; then
        time_difference=$((begin_time - prev_end_time))
        echo "Time difference: $time_difference seconds"
    fi
    
    prev_end_time=$end_time
done
