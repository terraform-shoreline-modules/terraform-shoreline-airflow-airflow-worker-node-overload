

#!/bin/bash



# Check CPU usage

cpu_usage=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')

if [[ $(echo "$cpu_usage > ${CPU_THRESHOLD}" | bc -l) -eq 1 ]]; then

    echo "CPU usage is above threshold. Current usage: $cpu_usage%"

fi



# Check memory usage

mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

if [[ $(echo "$mem_usage > ${MEMORY_THRESHOLD}" | bc -l) -eq 1 ]]; then

    echo "Memory usage is above threshold. Current usage: $mem_usage%"

fi



# Check disk space usage

disk_usage=$(df -h / | awk '{print $5}' | tail -n 1 | tr -d '%')

if [[ $disk_usage -ge ${DISK_THRESHOLD} ]]; then

    echo "Disk space usage is above threshold. Current usage: $disk_usage%"

fi