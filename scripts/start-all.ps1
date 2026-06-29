# Start EVERYTHING -- gateway + chat + the OpenHands autonomous agent -- and open
# the chat and agent UIs in your browser.
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

if (-not (Test-Path ".env")) {
    Write-Host "No .env found -- creating one from .env.example."
    Copy-Item ".env.example" ".env"
    Write-Host "Edit .env to set keys/passwords, then re-run this script."
    exit 1
}

Write-Host "Starting gateway + chat + agent (this pulls images on first run)..."
docker compose --profile agent up -d

$ChatUrl  = "http://localhost:3000"
$AgentUrl = "http://localhost:3100"

Write-Host ""
Write-Host "Gateway (OpenAI-compatible): http://localhost:4000/v1   (key = LITELLM_MASTER_KEY)"
Write-Host "Chat UI (Open WebUI):        $ChatUrl"
Write-Host "Autonomous agent (OpenHands):$AgentUrl"
Write-Host "LiteLLM admin UI:            http://localhost:4000/ui"

# Open both UIs in the default browser.
Start-Process $ChatUrl
Start-Process $AgentUrl

Write-Host ""
Write-Host "The agent may take a minute to become ready while it pulls its sandbox image."
