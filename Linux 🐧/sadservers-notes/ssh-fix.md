# SSH Connection Issues - SadServers

## Problem Description
SSH service is not working properly, preventing remote connections to the server.

## Common SSH Issues and Solutions

### 1. SSH Service Not Running
```bash
# Check SSH service status
sudo systemctl status ssh
sudo systemctl status sshd

# Start SSH service
sudo systemctl start ssh
sudo systemctl enable ssh
```

### 2. SSH Configuration Issues
```bash
# Check SSH configuration
sudo nano /etc/ssh/sshd_config

# Common settings to verify:
Port 22
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
```

### 3. Firewall Blocking SSH
```bash
# Check if SSH port is open
sudo ufw status
sudo iptables -L

# Open SSH port
sudo ufw allow ssh
sudo ufw allow 22
```

### 4. SSH Key Issues
```bash
# Check SSH key permissions
ls -la ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Generate new SSH key pair
ssh-keygen -t rsa -b 4096
```

### 5. Network Connectivity
```bash
# Test network connectivity
ping target_server
telnet target_server 22
nc -zv target_server 22
```

## Troubleshooting Steps

1. **Check Service Status**
   - Verify SSH daemon is running
   - Check for any error messages in logs

2. **Review Configuration**
   - Validate SSH configuration syntax
   - Check for typos or invalid settings

3. **Test Connectivity**
   - Verify network path to server
   - Check if SSH port is reachable

4. **Check Logs**
   ```bash
   sudo journalctl -u ssh
   tail -f /var/log/auth.log
   ```

5. **Restart Services**
   ```bash
   sudo systemctl restart ssh
   ```

## Prevention
- Regular SSH configuration backups
- Monitor SSH service health
- Keep SSH software updated
- Use fail2ban for security
