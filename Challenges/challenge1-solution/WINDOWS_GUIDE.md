# CoderCo Challenge 1 - Windows Testing Guide

## 🖥️ Platform Information

You're currently on Windows, but the CoderCo Challenge 1 solution is designed for Linux VMs. Here are your options to test and deploy the solution:

## Option 1: 🐧 Deploy on Linux VM (Recommended)

### Step 1: Get a Linux VM
- **Cloud providers**: AWS EC2, Azure VM, Google Cloud, DigitalOcean
- **Local VM**: VirtualBox, VMware with Ubuntu/Debian
- **WSL2**: Windows Subsystem for Linux (see Option 3 below)

### Step 2: Transfer Files
```bash
# Method 1: Git clone (if you push to repository)
git clone https://github.com/AhmedMHCodeLab/My-CoderCo-Hub.git
cd My-CoderCo-Hub/Challenges/challenge1-solution

# Method 2: SCP from Windows
scp -r challenge1-solution/ user@your-linux-vm:/home/user/

# Method 3: Copy-paste files manually
```

### Step 3: Deploy on Linux
```bash
chmod +x deploy.sh
chmod +x test.sh
./deploy.sh
```

## Option 2: 🐳 Docker on Windows (Quick Test)

### Prerequisites
1. Install Docker Desktop for Windows
2. Ensure Docker Desktop is running

### Commands
```powershell
# Start Docker Desktop first, then run:
docker-compose up -d --build

# Check status
docker-compose ps

# View logs
docker-compose logs -f coderco-app

# Test endpoints
curl http://localhost/health
# OR open http://localhost in browser

# Stop containers
docker-compose down
```

## Option 3: 🔧 WSL2 (Linux on Windows)

### Setup WSL2
```powershell
# Run as Administrator
wsl --install -d Ubuntu
# Restart computer when prompted
```

### Use in WSL2
```bash
# Open WSL2 terminal
wsl

# Navigate to your files
cd /mnt/c/Users/ahmed/Desktop/My-CoderCo-Hub/Challenges/challenge1-solution

# Make executable and run
chmod +x deploy.sh test.sh
./deploy.sh
```

## Option 4: 🌐 Cloud Deployment (Professional)

### AWS EC2 Example
```bash
# Launch Ubuntu EC2 instance
# SSH into instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# Clone or upload solution
git clone <your-repo>
cd challenge1-solution

# Deploy
chmod +x deploy.sh
sudo ./deploy.sh
```

## 📊 Testing Endpoints

Once deployed (any option), test these endpoints:

| Endpoint | Purpose |
|----------|---------|
| `http://your-server/` | Main dashboard |
| `http://your-server/health` | Health check |
| `http://your-server/api/status` | API status |
| `http://your-server/api/metrics` | System metrics |

## 🛠️ Windows-Specific Notes

### PowerShell Equivalents
```powershell
# Instead of chmod +x
# Files should be executable by default on Windows

# Instead of ./script.sh
# Use: bash script.sh (if you have Git Bash or WSL)

# Instead of curl
# Use: Invoke-WebRequest or install curl for Windows
```

### Testing with PowerShell
```powershell
# Test if Docker solution is running
Invoke-WebRequest -Uri http://localhost/health
Invoke-WebRequest -Uri http://localhost/api/status

# Or open in browser
Start-Process "http://localhost"
```

## 🎯 Recommended Path for Challenge

1. **Best for Learning**: Use WSL2 or a Linux VM to experience the full deployment
2. **Quick Demo**: Use Docker on Windows to see the application running
3. **Production**: Deploy on a cloud Linux instance

## 📝 What Each Option Teaches

- **Linux VM**: Full DevOps experience with systemd, nginx, security
- **Docker**: Containerization and microservices architecture  
- **WSL2**: Hybrid development environment skills
- **Cloud**: Production deployment and scaling concepts

Choose the option that best fits your learning goals and available resources!

---

**The solution is complete and ready for any Linux environment! 🚀**
