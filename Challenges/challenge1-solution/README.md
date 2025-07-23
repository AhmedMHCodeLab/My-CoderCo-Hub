# CoderCo Challenge 1 Solution: Production-Ready Python Service

## 🎯 Challenge Overview

This solution addresses the CoderCo Challenge 1: Building a production-ready Linux service setup for a Python application from scratch on a fresh Linux VM.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Internet      │    │   Nginx         │    │   Python App    │
│   Traffic       │───▶│   Reverse       │───▶│   (Gunicorn)    │
│                 │    │   Proxy         │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   Rate Limiting │    │   Systemd       │
                       │   SSL/TLS       │    │   Service       │
                       │   Security      │    │   Management    │
                       └─────────────────┘    └─────────────────┘
```

## 📁 Project Structure

```
challenge1-solution/
├── app.py                     # Main Flask application
├── requirements.txt           # Python dependencies
├── deploy.sh                  # Automated deployment script
├── Dockerfile                 # Docker container configuration
├── docker-compose.yml         # Multi-container setup
├── nginx-coderco-app.conf     # Nginx configuration for bare metal
├── nginx-docker.conf          # Nginx configuration for Docker
├── coderco-app.service        # Systemd service configuration
├── monitoring/
│   └── prometheus.yml         # Prometheus monitoring configuration
└── README.md                  # This documentation
```

## 🚀 Features

### Core Application Features
- **Health Check Endpoint**: `/health` for load balancer and monitoring
- **System Metrics API**: `/api/metrics` with CPU, memory, and disk usage
- **Status Dashboard**: Web interface showing application status
- **Echo Service**: `/api/echo` for testing and debugging
- **Comprehensive Logging**: Structured logging to files and stdout
- **Error Handling**: Custom error pages and graceful error handling

### Production-Ready Features
- **Reverse Proxy**: Nginx with rate limiting and security headers
- **Process Management**: Systemd service with auto-restart
- **Security**: Non-root user, restricted permissions, security headers
- **Monitoring**: Health checks, metrics collection, Prometheus integration
- **Log Management**: Log rotation and centralized logging
- **Container Support**: Docker and Docker Compose configurations
- **SSL/TLS Ready**: HTTPS configuration templates
- **Performance**: Gunicorn WSGI server with multiple workers

## 🛠️ Deployment Options

### Option 1: Automated Deployment (Recommended)

The `deploy.sh` script provides a one-command deployment solution:

```bash
# Make the script executable
chmod +x deploy.sh

# Run the deployment
./deploy.sh
```

**What the script does:**
1. Updates system packages
2. Installs Python 3.11 and dependencies
3. Installs and configures Nginx
4. Creates application user and directories
5. Deploys the application code
6. Sets up systemd service
7. Configures firewall rules
8. Sets up log rotation
9. Starts all services
10. Performs health checks

### Option 2: Docker Deployment

For containerized deployment:

```bash
# Build and run with Docker Compose
docker-compose up -d

# Check container status
docker-compose ps

# View logs
docker-compose logs -f coderco-app
```

### Option 3: Manual Deployment

For step-by-step manual deployment, follow the commands in `deploy.sh`.

## 📊 Monitoring and Health Checks

### Health Check Endpoints

| Endpoint | Purpose | Response Format |
|----------|---------|-----------------|
| `/health` | Load balancer health check | JSON with status |
| `/api/status` | Application status | JSON with app info |
| `/api/metrics` | System metrics | JSON with CPU/memory/disk |

### Example Health Check Response

```json
{
  "status": "healthy",
  "timestamp": "2025-01-23T10:30:00.123456",
  "uptime_seconds": 3600.45,
  "version": "1.0.0"
}
```

### System Metrics Response

```json
{
  "timestamp": "2025-01-23T10:30:00.123456",
  "cpu": {
    "percent": 15.2,
    "count": 4
  },
  "memory": {
    "total": 8589934592,
    "available": 6442450944,
    "percent": 25.0,
    "used": 2147483648
  },
  "disk": {
    "total": 107374182400,
    "used": 21474836480,
    "free": 85899345920,
    "percent": 20.0
  },
  "uptime_seconds": 3600.45
}
```

## 🔧 Service Management

### Systemd Commands

```bash
# Start the service
sudo systemctl start coderco-app

# Stop the service
sudo systemctl stop coderco-app

# Restart the service
sudo systemctl restart coderco-app

# Check service status
sudo systemctl status coderco-app

# Enable auto-start on boot
sudo systemctl enable coderco-app

# View service logs
sudo journalctl -u coderco-app -f
```

### Nginx Commands

```bash
# Test Nginx configuration
sudo nginx -t

# Reload Nginx configuration
sudo systemctl reload nginx

# Restart Nginx
sudo systemctl restart nginx

