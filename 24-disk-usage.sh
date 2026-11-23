#!/bin/bash

disk_usage=$(df -hT | grep -v Filesystem)
usage_threshold=80  # Set the usage threshold to 80%
server_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)  # Get the server's local IP address

while IFS= read -r line
do
    usage=$(echo $line | awk '{print $6}' | cut -d "%" -f1) # Extract the usage percentage from the line
    partition=$(echo $line | awk '{print $7}')
    if [ "$usage" -ge "$usage_threshold" ]; then
        message+="High Disk Usage alerton $partition: $usage <br>"
         # Append the alert message for the partition exceeding the threshold
    fi
done <<< "$disk_usage"

echo -e "$message"

sh mail.sh "Devops Team" "$server_ip" "High Disk Usage Alert" "$message" "cheenepallidevendrareddy@gmail.com" "WARNING: High Disk Usage Alert"  
# Send an email alert with the disk usage message
