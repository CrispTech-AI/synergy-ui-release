#!/bin/bash

# 🔥 BARE METAL STARTUP BUNDLE
echo "🚀 Starting CrispTech Bare Metal Stack..."

# 1. Start Core Services (Docker)
echo "📦 Starting Database and Vector DB..."
docker start postgres qdrant || docker compose -f /home/crisptech/projects/synergy-ui-v1.0/docker-compose.local.yml up -d

# 2. Start Synergy UI Backend
echo "🧠 Starting Synergy UI Backend (8080)..."
cd /home/crisptech/projects/synergy-ui-v1.0/backend
source venv/bin/activate
PYTHONPATH=. nohup uvicorn synergy_ui.main:app --host 0.0.0.0 --port 8080 > /opt/wake_root/logs/backend.log 2>&1 &

# 3. Start Synergy UI Frontend
echo "🌐 Starting Synergy UI Frontend (5173)..."
cd /home/crisptech/projects/synergy-ui-v1.0
nohup npm run dev -- --port 5173 > /opt/wake_root/logs/frontend.log 2>&1 &

# 4. Start VoiceBridge (4010)
echo "🎤 Starting VoiceBridge (4010)..."
cd /home/crisptech/projects/synergy-ui-v1.0/backend
source venv/bin/activate
PYTHONPATH=/opt/wake_root/liveconnect-core nohup uvicorn fastapi_voicebridge:app --host 0.0.0.0 --port 4010 > /opt/wake_root/logs/voicebridge.log 2>&1 &

echo "✅ All services initiated. Checking status in 5s..."
sleep 5
ss -tlnp | grep -E '5173|8080|4010|5432|6333'
