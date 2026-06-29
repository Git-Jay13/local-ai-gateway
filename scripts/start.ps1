# Start the local AI gateway stack (LiteLLM + Postgres + Open WebUI).
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

if (-not (Test-Path ".env")) {
    Write-Host "No .env found -- creating one from .env.example."
    Copy-Item ".env.example" ".env"
    Write-Host "Edit .env to set keys/passwords, then re-run this script."
    exit 1
}

docker compose up -d
Write-Host ""
Write-Host "Gateway (OpenAI-compatible): http://localhost:4000/v1   (key = LITELLM_MASTER_KEY)"
Write-Host "Chat UI (Open WebUI):        http://localhost:3000"
Write-Host "LiteLLM admin UI:            http://localhost:4000/ui"
