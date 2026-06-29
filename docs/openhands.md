# OpenHands — local autonomous agent (full automation, full control)

[OpenHands](https://github.com/OpenHands/OpenHands) (formerly OpenDevin) is an
open-source autonomous coding agent. Unlike a plain chat box, it can **run shell
commands, read/write files, and browse the web** inside a sandbox it controls —
driven by whatever model you point it at. This stack wires it to your gateway, so
it uses the same models (`freellm`, cloud, or local) as everything else.

It runs behind a Docker Compose **profile** so it doesn't start unless you ask.

## Start it

```bash
# gateway must be up first (or start everything together)
docker compose up -d                      # gateway + chat
docker compose --profile agent up -d      # + OpenHands agent
```

Open **http://localhost:3100** (Open WebUI chat stays on :3000).

## Point it at the gateway

The compose file already sets sane defaults via env (see `.env.example`):

| Setting        | Default                                        |
| -------------- | ---------------------------------------------- |
| `LLM_BASE_URL` | `http://host.docker.internal:4000/v1` (gateway)|
| `LLM_API_KEY`  | your `LITELLM_MASTER_KEY`                       |
| `LLM_MODEL`    | `openai/freellm`                               |

`host.docker.internal:4000` is how the agent container reaches the gateway’s
published port on the host.

If the UI asks you to choose a model on first launch (it usually does), set it
manually:

1. Open **Settings → LLM**, toggle **Advanced**.
2. **Base URL:** `http://host.docker.internal:4000/v1`
3. **Custom Model:** `openai/freellm` (or any `model_name` from
   `litellm/config.yaml`, prefixed with `openai/`)
4. **API Key:** your `LITELLM_MASTER_KEY`
5. Save, then start a conversation. The agent will plan, run commands, and edit
   files autonomously.

## Use a different model

Change `OPENHANDS_LLM_MODEL` in `.env` to any gateway model, e.g.
`openai/gpt-4o` or `openai/claude-sonnet`, then
`docker compose --profile agent up -d` again. For agentic work a strong,
instruction-following model is strongly recommended — small local models often
struggle with multi-step tool use.

## Security

OpenHands has **full control** of its sandbox and mounts the host Docker socket
to spawn its runtime. Only run it on a machine you trust, and be deliberate about
what repos/directories you let it touch.

## Stop it

```bash
docker compose --profile agent down       # stop the agent (and the rest)
```

## Pinning versions

`OPENHANDS_VERSION` (app image) and `OPENHANDS_AGENT_SERVER_TAG` (sandbox image)
are pinned in `.env.example` to the versions from the official docs at the time
of writing. Bump them as new releases land — see
<https://docs.openhands.dev/openhands/usage/run-openhands/local-setup>.
