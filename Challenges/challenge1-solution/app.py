#!/usr/bin/env python3
"""
Production-ready Python Flask application for CoderCo Challenge 1
"""
import os
import logging
import time
from datetime import datetime
from flask import Flask, jsonify, request, render_template_string
from werkzeug.middleware.proxy_fix import ProxyFix
import psutil

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/coderco-app/app.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1)

# Configuration
class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'dev-key-change-in-production')
    DEBUG = os.environ.get('DEBUG', 'False').lower() == 'true'
    HOST = os.environ.get('HOST', '0.0.0.0')
    PORT = int(os.environ.get('PORT', 5000))

app.config.from_object(Config)

# HTML template for basic UI
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>CoderCo Production App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { color: #333; border-bottom: 2px solid #007acc; padding-bottom: 10px; }
        .status { background: #e8f5e8; padding: 15px; border-left: 4px solid #4caf50; margin: 20px 0; }
        .metric { display: inline-block; margin: 10px 20px 10px 0; padding: 10px; background: #f9f9f9; border-radius: 4px; }
        .api-section { margin-top: 30px; }
        .endpoint { background: #f0f8ff; padding: 10px; margin: 10px 0; border-left: 3px solid #007acc; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🚀 CoderCo Production App</h1>
        
        <div class="status">
            <h3>✅ Service Status: {{ status }}</h3>
            <p><strong>Uptime:</strong> {{ uptime }}</p>
            <p><strong>Current Time:</strong> {{ current_time }}</p>
        </div>
        
        <div class="api-section">
            <h3>📊 System Metrics</h3>
            <div class="metric"><strong>CPU:</strong> {{ cpu_percent }}%</div>
            <div class="metric"><strong>Memory:</strong> {{ memory_percent }}%</div>
            <div class="metric"><strong>Disk:</strong> {{ disk_percent }}%</div>
        </div>
        
        <div class="api-section">
            <h3>🔗 Available API Endpoints</h3>
            <div class="endpoint"><strong>GET /</strong> - This dashboard</div>
            <div class="endpoint"><strong>GET /health</strong> - Health check endpoint</div>
            <div class="endpoint"><strong>GET /api/status</strong> - JSON status response</div>
            <div class="endpoint"><strong>GET /api/metrics</strong> - System metrics JSON</div>
            <div class="endpoint"><strong>POST /api/echo</strong> - Echo service for testing</div>
        </div>
    </div>
</body>
</html>
"""

# Store application start time for uptime calculation
START_TIME = time.time()

@app.route('/')
def dashboard():
    """Main dashboard showing application status and system metrics"""
    try:
        uptime_seconds = time.time() - START_TIME
        uptime = f"{int(uptime_seconds // 3600)}h {int((uptime_seconds % 3600) // 60)}m {int(uptime_seconds % 60)}s"
        
        # Get system metrics
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        return render_template_string(HTML_TEMPLATE,
            status="RUNNING",
            uptime=uptime,
            current_time=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            cpu_percent=round(cpu_percent, 1),
            memory_percent=round(memory.percent, 1),
            disk_percent=round(disk.percent, 1)
        )
    except Exception as e:
        logger.error(f"Error in dashboard: {str(e)}")
        return jsonify({"error": "Internal server error"}), 500

@app.route('/health')
def health_check():
    """Health check endpoint for load balancers and monitoring"""
    try:
        # Basic health checks
        health_status = {
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
            "uptime_seconds": round(time.time() - START_TIME, 2),
            "version": "1.0.0"
        }
        
        # Check system resources
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        if memory.percent > 90 or disk.percent > 95:
            health_status["status"] = "warning"
            health_status["warnings"] = []
            if memory.percent > 90:
                health_status["warnings"].append("High memory usage")
            if disk.percent > 95:
                health_status["warnings"].append("High disk usage")
        
        status_code = 200 if health_status["status"] == "healthy" else 503
        return jsonify(health_status), status_code
        
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return jsonify({
            "status": "unhealthy",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }), 503

@app.route('/api/status')
def api_status():
    """JSON API endpoint for application status"""
    try:
        return jsonify({
            "application": "CoderCo Production App",
            "status": "running",
            "timestamp": datetime.now().isoformat(),
            "uptime_seconds": round(time.time() - START_TIME, 2),
            "environment": os.environ.get('ENVIRONMENT', 'production'),
            "version": "1.0.0"
        })
    except Exception as e:
        logger.error(f"Error in api_status: {str(e)}")
        return jsonify({"error": "Internal server error"}), 500

@app.route('/api/metrics')
def api_metrics():
    """System metrics API endpoint"""
    try:
        # Get detailed system metrics
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        return jsonify({
            "timestamp": datetime.now().isoformat(),
            "cpu": {
                "percent": round(cpu_percent, 2),
                "count": psutil.cpu_count()
            },
            "memory": {
                "total": memory.total,
                "available": memory.available,
                "percent": round(memory.percent, 2),
                "used": memory.used
            },
            "disk": {
                "total": disk.total,
                "used": disk.used,
                "free": disk.free,
                "percent": round(disk.percent, 2)
            },
            "uptime_seconds": round(time.time() - START_TIME, 2)
        })
    except Exception as e:
        logger.error(f"Error getting metrics: {str(e)}")
        return jsonify({"error": "Failed to get metrics"}), 500

@app.route('/api/echo', methods=['POST'])
def echo_service():
    """Echo service for testing POST requests"""
    try:
        data = request.get_json() or {}
        return jsonify({
            "echo": data,
            "timestamp": datetime.now().isoformat(),
            "method": request.method,
            "headers": dict(request.headers)
        })
    except Exception as e:
        logger.error(f"Error in echo service: {str(e)}")
        return jsonify({"error": "Invalid JSON data"}), 400

@app.errorhandler(404)
def not_found(error):
    """Custom 404 handler"""
    return jsonify({"error": "Endpoint not found"}), 404

@app.errorhandler(500)
def internal_error(error):
    """Custom 500 handler"""
    logger.error(f"Internal server error: {str(error)}")
    return jsonify({"error": "Internal server error"}), 500

if __name__ == '__main__':
    # Ensure log directory exists
    os.makedirs('/var/log/coderco-app', exist_ok=True)
    
    logger.info("Starting CoderCo Production App")
    logger.info(f"Environment: {os.environ.get('ENVIRONMENT', 'production')}")
    logger.info(f"Debug mode: {app.config['DEBUG']}")
    
    app.run(
        host=app.config['HOST'],
        port=app.config['PORT'],
        debug=app.config['DEBUG']
    )
