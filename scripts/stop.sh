#!/usr/bin/env bash
# Stop the stack. Pass --volumes to also delete stored data.
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose down "$@"
