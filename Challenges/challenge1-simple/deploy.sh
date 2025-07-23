#!/bin/bash
# Simple CoderCo Challenge 1 Deployment

echo "🚀 Starting Simple CoderCo Deployment"

# Update system
sudo apt update && sudo apt upgrade -y

# Install Python 3
sudo apt install -y python3 python3-pip python3-venv

# Create app directory
sudo mkdir -p /opt/coderco-simple
sudo chown $USER:$USER /opt/coderco-simple

# Copy files
cp app.py /opt/coderco-simple/
cp requirements.txt /opt/coderco-simple/

# Create virtual environment
cd /opt/coderco-simple
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create systemd service
sudo tee /etc/systemd/system/coderco-simple.service > /dev/null <<EOF
[Unit]
Description=CoderCo Simple App
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=/opt/coderco-simple
Environment=PATH=/opt/coderco-simple/venv/bin
ExecStart=/opt/coderco-simple/venv/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable coderco-simple
sudo systemctl start coderco-simple

echo "✅ Deployment complete!"
echo "🌐 Access your app at: http://localhost:5000"
echo "🔧 Check status: sudo systemctl status coderco-simple"
