#!/bin/bash

# System Info + Network Stats
# Usage: ./system_info.sh [logfile]

LOG_FILE="$1"
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Check if we're on Windows/MINGW
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  # Windows-specific system stats using PowerShell and Windows commands
  uptime_info=$(powershell.exe -Command "Get-CimInstance Win32_OperatingSystem | Select-Object @{Name='Uptime'; Expression={(Get-Date) - \$_.LastBootUpTime}} | Format-Table -HideTableHeaders" 2>/dev/null | tr -d '\r' | grep -v "^$" | head -1 || echo "Unable to get uptime")
  
  # Memory info using PowerShell
  mem_info=$(powershell.exe -Command "Get-CimInstance Win32_OperatingSystem | Select-Object @{Name='MemUsed';Expression={\"{0:N1} GB used of {1:N1} GB\" -f ((\$_.TotalVisibleMemorySize - \$_.FreePhysicalMemory)/1MB), (\$_.TotalVisibleMemorySize/1MB)}} | Select-Object -ExpandProperty MemUsed" 2>/dev/null | tr -d '\r' || echo "Unable to get memory info")
  
  # Disk info - use df which works in MINGW64
  disk_info=$(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 " used)")' 2>/dev/null || echo "Unable to get disk info")
  
  # CPU load approximation using PowerShell
  cpu_load=$(powershell.exe -Command "Get-Counter '\\Processor(_Total)\\% Processor Time' -SampleInterval 1 -MaxSamples 1 | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | ForEach-Object {\"{0:N1}%\" -f \$_}" 2>/dev/null | tr -d '\r' || echo "Unable to get CPU load")
  
  # Network info using PowerShell
  net_info=$(powershell.exe -Command "Get-NetIPAddress | Where-Object {\$_.AddressFamily -eq 'IPv4' -and \$_.IPAddress -ne '127.0.0.1'} | Select-Object InterfaceAlias, IPAddress | Format-Table -HideTableHeaders" 2>/dev/null | tr -d '\r' | grep -v "^$" || echo "Unable to get network info")
  

  
else
  # Linux/Unix system stats (original code)
  uptime_info=$(uptime -p 2>/dev/null || echo "Unable to get uptime")
  mem_info=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 " used of " $2}' || echo "Unable to get memory info")
  disk_info=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 " used of " $2 " (" $5 " used)"}' || echo "Unable to get disk info")
  cpu_load=$(top -bn1 2>/dev/null | grep "load average" | awk -F'load average: ' '{print $2}' || echo "Unable to get CPU load")

  # Network stats using ip or ifconfig
  if command -v ip > /dev/null; then
    net_info=$(ip -brief address 2>/dev/null | grep -v 'lo' || echo "Unable to get network info")
  else
    net_info=$(ifconfig 2>/dev/null | grep -E '^[a-zA-Z0-9]+:' | cut -d: -f1 | xargs -I{} sh -c 'echo "{}: $(ifconfig {} | grep "inet " | awk "{print \$2}")"' || echo "Unable to get network info")
  fi
fi

# Build output
output="Timestamp:    $NOW
Uptime:       $uptime_info
Memory:       $mem_info
Disk Usage:   $disk_info
CPU Load:     $cpu_load

Network Interfaces:
$net_info
"

# Print to screen
echo "$output"

# Log to file if given
if [ -n "$LOG_FILE" ]; then
  echo "$output" >> "$LOG_FILE"
  echo "Logged system info to $LOG_FILE"
fi
