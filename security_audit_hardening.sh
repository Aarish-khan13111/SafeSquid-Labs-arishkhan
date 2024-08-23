#!/bin/bash

# Function to perform User and Group Audits
user_group_audit() {
    echo "User and Group Audits:"
    echo "Listing all users and groups on the server..."
    cut -d: -f1 /etc/passwd
    echo "Users with UID 0 (root privileges):"
    awk -F: '($3 == 0) {print}' /etc/passwd
    echo "Checking for users without passwords or with weak passwords..."
    awk -F: '($2 == "" || $2 ~ /^\*$/) {print $1}' /etc/shadow
}

# Function to check File and Directory Permissions
file_permissions_audit() {
    echo "File and Directory Permissions Audit:"
    echo "Scanning for world-writable files and directories..."
    find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print
    find / -xdev -type f \( -perm -0002 \) -print
    echo "Checking for insecure .ssh directory permissions..."
    find /home -name ".ssh" -exec ls -ld {} \;
    echo "Checking for files with SUID or SGID bits set..."
    find / -perm /6000 -type f -exec ls -ld {} \;
}

# Function to perform Service Audits
service_audit() {
    echo "Service Audits:"
    echo "Listing all running services..."
    systemctl list-units --type=service --state=running
    echo "Checking for unnecessary or unauthorized services..."
    for service in `systemctl list-units --type=service --state=running | awk '{print $1}'`; do
        if ! systemctl is-enabled $service; then
            echo "$service is not enabled and may be unnecessary."
        fi
    done
}

# Function to audit Firewall and Network Security
firewall_network_audit() {
    echo "Firewall and Network Security:"
    echo "Checking if a firewall is active..."
    if systemctl is-active --quiet iptables || systemctl is-active --quiet ufw; then
        echo "Firewall is active."
    else
        echo "Firewall is not active."
    fi
    echo "Checking for open ports..."
    netstat -tuln
    echo "Checking for IP forwarding..."
    sysctl net.ipv4.ip_forward
}

# Function to check IP and Network Configuration
ip_network_config_audit() {
    echo "IP and Network Configuration Checks:"
    echo "Checking public vs private IP addresses..."
    ip -o -4 addr list | awk '{print $2, $4}'
    echo "Ensuring sensitive services are not exposed on public IPs..."
    if netstat -tuln | grep ":22 "; then
        echo "SSH is exposed on a public IP."
    fi
}

# Function to check for Security Updates and Patching
security_updates() {
    echo "Security Updates and Patching:"
    echo "Checking for available updates..."
    apt-get update
    apt-get -s upgrade | grep "^Inst"
}

# Function for Log Monitoring
log_monitoring() {
    echo "Log Monitoring:"
    echo "Checking for suspicious login attempts..."
    grep "Failed password" /var/log/auth.log
}

# Function for Server Hardening Steps
server_hardening() {
    echo "Server Hardening Steps:"
    echo "Implementing SSH key-based authentication..."
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl reload sshd

    echo "Disabling IPv6 if not required..."
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p

    echo "Securing the bootloader..."
    grub2-setpassword

    echo "Configuring firewall rules..."
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables-save > /etc/iptables/rules.v4

    echo "Configuring automatic updates..."
    apt-get install unattended-upgrades
    dpkg-reconfigure -plow unattended-upgrades
}

# Function to allow custom security checks
custom_security_checks() {
    echo "Custom Security Checks:"
    # Add your custom checks here
}

# Function to handle reporting and alerting
reporting_alerting() {
    echo "Reporting and Alerting:"
    # Implement reporting and alerting mechanisms here
}

# Main Program
main() {
    user_group_audit
    file_permissions_audit
    service_audit
    firewall_network_audit
    ip_network_config_audit
    security_updates
    log_monitoring
    server_hardening
    custom_security_checks
    reporting_alerting
}

# Execute the main function
main

