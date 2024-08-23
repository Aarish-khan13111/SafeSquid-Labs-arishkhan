# README

## Project Overview

This project includes two main Bash scripts designed for Linux systems. The first script is a **System Monitoring Dashboard**, and the second script is for **Automating Security Audits and Server Hardening**. Both scripts aim to provide comprehensive and customizable solutions for system administrators to monitor and secure their servers.

### Script 1: System Monitoring Dashboard

This script provides a real-time monitoring dashboard for various system resources. The dashboard can be viewed as a whole or with specific sections using command-line switches. The script is designed to refresh data every few seconds, giving live insights into system performance.

#### Features:
- **Top 10 Most Used Applications**: Displays the top 10 applications consuming the most CPU and memory.
- **Network Monitoring**: Monitors network activity, including the number of concurrent connections, packet drops, and data in/out.
- **Disk Usage**: Shows disk space usage by mounted partitions and highlights partitions using more than 80% of their capacity.
- **System Load**: Displays the current system load average and a breakdown of CPU usage.
- **Memory Usage**: Displays total, used, and free memory, along with swap memory usage.
- **Process Monitoring**: Shows the number of active processes and the top 5 processes by CPU usage.
- **Service Monitoring**: Monitors the status of essential services like `sshd`, `nginx`, `apache2`, and `iptables`.

#### Usage:
You can execute the script with specific options to display particular sections of the dashboard or view the entire dashboard.

```bash
./system_monitoring.sh [-a] [-c] [-m] [-n] [-p] [-s] [-d]
```

- `-a`: Display Top 10 Most Used Applications
- `-c`: Display CPU usage
- `-m`: Display Memory usage
- `-n`: Display Network Monitoring
- `-p`: Display Process Monitoring
- `-s`: Display Service Monitoring
- `-d`: Display Disk Usage

If no options are provided, the entire dashboard will be displayed.

### Script 2: Automating Security Audits and Server Hardening

This script automates security audits and hardens Linux servers according to best practices. The script is modular, allowing it to be reused and extended across multiple servers.

#### Features:
- **User and Group Audits**: Lists all users and groups, checks for users with UID 0 (root privileges), and identifies users without passwords or with weak passwords.
- **File and Directory Permissions**: Scans for world-writable files/directories, checks `.ssh` directory permissions, and identifies files with SUID or SGID bits.
- **Service Audits**: Lists all running services and checks for unauthorized or unnecessary services.
- **Firewall and Network Security**: Verifies firewall status, checks for open ports, and examines IP forwarding settings.
- **IP and Network Configuration Checks**: Identifies public vs. private IP addresses and ensures sensitive services are not exposed on public IPs.
- **Security Updates and Patching**: Checks for and reports available security updates.
- **Log Monitoring**: Monitors logs for suspicious login attempts.
- **Server Hardening**: Implements best practices for server hardening, including SSH key-based authentication, IPv6 disabling (if needed), GRUB bootloader securing, firewall configuration, and automatic updates.
- **Custom Security Checks**: Allows for additional custom security checks as needed.
- **Reporting and Alerting**: Provides mechanisms for reporting and alerting, customizable based on requirements.

#### Usage:
Run the script to execute all security audits and hardening steps.

```bash
./security_audit_hardening.sh
```

### Prerequisites

- Bash shell
- Administrative (root) privileges for some operations
- `ps`, `netstat`, `ifconfig`, `mpstat`, `free`, `systemctl`, `awk`, `sed`, and other standard Linux command-line utilities.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Aarish-khan13111/SafeSquid-Labs-arishkhan.git
   cd SafeSquid-Labs-arishkhan
   ```

2. Make the scripts executable:
   ```bash
   chmod +x system_monitoring.sh
   chmod +x security_audit_hardening.sh
   ```

3. Run the scripts as needed.
   ```bash
   ./system_monitoring.sh
   ./security_audit_hardening.sh
   ```
