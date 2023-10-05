

#!/bin/bash



# Set the new CPU and memory values

NEW_CPU=${NEW_CPU_VALUE}

NEW_MEM=${NEW_MEM_VALUE}



# Get the current CPU and memory values

CUR_CPU=$(grep -c ^processor /proc/cpuinfo)

CUR_MEM=$(free -m | awk '/^Mem:/{print $2}')



# Calculate the new CPU and memory values

NEW_CPU_TOTAL=$(($CUR_CPU + $NEW_CPU))

NEW_MEM_TOTAL=$(($CUR_MEM + $NEW_MEM))



# Update the CPU and memory values in the worker node

sudo sed -i "s/^resources:/resources:\n  limits:\n    cpu: $NEW_CPU_TOTAL\n    memory: ${NEW_MEM_TOTAL}Mi/" /path/to/worker/node.yaml



# Restart the worker node to apply the changes

sudo systemctl restart airflow-worker