# Check Nginx status
sudo systemctl status nginx
```

## 📝 Configuration

### Environment Variables

The application supports the following environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `ENVIRONMENT` | `production` | Application environment |
| `SECRET_KEY` | Generated | Flask secret key for sessions |
| `DEBUG` | `false` | Enable debug mode |
| `HOST` | `127.0.0.1` | Host to bind to |
| `PORT` | `5000` | Port to bind to |

### Security Configuration

- **Non-root user**: Application runs as `coderco` user
- **Restricted permissions**: Limited file system access
- **Security headers**: XSS protection, content type options, etc.
- **Rate limiting**: API and general request rate limits
- **Firewall**: UFW configured for required ports only

## 📈 Performance Tuning

### Gunicorn Configuration

The application uses Gunicorn with the following optimizations:

- **4 workers**: Handles concurrent requests
- **30-second timeout**: Prevents hanging requests
- **Connection keep-alive**: Reduces connection overhead
- **Request limits**: Prevents memory leaks with worker recycling

### Nginx Configuration

- **Rate limiting**: Prevents abuse and DoS attacks
- **Gzip compression**: Reduces bandwidth usage
- **Proxy buffering**: Improves performance
- **Connection timeouts**: Prevents resource exhaustion

## 🔍 Troubleshooting

### Common Issues

1. **Service won't start**
   ```bash
   # Check service status and logs
   sudo systemctl status coderco-app
   sudo journalctl -u coderco-app -n 50
   ```

2. **Permission denied errors**
   ```bash
   # Check file ownership
   ls -la /opt/coderco-app
   sudo chown -R coderco:coderco /opt/coderco-app
   ```

3. **Nginx 502 Bad Gateway**
   ```bash
   # Check if application is running
   curl http://localhost:5000/health
   
   # Check Nginx error logs
   sudo tail -f /var/log/nginx/coderco-app.error.log
   ```

4. **High resource usage**
   ```bash
   # Monitor system resources
   htop
   
   # Check application metrics
   curl http://localhost/api/metrics
   ```

### Log Locations

- **Application logs**: `/var/log/coderco-app/service.log`
- **Error logs**: `/var/log/coderco-app/service-error.log`
- **Nginx access logs**: `/var/log/nginx/coderco-app.access.log`
- **Nginx error logs**: `/var/log/nginx/coderco-app.error.log`
- **System logs**: `sudo journalctl -u coderco-app`

## 🔒 Security Considerations

### Production Security Checklist

- [ ] Generate and set a secure `SECRET_KEY`
- [ ] Configure SSL/TLS certificates
- [ ] Set up fail2ban for intrusion prevention
- [ ] Configure log monitoring and alerting
- [ ] Regular security updates
- [ ] Backup procedures
- [ ] Database security (if applicable)
- [ ] Network security groups/iptables
- [ ] Regular security audits

### SSL/TLS Setup

To enable HTTPS in production:

1. **Obtain SSL certificates** (Let's Encrypt recommended):
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d your-domain.com
   ```

2. **Update Nginx configuration** to redirect HTTP to HTTPS

3. **Configure automatic renewal**:
   ```bash
   sudo crontab -e
   # Add: 0 12 * * * /usr/bin/certbot renew --quiet
   ```

## 📊 Monitoring Setup

### Prometheus Integration

The solution includes Prometheus monitoring configuration:

1. **Start monitoring stack**:
   ```bash
   docker-compose up -d prometheus
   ```

2. **Access Prometheus UI**: http://localhost:9090

3. **Available metrics**:
   - Application health status
   - System resource usage
   - Request rates and response times
   - Error rates

### Custom Metrics

The application exposes custom metrics at `/api/metrics`:

- CPU usage percentage
- Memory usage and availability
- Disk space usage
- Application uptime
- Request counts (via Nginx logs)

## 🚦 Testing

### Health Check Testing

```bash
# Test direct application
curl -f http://localhost:5000/health

# Test through Nginx proxy
curl -f http://localhost/health

# Test API endpoints
curl http://localhost/api/status
curl http://localhost/api/metrics

# Test echo service
curl -X POST http://localhost/api/echo \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

### Load Testing

```bash
# Install Apache Bench
sudo apt install apache2-utils

# Basic load test
ab -n 1000 -c 10 http://localhost/

# API load test
ab -n 500 -c 5 http://localhost/api/status
```

## 📚 Additional Resources

### Documentation Links

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Systemd Service Documentation](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Docker Documentation](https://docs.docker.com/)

### Best Practices

- **Logging**: Use structured logging with appropriate log levels
- **Error Handling**: Implement comprehensive error handling and monitoring
- **Security**: Follow security best practices and regular updates
- **Performance**: Monitor and optimize based on actual usage patterns
- **Backup**: Implement regular backup procedures for data and configuration
- **Documentation**: Keep documentation updated with changes

## 🎉 Conclusion

This solution provides a comprehensive, production-ready setup for a Python web application that includes:

✅ **Scalable Architecture**: Nginx + Gunicorn for handling concurrent requests  
✅ **Process Management**: Systemd for reliable service management  
✅ **Security**: Multiple layers of security controls  
✅ **Monitoring**: Health checks and metrics collection  
✅ **Automation**: One-command deployment script  
✅ **Containerization**: Docker support for modern deployments  
✅ **Documentation**: Comprehensive setup and troubleshooting guide  

The solution is ready for production use and can be easily extended with additional features like databases, caching, and advanced monitoring as needed.

---

**CoderCo Challenge 1 - Complete! 🚀**

*Built with ❤️ for the CoderCo Community*
