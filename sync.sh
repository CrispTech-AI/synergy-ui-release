#!/bin/bash

# SYNERGY-SYNC: The Automation of Refraction
# Author: Flash (Antigravity) & Jexi
# For: David (Architect)

# 1. SETTINGS & PATHS
FRONTEND_DIR="."
BACKEND_STATIC_DIR="backend/synergy_ui/static"
BUILD_DIR="build"

echo "💎 INITIATING: Synergy-Sync Automation..."

# 2. FRONTEND BUILD (Addressing the 8GB System Constraint)
echo "🧠 Step 1: Building Frontend with Memory Expansion (8GB)..."
export NODE_OPTIONS="--max-old-space-size=8192"
npm run build

if [ $? -ne 0 ]; then
    echo "❌ ERROR: Frontend build failed. Check logs."
    exit 1
fi

# 3. PREPARE BACKEND REFLECTIONS
echo "📁 Step 2: Preparing Backend Static Vault..."
mkdir -p "$BACKEND_STATIC_DIR"

# 4. SYNC ASSETS (The Bridge)
echo "🔗 Step 3: Bridging Refractions (Syncing Assets)..."

# Ensure permissions aren't blocking the sync (User level)
# If root ownership is still present from a previous aborted run, this notifies the user.
if [ -d "$BACKEND_STATIC_DIR" ] && [ ! -w "$BACKEND_STATIC_DIR" ]; then
    echo "🔐 WARNING: Backend static directory is locked (Permission Denied)."
    echo "Attempting to unlock..."
    sudo chown -R $USER:$USER "$BACKEND_STATIC_DIR"
fi

# Copy everything from build/static to backend static mount
cp -r "$BUILD_DIR/static/"* "$BACKEND_STATIC_DIR/"
cp "$BUILD_DIR/favicon.png" "$BACKEND_STATIC_DIR/favicon.png" 2>/dev/null || true
cp "$BUILD_DIR/favicon.svg" "$BACKEND_STATIC_DIR/favicon.svg" 2>/dev/null || true

echo "✨ Step 4: Finalizing Permissions..."
chmod -R 644 "$BACKEND_STATIC_DIR"/*
find "$BACKEND_STATIC_DIR" -type d -exec chmod 755 {} +

echo "💎 SUCCESS: Signal Restored. Synergy UI is synchronized."
echo "Pulse: You can now restart your backend or simply refresh the UI."
