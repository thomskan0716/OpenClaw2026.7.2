@echo off
REM OpenClaw Local Development Setup Script
REM Creates necessary directories and starts services

echo.
echo ============================================
echo OpenClaw Local Development Setup
echo ============================================
echo.

REM Create data directories
echo Creating data directories...
if not exist "data\config" mkdir "data\config"
if not exist "data\workspace" mkdir "data\workspace"
if not exist "data\secrets" mkdir "data\secrets"
echo Done!
echo.

REM Check if Docker is running
echo Checking Docker...
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)
echo Docker is running.
echo.

REM Build Docker image
echo Building OpenClaw Docker image...
echo This may take 10-20 minutes on first run...
docker compose -f docker-compose.local.yml build
if errorlevel 1 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)
echo Build completed!
echo.

REM Start services
echo Starting services (OpenClaw + Nginx)...
docker compose -f docker-compose.local.yml up -d
if errorlevel 1 (
    echo ERROR: Failed to start services!
    pause
    exit /b 1
)
echo.

REM Wait for services to be healthy
echo Waiting for services to start...
timeout /t 10 /nobreak >nul
echo.

REM Display status
echo ============================================
echo Services Status:
echo ============================================
docker compose -f docker-compose.local.yml ps
echo.

echo ============================================
echo Setup Complete!
echo ============================================
echo.
echo Access OpenClaw at:
echo   - http://localhost:8090 (via Nginx)
echo   - http://localhost:18789 (direct)
echo.
echo View logs:
echo   docker compose -f docker-compose.local.yml logs -f
echo.
echo Stop services:
echo   docker compose -f docker-compose.local.yml down
echo.
echo IMPORTANT: Install Ollama for free local AI
echo   Download: https://ollama.com/download
echo   Start: ollama serve
echo   Pull model: ollama pull llama2
echo.
pause
