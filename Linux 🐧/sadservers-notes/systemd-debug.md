# SystemD Service Debugging - SadServers

## Problem Description
SystemD services failing to start or running with issues.

## Common SystemD Issues and Solutions

### 1. Service Failed to Start
```bash
# Check service status
sudo systemctl status service_name

# View detailed logs
sudo journalctl -u service_name -f

# Check service configuration
sudo systemctl cat service_name
```

### 2. Service Unit File Issues
```bash
# Common locations for unit files
/etc/systemd/system/
/usr/lib/systemd/system/
/lib/systemd/system/

# Validate unit file syntax
sudo systemd-analyze verify service_name.service
```

### 3. Dependency Problems
```bash
# List service dependencies
sudo systemctl list-dependencies service_name

# Check what's blocking a service
sudo systemctl list-jobs
```

### 4. Permission Issues
```bash
# Check file permissions
ls -la /etc/systemd/system/service_name.service

# Correct permissions
sudo chmod 644 /etc/systemd/system/service_name.service
sudo chown root:root /etc/systemd/system/service_name.service
```

## Debugging Commands

### Service Management
```bash
# Start/stop/restart services
sudo systemctl start service_name
sudo systemctl stop service_name
sudo systemctl restart service_name

# Enable/disable services
sudo systemctl enable service_name
sudo systemctl disable service_name

# Reload systemd configuration
sudo systemctl daemon-reload
```

### Log Analysis
```bash
# View logs for specific service
sudo journalctl -u service_name

# Follow logs in real-time
sudo journalctl -u service_name -f

# View logs since last boot
sudo journalctl -u service_name -b

# View logs with priority
sudo journalctl -u service_name -p err
```

### System Analysis
```bash
# Analyze boot time
sudo systemd-analyze

# Find slow services
sudo systemd-analyze blame

# Show critical chain
sudo systemd-analyze critical-chain

# Plot boot timeline
sudo systemd-analyze plot > boot.svg
```

## Common Service File Template
```ini
[Unit]
Description=My Custom Service
After=network.target

[Service]
Type=simple
User=serviceuser
ExecStart=/path/to/executable
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## Troubleshooting Checklist

1. **Check Service Status**
   - Is the service running?
   - What's the exit code?

2. **Review Logs**
   - Any error messages?
   - Check timestamps

3. **Validate Configuration**
   - Unit file syntax correct?
   - Paths exist and accessible?

4. **Check Dependencies**
   - Are required services running?
   - Network/filesystem ready?

5. **Test Manually**
   - Can you run the command directly?
   - Any permission issues?

## Best Practices
- Always use `systemctl daemon-reload` after editing unit files
- Test services manually before enabling
- Use appropriate service types (simple, forking, etc.)
- Set proper restart policies
- Include meaningful descriptions and documentation
