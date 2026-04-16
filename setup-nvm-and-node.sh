#!/bin/bash

# Script: setup-nvm-and-node.sh
# Purpose: Install NVM + Node.js 20 + Set as Default

echo "💠 Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "💠 Loading NVM into current shell session..."
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

echo "💠 Installing Node.js v20..."
nvm install 20

echo "💠 Setting Node.js v20 as default..."
nvm alias default 20
nvm use 20

echo "✅ Verifying installed versions:"
node -v
npm -v

echo "✨ All done. Node.js v20 is active and ready."
