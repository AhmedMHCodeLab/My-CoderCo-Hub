#!/bin/bash

# CoderCo Production Deployment Script
# This script sets up a production-ready Python service on a fresh Linux VM

set -euo pipefail

# Configuration
APP_NAME="coderco-app"
APP_USER="coderco"
APP_DIR="/opt/coderco-app"
LOG_DIR="/var/log/coderco-app"
PYTHON_VERSION="3.11"
DOMAIN="${DOMAIN:-localhost}"
SECRET_KEY="${SECRET_KEY:-$(openssl rand -hex 32)}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root. Run as a regular user with sudo privileges."
        exit 1
    fi
}

# Update system packages
update_system() {
    log "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release
}

# Install Python and dependencies
install_python() {
    log "Installing Python $PYTHON_VERSION and dependencies..."
    sudo apt install -y python3.11 python3.11-venv python3.11-dev python3-pip
    sudo apt install -y build-essential libssl-dev libffi-dev
    
    # Install pip for Python 3.11 if not available
    if ! command -v pip3.11 &> /dev/null; then
        curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.11
    fi
}

# Install Nginx
install_nginx() {
    log "Installing and configuring Nginx..."
    sudo apt install -y nginx
    
    # Enable and start Nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    
    # Configure firewall for Nginx
    sudo ufw allow 'Nginx Full'
}

# Install Docker (optional)
install_docker() {
    log "Installing Docker..."
    
    # Remove old versions
    sudo apt remove -y docker docker-engine docker.io containerd runc || true
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    
    # Enable and start Docker
    sudo systemctl enable docker
    sudo systemctl start docker
}

# Create application user
create_app_user() {
    log "Creating application user: $APP_USER"
    
    if ! id "$APP_USER" &>/dev/null; then
        sudo useradd --system --shell /bin/bash --home-dir $APP_DIR --create-home $APP_USER
        info "Created user: $APP_USER"
    else
        info "User $APP_USER already exists"
    fi
}

# Setup application directory
setup_app_directory() {
    log "Setting up application directory: $APP_DIR"
    
    sudo mkdir -p $APP_DIR
    sudo mkdir -p $LOG_DIR
    
    # Set ownership
    sudo chown -R $APP_USER:$APP_USER $APP_DIR
    sudo chown -R $APP_USER:$APP_USER $LOG_DIR
    
    # Set permissions
    sudo chmod 755 $APP_DIR
    sudo chmod 755 $LOG_DIR
}

# Deploy application
deploy_application() {
    log "Deploying application..."
    
    # Copy application files
    sudo cp app.py $APP_DIR/
    sudo cp requirements.txt $APP_DIR/
    
    # Set ownership
    sudo chown -R $APP_USER:$APP_USER $APP_DIR
    
    # Create Python virtual environment
    sudo -u $APP_USER python3.11 -m venv $APP_DIR/venv
    
    # Install Python dependencies
    sudo -u $APP_USER $APP_DIR/venv/bin/pip install -r $APP_DIR/requirements.txt
    
    info "Application deployed successfully"
}

# Setup systemd service
setup_systemd_service() {
    log "Setting up systemd service..."
    
    # Create service file with proper SECRET_KEY
    sudo tee /etc/systemd/system/$APP_NAME.service > /dev/null <<EOF
[Unit]
Description=CoderCo Production Python Application
Documentation=https://github.com/AhmedMHCodeLab/My-CoderCo-Hub
After=network.target
Wants=network.target

[Service]
Type=exec
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
Environment="ENVIRONMENT=production"
Environment="SECRET_KEY=$SECRET_KEY"
Environment="DEBUG=false"
Environment="HOST=127.0.0.1"
Environment="PORT=5000"
ExecStart=$APP_DIR/venv/bin/gunicorn --bind 127.0.0.1:5000 --workers 4 --timeout 30 --keep-alive 2 --max-requests 1000 --max-requests-jitter 50 app:app
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=always
RestartSec=5
StartLimitInterval=60s
StartLimitBurst=3

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$APP_DIR $LOG_DIR
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true

# Resource limits
LimitNOFILE=65536
LimitNPROC=4096

# Logging
StandardOutput=append:$LOG_DIR/service.log
StandardError=append:$LOG_DIR/service-error.log

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd and enable service
    sudo systemctl daemon-reload
    sudo systemctl enable $APP_NAME
    
    info "Systemd service configured"
}

