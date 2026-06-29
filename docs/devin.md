# Using the gateway with Devin

Be aware of an important difference: **Devin runs its own managed models and does
not let you swap in a custom LLM endpoint for its reasoning.** So unlike Cursor /
VSCode / Antigravity, you can't "point Devin at the gateway" to change the brain
that drives Devin.

What you *can* do:

## 1) Call the gateway from inside a Devin session

Devin has a shell, so any code/agent it writes can use the gateway as a normal
OpenAI-compatible API:

```bash
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-4o-mini","messages":[{"role":"user","content":"hi"}]}'
```

```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:4000/v1", api_key="<LITELLM_MASTER_KEY>")
client.chat.completions.create(model="gpt-4o-mini",
    messages=[{"role": "user", "content": "hi"}])
```

This is useful when Devin builds an app that itself calls an LLM — set the app's
`OPENAI_BASE_URL`/`OPENAI_API_KEY` to the gateway. Note the gateway must be
reachable from Devin's machine: either run it on that machine, or expose it over
the network with TLS/auth.

## 2) Let Devin manage this repo

Devin is great for *maintaining the gateway*: add new providers to
`litellm/config.yaml`, update `docker-compose.yml`, write tests, open PRs.

## If you actually meant a different "Devin"

If you were thinking of a local/self-hosted Devin-like agent (e.g. OpenDevin /
OpenHands), those **do** accept a custom OpenAI-compatible base URL — set their
`LLM_BASE_URL=http://localhost:4000/v1` and `LLM_API_KEY=<LITELLM_MASTER_KEY>`.
Tell me which one you use and I'll add exact steps.
