#!/bin/bash

# Function to display the top 10 most used applications

top_apps() {
    echo "Top 10 Most Used Applications:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 11
}


# Function to monitor network activity
network_monitoring() {
    echo "Network Monitoring:"
    echo "Number of concurrent connections:"
    netstat -an | grep ESTABLISHED | wc -l
    echo "Packet drops:"
    netstat -s | grep -i 'packet receive errors'
    echo "Number of MB in and out:"
    ifconfig | grep -E 'RX bytes|TX bytes'
}



# Function to display disk usage
disk_usage() {
    echo "Disk Usage:"
    df -h | awk 'NR==1; NR>1 {print $0 | "sort -k5 -n -r"}'
    echo "Partitions using more than 80% of the space:"
    df -h | awk '$5 > 80 {print $0}'
}



# Function to show system load
system_load() {
    echo "System Load:"
    uptime
    echo "CPU Breakdown:"
    mpstat | awk '/all/ {print "User: "$3"% System: "$5"% Idle: "$12"%"}'
}



# Function to display memory usage
memory_usage() {
    echo "Memory Usage:"
    free -h
    echo "Swap Memory Usage:"
    swapon --show
}


# Function to monitor processes
process_monitoring() {
    echo "Process Monitoring:"
    echo "Number of active processes:"
    ps aux | wc -l
    echo "Top 5 processes in terms of CPU usage:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}


# Function to monitor services
service_monitoring() {
    echo "Service Monitoring:"
    for service in sshd nginx apache2 iptables; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
}


# Main program to handle command-line switches
while getopts "acmnpsd" opt; do
    case $opt in
        a) top_apps ;;
        c) cpu_usage ;;
        m) memory_usage ;;
        n) network_monitoring ;;
        p) process_monitoring ;;
        s) service_monitoring ;;
        d) disk_usage ;;
        *) echo "Usage: $0 [-a] [-c] [-m] [-n] [-p] [-s] [-d]"
           exit 1 ;;
    esac
done

# If no option is provided, display the full dashboard
if [ $OPTIND -eq 1 ]; then
    top_apps
    network_monitoring
    disk_usage
    system_load
    memory_usage
    process_monitoring
    service_monitoring
fi

