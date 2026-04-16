#!/bin/bash
# 🚀 SYNERGY-STARTUP: One-click Ignition
# Bare-Metal Persistence Layer

PROJECT_DIR="/home/crisptech/projects/synergy-ui-v1.0"
cd $PROJECT_DIR

# 1. Port Reclamation (Ghost Purge)
echo "⚡ Purging ghost processes on 8080..."
fuser -k 8080/tcp &> /dev/null
sleep 1

# 2. Redis Check & Start
if ! systemctl is-active --quiet redis-server; then
    echo "🧠 Starting Redis Server..."
    sudo systemctl start redis-server
fi

# 3. Synchronize Frontend Assets
echo "💎 Syncing Frontend (Svelte 5)..."
./sync.sh > frontend_sync.log 2>&1

# 4. Launch Backend (Flash Core)
echo "🔥 Igniting Synergy Backend..."
cd backend
nohup ./start.sh > backend.log 2>&1 &

# 5. Success Notification
if command -v notify-send &> /dev/null; then
    notify-send "Synergy UI" "Phoenix Core Ignited. Bridge active at localhost:8080" -i "dialog-information"
fi

echo -e "\n✨ SYNERGY ONLINE: http://localhost:8080"
