# Firewall Configuration Issues - SadServers

## Problem Description
Network connectivity issues caused by incorrect firewall configuration blocking legitimate traffic.

## Common Firewall Issues and Solutions

### 1. UFW (Uncomplicated Firewall) Issues

#### Check UFW Status
```bash
# Check if UFW is active
sudo ufw status verbose

# Check UFW rules
sudo ufw status numbered
```

#### Common UFW Commands
```bash
# Enable/disable UFW
sudo ufw enable
sudo ufw disable

# Allow specific ports
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow specific services
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Delete rules
sudo ufw delete [rule_number]
sudo ufw delete allow 22/tcp
```

### 2. iptables Issues

#### Check iptables Rules
```bash
# List all rules
sudo iptables -L -n -v

# List rules with line numbers
sudo iptables -L --line-numbers

# Check NAT rules
sudo iptables -t nat -L -n -v
```

#### Common iptables Commands
```bash
# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save rules (Ubuntu/Debian)
sudo iptables-save > /etc/iptables/rules.v4
```

### 3. firewalld Issues (CentOS/RHEL)

#### Check firewalld Status
```bash
# Check service status
sudo systemctl status firewalld

# Check zones and rules
sudo firewall-cmd --list-all
sudo firewall-cmd --get-active-zones
```

#### Common firewalld Commands
```bash
# Add services
sudo firewall-cmd --add-service=ssh --permanent
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent

# Add ports
sudo firewall-cmd --add-port=8080/tcp --permanent

# Reload configuration
sudo firewall-cmd --reload
```

## Troubleshooting Steps

### 1. Identify the Problem
```bash
# Test connectivity
nc -zv target_ip target_port
telnet target_ip target_port

# Check listening ports
sudo netstat -tlnp
sudo ss -tlnp
```

### 2. Check Firewall Status
```bash
# Check which firewall is active
sudo ufw status
sudo systemctl status firewalld
sudo iptables -L

# Check if multiple firewalls are running
ps aux | grep -E "(ufw|firewall|iptables)"
```

### 3. Review Logs
```bash
# Check system logs for dropped packets
sudo dmesg | grep -i firewall
sudo journalctl -u ufw
sudo journalctl -u firewalld

# Check kernel messages
tail -f /var/log/kern.log
```

### 4. Test Rules
```bash
# Test with temporary rules
sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT

# Monitor traffic
sudo tcpdump -i any port 22
```

## Common Scenarios and Solutions

### Locked Out of SSH
```bash
# Access via console/KVM
# Add emergency SSH rule
sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT

# Or disable firewall temporarily
sudo ufw disable
sudo systemctl stop firewalld
```

### Web Server Not Accessible
```bash
# Allow HTTP/HTTPS traffic
sudo ufw allow 'Apache Full'
sudo firewall-cmd --add-service=http --add-service=https --permanent
sudo firewall-cmd --reload
```

### Database Connection Issues
```bash
# Allow database port (e.g., MySQL)
sudo ufw allow from client_ip to any port 3306
sudo iptables -A INPUT -s client_ip -p tcp --dport 3306 -j ACCEPT
```

## Best Practices

### 1. Rule Management
- Always allow SSH before enabling firewall
- Use specific source IPs when possible
- Document firewall rules
- Test rules before implementing permanently

### 2. Monitoring
- Regular firewall log review
- Monitor for dropped connections
- Set up alerts for unusual traffic patterns

### 3. Backup and Recovery
```bash
# Backup UFW rules
sudo cp -r /etc/ufw /etc/ufw.backup

# Backup iptables rules
sudo iptables-save > /backup/iptables.rules

# Backup firewalld configuration
sudo tar -czf /backup/firewalld.tar.gz /etc/firewalld/
```

### 4. Emergency Recovery
- Always have console access
- Know how to disable firewall remotely
- Keep emergency access rules ready
- Test firewall changes in maintenance windows
