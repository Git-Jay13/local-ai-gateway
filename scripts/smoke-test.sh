#!/usr/bin/env bash
# Quick check that the gateway is up and a model answers.
# Usage: LITELLM_MASTER_KEY=sk-... MODEL=gpt-4o-mini ./scripts/smoke-test.sh
set -euo pipefail

KEY="${LITELLM_MASTER_KEY:?set LITELLM_MASTER_KEY}"
MODEL="${MODEL:-gpt-4o-mini}"
BASE="${BASE:-http://localhost:4000}"

echo "== /health/liveliness =="
curl -fsS "$BASE/health/liveliness"; echo

echo "== /v1/models =="
curl -fsS "$BASE/v1/models" -H "Authorization: Bearer $KEY"; echo

echo "== /v1/chat/completions ($MODEL) =="
curl -fsS "$BASE/v1/chat/completions" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":\"Say hello in 3 words.\"}]}"
echo
