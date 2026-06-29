#!/usr/bin/env bash
# Start EVERYTHING -- gateway + chat + the OpenHands autonomous agent -- and open
# the chat and agent UIs in your browser.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "No .env found -- creating one from .env.example."
  cp .env.example .env
  echo "Edit .env to set keys/passwords, then re-run this script."
  exit 1
fi

echo "Starting gateway + chat + agent (this pulls images on first run)..."
docker compose --profile agent up -d

CHAT_URL="http://localhost:3000"
AGENT_URL="http://localhost:3100"

echo
echo "Gateway (OpenAI-compatible): http://localhost:4000/v1   (key = LITELLM_MASTER_KEY)"
echo "Chat UI (Open WebUI):        $CHAT_URL"
echo "Autonomous agent (OpenHands):$AGENT_URL"
echo "LiteLLM admin UI:            http://localhost:4000/ui"

# Best-effort: open both UIs in the default browser (macOS/Linux/WSL).
open_url() {
  if command -v xdg-open >/dev/null 2>&1; then xdg-open "$1" >/dev/null 2>&1 || true
  elif command -v open      >/dev/null 2>&1; then open "$1"      >/dev/null 2>&1 || true
  elif command -v wslview   >/dev/null 2>&1; then wslview "$1"   >/dev/null 2>&1 || true
  fi
}
open_url "$CHAT_URL"
open_url "$AGENT_URL"

echo
echo "The agent may take a minute to become ready while it pulls its sandbox image."
