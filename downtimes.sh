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
    # on darwin (bsd), use gnu data
    if [ -f /usr/local/bin/gdate ]; then
	/usr/local/bin/gdate  -u -d "$1" +%s
    else
	date -u -d "$1" +%s
    fi
}

# Example input lines
lines=(
    "x -47 68d54dcfa76346949dd57e261eb0abb2 Sat 2024-03-02 19:15:12 UTC—Sun 2024-03-03 19:05:17 UTC"
    "x -46 f74d3606c6a44fd1a89c8ad16f932393 Sun 2024-03-03 19:06:53 UTC—Sun 2024-03-03 19:09:14 UTC"
    "x -45 1d49d250facb41169afa680c338f5f4a Sun 2024-03-03 19:10:25 UTC—Sun 2024-03-03 19:30:19 UTC"
    "x -44 55ace76f9ba14eb595e067ec278ce93a Sun 2024-03-03 19:31:53 UTC—Sun 2024-03-03 20:18:02 UTC"
    "34  -14 e407e9ce510a4955b78324c111c5d0e7 Thu 2024-03-14 00:28:28 UTC—Thu 2024-03-14 00:44:19 UTC"
    "35  -13 81d54fae4c494e5cb99570af58078c25 Thu 2024-03-14 00:47:25 UTC—Thu 2024-03-14 00:48:09 UTC"
    "36  -12 41d9c288b11b4db789ee1d393e3b211f Thu 2024-03-14 00:49:25 UTC—Thu 2024-03-14 00:51:06 UTC"
    "37  -11 416e19f67107469e9b3111f2485bcc3a Thu 2024-03-14 00:52:33 UTC—Thu 2024-03-14 10:36:01 UTC"
)

prev_end_time=""
for line in "${lines[@]}"; do
    begin_time_str=$(echo "$line" | awk '{print $4,$5,$6}')
    end_time_str=$(echo "$line" | awk -F "—" '{print $4,$3,$2}')
    begin_time=$(parse_time "$begin_time_str")
    end_time=$(parse_time "$end_time_str")

    echo " - begin_time_str=$begin_time_str  .. $begin_time"
    echo " - end_time_str=$end_time_str    .. $end_time"
    if [ -n "$prev_end_time" ]; then
        time_difference=$((begin_time - prev_end_time))
        echo "Time difference: $time_difference seconds"
    fi
echo    
    prev_end_time=$end_time
done
