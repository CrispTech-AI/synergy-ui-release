#!/bin/bash

# 🗣️ VOICECONNECT BRIDGE SETUP
# WebSocket bridge for voice synthesis integration

echo "🔊 Setting up VoiceConnect Bridge..."

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Create VoiceConnect directory
mkdir -p /opt/voiceconnect
cd /opt/voiceconnect

# Create package.json
cat > package.json << 'EOF'
{
  "name": "voiceconnect-bridge",
  "version": "1.0.0",
  "description": "WebSocket bridge for voice synthesis",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "ws": "^8.14.0",
    "express": "^4.18.2",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

# Create WebSocket server
cat > index.js << 'EOF'
const WebSocket = require('ws');
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());

// WebSocket server on port 39603
const wss = new WebSocket.Server({ port: 39603 });

console.log('🔊 VoiceConnect Bridge running on ws://localhost:39603');

wss.on('connection', (ws) => {
    console.log('🎤 Client connected to VoiceConnect');
    
    ws.on('message', (message) => {
        try {
            const data = JSON.parse(message);
            console.log('📨 Received:', data);
            
            // Echo back for testing
            ws.send(JSON.stringify({
                type: 'echo',
                timestamp: Date.now(),
                original: data
            }));
        } catch (error) {
            console.error('❌ Error processing message:', error);
        }
    });
    
    ws.on('close', () => {
        console.log('🔌 Client disconnected from VoiceConnect');
    });
});

// HTTP health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'ok', port: 39603, timestamp: new Date().toISOString() });
});

app.listen(39604, () => {
    console.log('🌐 VoiceConnect HTTP API on http://localhost:39604');
});
EOF

# Install dependencies
npm install

# Create systemd service
sudo tee /etc/systemd/system/voiceconnect.service > /dev/null << EOF
[Unit]
Description=VoiceConnect WebSocket Bridge
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/voiceconnect
ExecStart=/usr/bin/node index.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl enable voiceconnect
sudo systemctl start voiceconnect

echo "✅ VoiceConnect Bridge installed and running!"
echo "🔊 WebSocket: ws://localhost:39603"
echo "🌐 HTTP API: http://localhost:39604/health"
echo "📋 Status: systemctl status voiceconnect"
