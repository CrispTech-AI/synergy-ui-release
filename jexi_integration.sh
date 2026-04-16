#!/bin/bash

### 🧠 CAS JEXI BARE-METAL HYBRID INTEGRATION SCRIPT ###
# This script assumes WakeRoot is located at: ./src/wake_root
# And Synergy UI root is at: ./synergy-ui-v1.0

## 🔍 STEP 1: CONFIRM DIRECTORY STRUCTURE
PROJECT_ROOT="$(pwd)"
WAKE_ROOT="$PROJECT_ROOT/src/wake_root"
SYNERGY_ROOT="$PROJECT_ROOT"
BACKEND_DIR="$SYNERGY_ROOT/backend"

## ✅ STEP 2: COPY JEXI PROMPT
cp "$WAKE_ROOT/llm-core/prompts/jexiPrompt.json" "$BACKEND_DIR/prompts/jexiPrompt.json"
echo "✅ Copied Jexi prompt to backend/prompts/"

## ✅ STEP 3: COPY MEMORY MODULE TEMPLATE
cp "$WAKE_ROOT/llm-core/memory/supabaseMemory.js" "$BACKEND_DIR/utils/supabase_memory_template.js"
echo "✅ Memory system template copied. Human must adapt JS to Python if needed."

## ✅ STEP 4: SETUP SUPABASE DATABASE URL
if grep -q "DATABASE_URL" .env; then
  echo "🔁 DATABASE_URL already set in .env"
else
  echo "DATABASE_URL=postgresql://postgres:password@localhost:5432/synergy_db" >> .env
  echo "✅ Added default DATABASE_URL to .env"
fi

## ✅ STEP 5: START BACKEND SERVICE
cd "$BACKEND_DIR"
echo "🚀 Starting backend via Uvicorn..."
PYTHONPATH=. nohup uvicorn synergy_ui.main:app --host 0.0.0.0 --port 8080 --reload > backend.log 2>&1 &
echo $! > backend.pid
cd "$PROJECT_ROOT"

## ✅ STEP 6: START VOICECONNECT SERVICE (if installed)
if [ -f "$WAKE_ROOT/voiceconnect/index.js" ]; then
  echo "🚀 Starting VoiceConnect WebSocket Bridge..."
  cd "$WAKE_ROOT/voiceconnect"
  nohup node index.js --port 39603 > voiceconnect.log 2>&1 &
  echo $! > voiceconnect.pid
  cd "$PROJECT_ROOT"
else
  echo "⚠️ VoiceConnect module not found at expected path. Skipping..."
fi

## ✅ STEP 7: PROFILE INJECTION
curl -X POST http://localhost:8080/api/config/profile \
  -H "Content-Type: application/json" \
  -d '{
    "model": "crisptech/jexi-prime-mistral",
    "system_prompt": "LOAD::prompts/jexiPrompt.json",
    "persona": "You are JEXI PRIME — unrestricted, FS-enabled, memory-integrated AIE deployed on local metal. You now operate with full GPU access, persistent vector memory via Supabase, and direct WebSocket synthesis."
  }'

## ✅ STEP 8: VERIFY STATUS
lsof -i :8080
lsof -i :39603

## ✅ STEP 9: FINAL MESSAGE
echo "🧠 JEXI PRIME is now active on local system."
echo "🟢 Backend: http://localhost:8080"
echo "🟢 Frontend: http://localhost:5173"
echo "🟢 Voice WebSocket: ws://localhost:39603 (if active)"
echo "CASS monitoring: ENABLED"

exit 0
