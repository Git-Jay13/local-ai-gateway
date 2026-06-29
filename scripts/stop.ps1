# Stop the stack. Pass -Volumes to also delete stored data.
param([switch]$Volumes)
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
if ($Volumes) { docker compose down --volumes } else { docker compose down }
