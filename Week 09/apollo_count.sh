#!/bin/bash
# This is a script to count the occurrences of each unique response code for 'apollo' requests in the NASA access log.
# The file 'NASA_access_log_Aug95' is assumed to be in the parent directory (not in the current Week 09 directory).
# To change the file location, modify the path in the grep command accordingly. For example, if the file is in the same directory as the lecture notes, use "NASA_access_log_Aug95" instead of "../NASA_access_log_Aug95" (without the "../").

# This variable stores the unique response codes for 'apollo' requests.
codes=$(grep 'apollo' ../NASA_access_log_Aug95 | awk '{print $(NF-1)}' | sort -u)

# This loop iterates over each unique response code and counts its occurrences.
for i in $codes; do
    echo "code '$i'" ; grep 'apollo' ../NASA_access_log_Aug95 | awk -v code="$i" '$(NF-1) == code {print $0}'  | wc -l ;
done