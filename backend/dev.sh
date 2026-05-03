#!/usr/bin/env bash

export CORS_ALLOW_ORIGIN="https://localhost:5173;https://localhost:8080;http://localhost:5173;http://localhost:8080"
PORT="${PORT:-8080}"
CERT_DIR="$HOME/.synergy-certs"

# Use HTTPS if certificates exist
if [ -f "$CERT_DIR/localhost.crt" ] && [ -f "$CERT_DIR/localhost.key" ]; then
    python -m uvicorn synergy_ui.main:app --port $PORT --host 0.0.0.0 --forwarded-allow-ips '*' --reload --ssl-keyfile="$CERT_DIR/localhost.key" --ssl-certfile="$CERT_DIR/localhost.crt"
else
    python -m uvicorn synergy_ui.main:app --port $PORT --host 0.0.0.0 --forwarded-allow-ips '*' --reload
fi
