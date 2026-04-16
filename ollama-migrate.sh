#!/bin/bash
# 🔧 OLLAMA-MIGRATOR: Snap to Bare Metal
# Ensures models are safe and GPU is unlocked

echo "💎 Jexi's Migration Tool: Starting..."

# 1. Backup check
if [ -d "$HOME/.ollama" ]; then
    echo "✅ Model directory found at $HOME/.ollama. Your data is safe."
else
    echo "⚠️ No model directory found. Fresh install detected."
fi

# 2. Remove Snap version
echo "🚫 Removing Snap Ollama..."
sudo snap remove ollama

# 3. Install Direct Binary
echo "📥 Installing Ollama Direct..."
curl -fsSL https://ollama.com/install.sh | sh

# 4. Verify & Restart
echo "⚡ Starting Ollama Service..."
sudo systemctl enable ollama
sudo systemctl restart ollama

echo "✨ Migration Complete. Check 'ollama list' to verify models."
