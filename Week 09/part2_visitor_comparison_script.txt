#!/bin/bash

# Variables for the two time ranges
morning_pattern='1995:1[01]:[0-5][0-9]'    # 10:00-11:59 (matches 10:XX and 11:XX)
evening_pattern='1995:1[678]:[0-5][0-9]'   # 16:00-18:59 (matches 16:XX, 17:XX, 18:XX)

# File path to the NASA log file
log_file="../NASA_access_log_Aug95"

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file"
    exit 1
fi

# Count unique visitors in the morning (10:00 am - 11:59 am)
echo "Counting unique visitors between 10:00 AM and 11:59 AM..."
unique_morning=$(egrep -a "$morning_pattern" "$log_file" | awk '{print $1}' | sort -u | wc -l)
# Display the list of unique visitors in the morning
echo "Unique visitors in the morning:"
egrep -a "$morning_pattern" "$log_file" | awk '{print $1}' | sort -u

# Count unique visitors in the evening (4:00 pm - 5:59 pm)
echo "Counting unique visitors between 4:00 PM and 5:59 PM..."
unique_evening=$(egrep -a "$evening_pattern" "$log_file" | awk '{print $1}' | sort -u | wc -l)
# Display the list of unique visitors in the evening
echo "Unique visitors in the evening:"
egrep -a "$evening_pattern" "$log_file" | awk '{print $1}' | sort -u

# Display results
echo "============================================"
echo "Unique visitors comparison:"
echo "Morning (10:00-11:59): $unique_morning visitors"
echo "Evening (16:00-17:59): $unique_evening visitors"
echo "============================================"

# Calculate difference and display which time period had more unique visitors
if [ "$unique_evening" -gt "$unique_morning" ]; then
    diff=$((unique_evening - unique_morning))
    echo "Evening had $diff more unique visitors than morning"
elif [ "$unique_morning" -gt "$unique_evening" ]; then
    diff=$((unique_morning - unique_evening))
    echo "Morning had $diff more unique visitors than evening"
else
    echo "Both time periods had the same number of unique visitors"
fi