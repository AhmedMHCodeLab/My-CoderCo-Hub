#!/usr/bin/env python3
"""
Simplified CoderCo Challenge 1 - Production Python Service
"""
from flask import Flask, jsonify
import time
from datetime import datetime

app = Flask(__name__)

# Store start time for uptime
START_TIME = time.time()

@app.route('/')
def home():
    """Modern minimal dashboard"""
    uptime = int(time.time() - START_TIME)
    hours = uptime // 3600
    minutes = (uptime % 3600) // 60
    seconds = uptime % 60
    uptime_str = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
    
    return f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CoderCo Production Service</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            * {{
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }}
            
            body {{
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }}
            
            .container {{
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                padding: 40px;
                max-width: 600px;
                width: 100%;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }}
            
            .header {{
                text-align: center;
                margin-bottom: 40px;
            }}
            
            .logo {{
                font-size: 2.5rem;
                margin-bottom: 8px;
            }}
            
            h1 {{
                font-size: 1.8rem;
                font-weight: 600;
                color: #1a1a1a;
                margin-bottom: 8px;
            }}
            
            .subtitle {{
                color: #6b7280;
                font-size: 0.95rem;
                font-weight: 400;
            }}
            
            .status-card {{
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
                padding: 24px;
                border-radius: 16px;
                margin: 30px 0;
                text-align: center;
            }}
            
            .status-indicator {{
                font-size: 1.2rem;
                font-weight: 500;
                margin-bottom: 8px;
            }}
            
            .metrics {{
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 20px;
                margin: 30px 0;
            }}
            
            .metric {{
                background: #f8fafc;
                padding: 20px;
                border-radius: 12px;
                text-align: center;
                border: 1px solid #e2e8f0;
            }}
            
            .metric-value {{
                font-size: 1.5rem;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 4px;
            }}
            
            .metric-label {{
                font-size: 0.85rem;
                color: #64748b;
                font-weight: 500;
            }}
            
            .endpoints {{
                margin-top: 40px;
            }}
            
            .endpoints h3 {{
                font-size: 1.1rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 16px;
            }}
            
            .endpoint {{
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 16px 20px;
                background: #f8fafc;
                border-radius: 12px;
                margin-bottom: 8px;
                border: 1px solid #e2e8f0;
                transition: all 0.2s ease;
            }}
            
            .endpoint:hover {{
                background: #f1f5f9;
                border-color: #cbd5e1;
                transform: translateY(-1px);
            }}
            
            .endpoint-method {{
                background: #3b82f6;
                color: white;
                padding: 4px 8px;
                border-radius: 6px;
                font-size: 0.75rem;
                font-weight: 500;
                min-width: 45px;
                text-align: center;
            }}
            
            .endpoint-path {{
                font-family: 'Monaco', 'Menlo', monospace;
                font-weight: 500;
                color: #1e293b;
            }}
            
            .endpoint-desc {{
                color: #64748b;
                font-size: 0.9rem;
            }}
            
            .footer {{
                text-align: center;
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #e2e8f0;
                color: #9ca3af;
                font-size: 0.85rem;
            }}
            
            @media (max-width: 640px) {{
                .container {{
                    padding: 30px 20px;
                }}
                
                .metrics {{
                    grid-template-columns: 1fr;
                }}
                
                .endpoint {{
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 8px;
                }}
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo">🚀</div>
                <h1>CoderCo Production Service</h1>
                <div class="subtitle">Python Flask Application</div>
            </div>
            
            <div class="status-card">
                <div class="status-indicator">✅ Service Online</div>
                <div>All systems operational</div>
            </div>
            
            <div class="metrics">
                <div class="metric">
                    <div class="metric-value">{uptime_str}</div>
                    <div class="metric-label">Uptime</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{datetime.now().strftime('%H:%M')}</div>
                    <div class="metric-label">Current Time</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{datetime.now().strftime('%m/%d')}</div>
                    <div class="metric-label">Date</div>
                </div>
            </div>
            
            <div class="endpoints">
                <h3>API Endpoints</h3>
                <a href="/" style="text-decoration: none; color: inherit;">
                    <div class="endpoint">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div class="endpoint-method">GET</div>
                            <div class="endpoint-path">/</div>
                        </div>
                        <div class="endpoint-desc">Dashboard</div>
                    </div>
                </a>
                <a href="/health" style="text-decoration: none; color: inherit;">
                    <div class="endpoint">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div class="endpoint-method">GET</div>
                            <div class="endpoint-path">/health</div>
                        </div>
                        <div class="endpoint-desc">Health Check</div>
                    </div>
                </a>
                <a href="/api/status" style="text-decoration: none; color: inherit;">
                    <div class="endpoint">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div class="endpoint-method">GET</div>
                            <div class="endpoint-path">/api/status</div>
                        </div>
                        <div class="endpoint-desc">JSON Status</div>
                    </div>
                </a>
            </div>
            
            <div class="footer">
                Powered by Flask • CoderCo Challenge 1
            </div>
        </div>
        
        <script>
            // Auto-refresh every 30 seconds
            setTimeout(() => window.location.reload(), 30000);
        </script>
    </body>
    </html>
    """

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "uptime": int(time.time() - START_TIME)
    })

@app.route('/api/status')
def status():
    """API status endpoint"""
    return jsonify({
        "app": "CoderCo Production App",
        "status": "running",
        "uptime": int(time.time() - START_TIME),
        "timestamp": datetime.now().isoformat()
    })

if __name__ == '__main__':
    print("🚀 Starting CoderCo App...")
    app.run(host='0.0.0.0', port=5000, debug=False)
