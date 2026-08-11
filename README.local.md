# OpenClaw Local Development with Nginx

Complete local development setup with Nginx reverse proxy and Ollama support.

## 🚀 Quick Start

### Prerequisites

1. **Docker Desktop** installed and running
2. **Ollama** installed on your host PC (for free local AI)
   - Download: https://ollama.com/download
   - Start: `ollama serve`
   - Pull a model: `ollama pull llama2` or `ollama pull llama3`

### Step 1: Setup Data Directories

```powershell
# Create data directories
New-Item -ItemType Directory -Force -Path .\data\config
New-Item -ItemType Directory -Force -Path .\data\workspace
New-Item -ItemType Directory -Force -Path .\data\secrets
```

### Step 2: Build and Start

```powershell
# Build the Docker image
docker compose -f docker-compose.local.yml build

# Start services (gateway + nginx)
docker compose -f docker-compose.local.yml up -d

# View logs
docker compose -f docker-compose.local.yml logs -f
```

### Step 3: Access OpenClaw

- **Via Nginx (recommended):** http://localhost:8090
- **Direct to Gateway:** http://localhost:18789
- **Health Check:** http://localhost:8090/healthz

## 📁 Directory Structure

```
openclaw-2026.7.1-2/
├── docker-compose.local.yml  # Docker Compose config with Nginx
├── .env.local                 # Environment variables
├── nginx.conf                 # Nginx reverse proxy config
└── data/                      # Persistent data (created on first run)
    ├── config/                # OpenClaw configuration
    ├── workspace/             # Agent workspaces
    └── secrets/               # Auth profile secrets
```

## 🔧 Configuration

### Using Ollama (Free Local AI)

1. Install Ollama: https://ollama.com/download
2. Start Ollama service: `ollama serve`
3. Pull a model:
   ```powershell
   ollama pull llama2
   # or
   ollama pull llama3
   # or
   ollama pull mistral
   ```
4. OpenClaw will automatically use Ollama at `http://host.docker.internal:11434`

### Adding Paid AI Providers (Optional)

Edit `.env.local` and add your API keys:

```env
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GEMINI_API_KEY=...
```

### Adding Messaging Channels (Optional)

```env
TELEGRAM_BOT_TOKEN=123456:ABCDEF...
DISCORD_BOT_TOKEN=...
SLACK_BOT_TOKEN=xoxb-...
```

## 🛠️ Common Commands

### Start/Stop Services

```powershell
# Start
docker compose -f docker-compose.local.yml up -d

# Stop
docker compose -f docker-compose.local.yml down

# Restart
docker compose -f docker-compose.local.yml restart

# View logs
docker compose -f docker-compose.local.yml logs -f

# View specific service logs
docker compose -f docker-compose.local.yml logs -f openclaw-gateway
docker compose -f docker-compose.local.yml logs -f nginx
```

### Rebuild After Code Changes

```powershell
# Stop services
docker compose -f docker-compose.local.yml down

# Rebuild image
docker compose -f docker-compose.local.yml build --no-cache

# Start again
docker compose -f docker-compose.local.yml up -d
```

### Access Container Shell

```powershell
# OpenClaw Gateway
docker compose -f docker-compose.local.yml exec openclaw-gateway bash

# Nginx
docker compose -f docker-compose.local.yml exec nginx sh
```

### View Container Status

```powershell
docker compose -f docker-compose.local.yml ps
```

## 🔍 Troubleshooting

### Ollama Connection Issues

1. Make sure Ollama is running: `ollama serve`
2. Test Ollama: `curl http://localhost:11434/api/tags`
3. Check Docker can reach host: `docker run --rm --add-host host.docker.internal:host-gateway curlimages/curl curl http://host.docker.internal:11434/api/tags`

### Port Already in Use

Change the port in `.env.local`:
```env
NGINX_PORT=8091  # Use a different port
```

### View OpenClaw Logs

```powershell
# All logs
docker compose -f docker-compose.local.yml logs -f

# Only gateway logs
docker compose -f docker-compose.local.yml logs -f openclaw-gateway

# Last 100 lines
docker compose -f docker-compose.local.yml logs --tail=100
```

### Rebuild Everything

```powershell
# Remove containers, volumes, and images
docker compose -f docker-compose.local.yml down -v --rmi local

# Clean data directories (WARNING: deletes all data)
Remove-Item -Recurse -Force .\data

# Start fresh
New-Item -ItemType Directory -Force -Path .\data\config, .\data\workspace, .\data\secrets
docker compose -f docker-compose.local.yml build
docker compose -f docker-compose.local.yml up -d
```

## 📊 Service Architecture

```
┌─────────────────┐
│   Your Browser  │
│  localhost:8090 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     Nginx       │
│   Port 8090     │ ◄── Reverse Proxy
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ OpenClaw Gateway│
│   Port 18789    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Ollama (Host)  │
│   Port 11434    │ ◄── Free Local AI
└─────────────────┘
```

## 🔐 Security Notes

1. **Gateway Token:** Change `OPENCLAW_GATEWAY_TOKEN` in `.env.local` to a secure random value
   ```powershell
   # Generate token
   openssl rand -hex 32
   ```

2. **Keep .env.local secret:** Never commit to Git
   
3. **Data Permissions:** The `./data/` directory contains sensitive configuration

## 📝 Next Steps

1. ✅ Install Ollama and pull a model
2. ✅ Start the services
3. 📱 Configure messaging channels (Telegram, Discord, etc.)
4. 🤖 Start chatting with your AI assistant!

## 🆘 Support

- Documentation: https://docs.openclaw.ai
- GitHub: https://github.com/openclaw/openclaw
- Discord: https://discord.gg/clawd

## 📄 License

MIT License - See LICENSE file for details
