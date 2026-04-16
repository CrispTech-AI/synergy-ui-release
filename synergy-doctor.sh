#!/bin/bash
# 🏥 SYNERGY-DOCTOR: Diagnostic & repair utility
# Version: 1.0 - Phoenix Edition

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}💎 INITIATING: Synergy UI Bare-Metal Diagnostic...${NC}"

# 1. Dependency Checks
echo -e "\n${BLUE}Step 1: Checking System Dependencies...${NC}"
commands=("redis-server" "python3" "node" "npm" "ollama")
for cmd in "${commands[@]}"; do
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} $cmd is installed."
    else
        echo -e "${RED}[FAIL]${NC} $cmd is missing!"
    fi
done

# 2. Virtual Environment Check
echo -e "\n${BLUE}Step 2: Checking Python Environment...${NC}"
if [ -d "backend/venv" ]; then
    echo -e "${GREEN}[OK]${NC} Virtual environment exists."
else
    echo -e "${RED}[WARN]${NC} venv missing. Rebuilding..."
    cd backend && python3 -m venv venv && ./venv/bin/pip install -r requirements.txt && cd ..
fi

# 3. Port Reclamation & Ghost Hunt
echo -e "\n${BLUE}Step 3: Port Audit...${NC}"
ports=(8080 6379 11434)
for port in "${ports[@]}"; do
    pid=$(lsof -t -i:$port)
    if [ ! -z "$pid" ]; then
        echo -e "${GREEN}[INFO]${NC} Port $port is active (PID: $pid)."
    else
        echo -e "${RED}[OFFLINE]${NC} Port $port is closed."
    fi
done

# 4. Ollama Snap Permissions Check
echo -e "\n${BLUE}Step 4: Ollama Snap Validation...${NC}"
if [[ $(which ollama) == *"/snap/"* ]]; then
    echo -e "${GREEN}[INFO]${NC} Ollama detected as SNAP. Testing socket..."
    curl -s http://localhost:11434/api/tags > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK]${NC} Ollama Snap is responding."
    else
        echo -e "${RED}[FAIL]${NC} Ollama Snap is not responding. Run: 'sudo snap restart ollama'"
    fi
fi

echo -e "\n${GREEN}✨ Diagnostic Complete. Run ./synergy-startup.sh to ignite.${NC}"