# Configure Nginx
configure_nginx() {
    log "Configuring Nginx..."
    
    # Create Nginx configuration
    sudo tee /etc/nginx/sites-available/$APP_NAME > /dev/null <<EOF
upstream coderco_backend {
    server 127.0.0.1:5000 max_fails=3 fail_timeout=30s;
}

limit_req_zone \$binary_remote_addr zone=api:10m rate=10r/s;
limit_req_zone \$binary_remote_addr zone=general:10m rate=30r/s;

server {
    listen 80;
    server_name $DOMAIN;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Logging
    access_log /var/log/nginx/$APP_NAME.access.log;
    error_log /var/log/nginx/$APP_NAME.error.log;
    
    client_max_body_size 10M;
    
    # Health check endpoint
    location /health {
        proxy_pass http://coderco_backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 5s;
        proxy_send_timeout 10s;
        proxy_read_timeout 10s;
        
        access_log off;
    }
    
    # API endpoints with rate limiting
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        
        proxy_pass http://coderco_backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }
    
    # Main application
    location / {
        limit_req zone=general burst=50 nodelay;
        
        proxy_pass http://coderco_backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }
}
EOF
    
    # Enable site
    sudo ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
    
    # Remove default site
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test Nginx configuration
    sudo nginx -t
    
    info "Nginx configured successfully"
}

# Setup firewall
setup_firewall() {
    log "Configuring firewall..."
    
    # Enable UFW
    sudo ufw --force enable
    
    # Allow SSH
    sudo ufw allow ssh
    
    # Allow HTTP and HTTPS
    sudo ufw allow 'Nginx Full'
    
    # Allow application port (for direct access if needed)
    sudo ufw allow 5000/tcp
    
    info "Firewall configured"
}

# Setup log rotation
setup_log_rotation() {
    log "Setting up log rotation..."
    
    sudo tee /etc/logrotate.d/$APP_NAME > /dev/null <<EOF
$LOG_DIR/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 $APP_USER $APP_USER
    postrotate
        systemctl reload $APP_NAME
    endscript
}
EOF
    
    info "Log rotation configured"
}

# Start services
start_services() {
    log "Starting services..."
    
    # Start application service
    sudo systemctl start $APP_NAME
    
    # Restart Nginx
    sudo systemctl restart nginx
    
    # Check service status
    sleep 5
    
    if sudo systemctl is-active --quiet $APP_NAME; then
        info "✅ Application service is running"
    else
        error "❌ Application service failed to start"
        sudo systemctl status $APP_NAME
        return 1
    fi
    
    if sudo systemctl is-active --quiet nginx; then
        info "✅ Nginx is running"
    else
        error "❌ Nginx failed to start"
        sudo systemctl status nginx
        return 1
    fi
}

# Health check
health_check() {
    log "Performing health check..."
    
    # Wait a moment for services to fully start
    sleep 10
    
    # Check direct application
    if curl -f http://localhost:5000/health &>/dev/null; then
        info "✅ Direct application health check passed"
    else
        warning "⚠️ Direct application health check failed"
    fi
    
    # Check through Nginx
    if curl -f http://localhost/health &>/dev/null; then
        info "✅ Nginx proxy health check passed"
    else
        warning "⚠️ Nginx proxy health check failed"
    fi
    
    # Show service status
    echo
    info "Service Status:"
    sudo systemctl status $APP_NAME --no-pager -l
    echo
    sudo systemctl status nginx --no-pager -l
}

# Show deployment summary
show_summary() {
    log "Deployment Summary"
    echo
    echo "🚀 CoderCo Production App has been deployed!"
    echo
    echo "📋 Service Details:"
    echo "   • Application: $APP_NAME"
    echo "   • User: $APP_USER"
    echo "   • Directory: $APP_DIR"
    echo "   • Logs: $LOG_DIR"
    echo "   • Domain: $DOMAIN"
    echo
    echo "🌐 Access URLs:"
    echo "   • Main App: http://$DOMAIN/"
    echo "   • Health Check: http://$DOMAIN/health"
    echo "   • API Status: http://$DOMAIN/api/status"
    echo "   • Metrics: http://$DOMAIN/api/metrics"
    echo
    echo "🔧 Management Commands:"
    echo "   • Start: sudo systemctl start $APP_NAME"
    echo "   • Stop: sudo systemctl stop $APP_NAME"
    echo "   • Restart: sudo systemctl restart $APP_NAME"
    echo "   • Status: sudo systemctl status $APP_NAME"
    echo "   • Logs: sudo journalctl -u $APP_NAME -f"
    echo "   • App Logs: tail -f $LOG_DIR/service.log"
    echo
    echo "🔑 Generated Secret Key: $SECRET_KEY"
    echo "   (Store this securely for production use)"
    echo
    warning "⚠️ Important Next Steps:"
    echo "   1. Update the SECRET_KEY in /etc/systemd/system/$APP_NAME.service"
    echo "   2. Configure SSL/TLS certificates for production"
    echo "   3. Set up monitoring and alerting"
    echo "   4. Configure backup procedures"
    echo "   5. Review and adjust firewall rules"
    echo
}

# Main deployment function
main() {
    log "Starting CoderCo Production Deployment"
    
    check_root
    update_system
    install_python
    install_nginx
    create_app_user
    setup_app_directory
    deploy_application
    setup_systemd_service
    configure_nginx
    setup_firewall
    setup_log_rotation
    start_services
    health_check
    show_summary
    
    log "Deployment completed successfully! 🎉"
}

# Run main function
main "$@"
