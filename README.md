
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Airflow Worker Node Overload.
---

Apache Airflow is a platform used for creating, scheduling, and monitoring workflows. A worker node is a component of this platform that executes tasks and runs jobs in parallel. When a worker node is overloaded, it means that it is unable to handle the number of tasks assigned to it, causing failures in the execution of workflows. This incident type refers to the situation where an Apache Airflow worker node is overloaded and needs to be addressed to ensure that the platform can continue to function properly.

### Parameters
```shell
export AIRFLOW_HOME="PLACEHOLDER"

export NEW_CPU_VALUE="PLACEHOLDER"

export NEW_MEM_VALUE="PLACEHOLDER"

export WORKER_NODE_CONFIG="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"

export DISK_THRESHOLD="PLACEHOLDER"

export MEMORY_THRESHOLD="PLACEHOLDER"
```

## Debug

### Check CPU usage of worker nodes
```shell
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"% CPU usage"}'
```

### Check memory usage of worker nodes
```shell
free -m | grep -i mem | awk '{print $3/$2 * 100.0"% memory usage"}'
```

### Check disk usage of worker nodes
```shell
df -h /
```

### Check airflow worker logs for errors
```shell
tail -f ${AIRFLOW_HOME}/logs/worker.log
```

### Check the number of running tasks on the worker nodes
```shell
ps aux | grep -i "airflow worker" | wc -l
```

### Configuration issues such as improper settings for worker node resources like CPU, memory, or disk space that do not align with the workload requirements.
```shell


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


```

## Repair

### Increase the capacity of the worker node by adding more resources such as CPU, memory, or storage.
```shell


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


```