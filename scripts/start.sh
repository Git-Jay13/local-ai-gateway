#!/usr/bin/env bash
# Start the local AI gateway stack (LiteLLM + Postgres + Open WebUI).
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "No .env found -- creating one from .env.example."
  cp .env.example .env
  echo "Edit .env to set keys/passwords, then re-run this script."
  exit 1
fi

docker compose up -d
echo
echo "Gateway (OpenAI-compatible): http://localhost:4000/v1   (key = LITELLM_MASTER_KEY)"
echo "Chat UI (Open WebUI):        http://localhost:3000"
echo "LiteLLM admin UI:            http://localhost:4000/ui"
