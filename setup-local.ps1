#!/usr/bin/env pwsh
# OpenClaw Local Development Setup Script (PowerShell)
# Creates necessary directories and starts services

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "OpenClaw Local Development Setup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Create data directories
Write-Host "Creating data directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path .\data\config | Out-Null
New-Item -ItemType Directory -Force -Path .\data\workspace | Out-Null
New-Item -ItemType Directory -Force -Path .\data\secrets | Out-Null
Write-Host "Done!" -ForegroundColor Green
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not running"
    }
    Write-Host "Docker is running." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Build Docker image
Write-Host "Building OpenClaw Docker image..." -ForegroundColor Yellow
Write-Host "This may take 10-20 minutes on first run..." -ForegroundColor Yellow
docker compose -f docker-compose.local.yml build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "Build completed!" -ForegroundColor Green
Write-Host ""

# Start services
Write-Host "Starting services (OpenClaw + Nginx)..." -ForegroundColor Yellow
docker compose -f docker-compose.local.yml up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to start services!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Wait for services to be healthy
Write-Host "Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host ""

# Display status
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Services Status:" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
docker compose -f docker-compose.local.yml ps
Write-Host ""

Write-Host "============================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Access OpenClaw at:" -ForegroundColor Cyan
Write-Host "  - http://localhost:8090 (via Nginx)" -ForegroundColor White
Write-Host "  - http://localhost:18789 (direct)" -ForegroundColor White
Write-Host ""
Write-Host "View logs:" -ForegroundColor Cyan
Write-Host "  docker compose -f docker-compose.local.yml logs -f" -ForegroundColor White
Write-Host ""
Write-Host "Stop services:" -ForegroundColor Cyan
Write-Host "  docker compose -f docker-compose.local.yml down" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT: Install Ollama for free local AI" -ForegroundColor Yellow
Write-Host "  Download: https://ollama.com/download" -ForegroundColor White
Write-Host "  Start: ollama serve" -ForegroundColor White
Write-Host "  Pull model: ollama pull llama2" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
