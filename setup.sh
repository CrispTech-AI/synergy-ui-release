#!/bin/bash

set -e

echo "🛠️  Starting Docker Compose v2 install for WSL..."

# Step 1: Create plugin directory
mkdir -p ~/.docker/cli-plugins

# Step 2: Download latest stable Docker Compose v2 (change version here if needed)
COMPOSE_VERSION="v2.24.6"
ARCH="x86_64"
URL="https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${ARCH}"

echo "⬇️  Downloading Docker Compose plugin..."
curl -SL "$URL" -o ~/.docker/cli-plugins/docker-compose

# Step 3: Set executable permissions
chmod +x ~/.docker/cli-plugins/docker-compose

# Step 4: Add to PATH if needed
SHELL_CONFIG="$HOME/.bashrc"
if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

if ! grep -q 'cli-plugins' "$SHELL_CONFIG"; then
    echo 'export PATH="$HOME/.docker/cli-plugins:$PATH"' >> "$SHELL_CONFIG"
    echo "🔁 Added Docker Compose to your PATH in $SHELL_CONFIG"
fi

# Step 5: Reload shell config
source "$SHELL_CONFIG"

# Step 6: Verify install
echo "✅ Verifying Docker Compose install..."
docker compose version

echo "🚀 Docker Compose v2 setup complete! You’re locked and loaded, Boss."

exit 0
