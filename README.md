# local-ai-gateway

A self-hosted **local AI gateway + chat** built from two battle-tested open-source
tools, wired together so you barely have to write any code:

- **[LiteLLM proxy](https://docs.litellm.ai/docs/simple_proxy)** — a single
  **OpenAI-compatible** endpoint (`http://localhost:4000/v1`) that routes to *any*
  model you configure: local (Ollama, LM Studio, llama.cpp) **or** cloud (OpenAI,
  Anthropic, Gemini, Groq, OpenRouter, or any custom endpoint + key).
- **[Open WebUI](https://github.com/open-webui/open-webui)** — a local chat UI
  (`http://localhost:3000`) that talks to the gateway.
- **[OpenHands](https://github.com/OpenHands/OpenHands)** *(optional)* — a local
  **autonomous agent** (`http://localhost:3100`) that doesn't just chat but runs
  commands, edits files, and browses with full control, using your gateway models.
  Lives behind the `agent` profile. See [`docs/openhands.md`](docs/openhands.md).

You add custom providers/endpoints in one config file (or the LiteLLM admin UI),
then point **Cursor, VSCode, Antigravity** (and use it from **Devin**) at the same
gateway URL. One place to manage keys, models, spend, and rate limits.

```
                         ┌────────────────────────────────────────┐
  Cursor / VSCode /      │            local-ai-gateway            │
  Antigravity / chat ───▶│  LiteLLM proxy  :4000/v1 (OpenAI API)  │──▶ OpenAI
  any OpenAI client      │     ▲                                  │──▶ Anthropic
                         │     │  Open WebUI :3000 (chat)         │──▶ Gemini / Groq
                         │     └── Postgres (keys, models, spend) │──▶ OpenRouter
                         └────────────────────────────────────────┘──▶ Ollama / LM Studio
                                                                   └──▶ your custom endpoint
```

---

## Prerequisites

- **Docker** + **Docker Compose v2** (`docker compose version`).
  Docker Desktop on macOS/Windows, or Docker Engine on Linux.
- (Optional, for local models) **Ollama** / **LM Studio** / **llama.cpp** running
  on the host machine.

## Quick start

```bash
git clone https://github.com/<your-account>/local-ai-gateway.git
cd local-ai-gateway

cp .env.example .env          # PowerShell: Copy-Item .env.example .env
# edit .env -> set LITELLM_MASTER_KEY, LITELLM_SALT_KEY, POSTGRES_PASSWORD,
# WEBUI_SECRET_KEY, and any provider API keys you want.

# start everything
./scripts/start.sh            # PowerShell: ./scripts/start.ps1
# or: docker compose up -d
```

Then open:

| What | URL | Auth |
|------|-----|------|
| Chat UI (Open WebUI) | http://localhost:3000 | create a local account on first visit |
| Gateway API (OpenAI-compatible) | http://localhost:4000/v1 | `Authorization: Bearer $LITELLM_MASTER_KEY` |
| LiteLLM admin UI | http://localhost:4000/ui | log in with `LITELLM_MASTER_KEY` |
| Autonomous agent (OpenHands) | http://localhost:3100 | start with `docker compose --profile agent up -d` |

Stop with `./scripts/stop.sh` (add `--volumes` to wipe stored data).

### Generate strong secrets

```bash
python -c "import secrets; print('sk-'+secrets.token_hex(24))"   # LITELLM_MASTER_KEY
python -c "import secrets; print(secrets.token_hex(24))"          # salt / webui / db password
```

---

## Adding models & custom endpoints

Two ways — pick whichever you prefer.

### A) Edit `litellm/config.yaml` (version-controlled)

Each block under `model_list` adds one model. `model_name` is what clients call;
`litellm_params.model` is the real provider model (always provider-prefixed).

```yaml
model_list:
  - model_name: claude-sonnet                 # name clients use
    litellm_params:
      model: anthropic/claude-3-5-sonnet-latest
      api_key: os.environ/ANTHROPIC_API_KEY   # read from .env

  # Any OpenAI-compatible endpoint + key (the "add a custom API" case):
  - model_name: my-custom-endpoint
    litellm_params:
      model: openai/<model-on-that-server>    # keep the openai/ prefix
      api_base: https://your-endpoint.example.com/v1
      api_key: os.environ/CUSTOM_API_KEY

  # A local model via Ollama on the host:
  - model_name: llama3-local
    litellm_params:
      model: ollama_chat/llama3
      api_base: http://host.docker.internal:11434
```

Apply changes: `docker compose restart litellm`.
See `litellm/config.yaml` for ready-to-use examples (OpenAI, Anthropic, Gemini,
Groq, OpenRouter, Ollama, LM Studio, llama.cpp, custom). The full provider list
is at https://docs.litellm.ai/docs/providers.

> **Reaching local servers:** from inside Docker, use `host.docker.internal`
> (already configured) instead of `localhost` to reach Ollama/LM Studio/llama.cpp
> running on your host.

### B) Use the LiteLLM admin UI (stored in Postgres)

Go to http://localhost:4000/ui → **Models → Add Model**, fill in provider, model,
API base, and key. No restart needed; persists in the database.

---

## Connect your tools

The pattern is identical everywhere: set the **base URL** to `http://localhost:4000/v1`
and the **API key** to your `LITELLM_MASTER_KEY`. Per-tool guides:

- Autonomous agent (OpenHands) → [`docs/openhands.md`](docs/openhands.md)
- Cursor → [`docs/cursor.md`](docs/cursor.md)
- VSCode (Continue / Copilot BYOK) → [`docs/vscode.md`](docs/vscode.md)
- Antigravity → [`docs/antigravity.md`](docs/antigravity.md)
- Devin → [`docs/devin.md`](docs/devin.md)

## Verify it works

```bash
# list configured models
curl http://localhost:4000/v1/models -H "Authorization: Bearer $LITELLM_MASTER_KEY"

# one-shot completion
LITELLM_MASTER_KEY=sk-... MODEL=gpt-4o-mini ./scripts/smoke-test.sh
```

## Troubleshooting

- **`/v1/models` empty or model errors** → the provider key in `.env` is missing/invalid,
  or the model name is wrong. Check `docker compose logs litellm`.
- **Local model unreachable** → confirm the server is running on the host and the
  `api_base` uses `host.docker.internal`, not `localhost`.
- **Open WebUI shows no models** → it reads from LiteLLM; make sure `litellm` is
  healthy (`docker compose ps`) and `OPENAI_API_KEY` in compose equals your master key.
- **Port already in use** → change the left-hand side of the `ports:` mappings in
  `docker-compose.yml` (e.g. `"4001:4000"`).

## Security notes

- `.env` holds all secrets and is git-ignored — never commit it.
- The gateway binds to `localhost` only. If you expose it on a network, put it
  behind TLS/auth and rotate `LITELLM_MASTER_KEY`.
