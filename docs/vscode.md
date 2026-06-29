# Connect VSCode to the gateway

VSCode itself has no built-in LLM config — you use an extension. The two common
options both support an OpenAI-compatible base URL, so they work with the gateway.

> **Fastest path:** a ready-made config is in
> [`clients/continue/config.yaml`](../clients/continue/config.yaml) — copy it to
> `~/.continue/config.yaml` (Windows: `%USERPROFILE%\.continue\config.yaml`),
> paste your `LITELLM_MASTER_KEY`, and the Continue sidebar button is your agent.

## Option 1 — Continue (recommended)

[Continue](https://continue.dev) is an open-source AI extension. It works in
**both VSCode and Cursor** and adds an agent panel/button to the sidebar.

1. Install **Continue** from the VSCode Marketplace.
2. Open its config (`~/.continue/config.yaml`, or the gear icon in the Continue
   panel) and add models that point at the gateway:

   ```yaml
   models:
     - name: gpt-4o (gateway)
       provider: openai
       model: gpt-4o                     # a model_name from litellm/config.yaml
       apiBase: http://localhost:4000/v1
       apiKey: <LITELLM_MASTER_KEY>
     - name: llama3-local (gateway)
       provider: openai
       model: llama3-local
       apiBase: http://localhost:4000/v1
       apiKey: <LITELLM_MASTER_KEY>
   ```

3. Pick the model from the Continue chat dropdown.

> Older Continue versions use `config.json` instead of `config.yaml`; the same
> keys (`apiBase`, `apiKey`, `model`, `provider: "openai"`) apply.

## Option 2 — GitHub Copilot "Bring Your Own Key"

Recent Copilot Chat builds let you add a custom OpenAI-compatible provider:

1. Copilot Chat → model picker → **Manage Models** → **OpenAI Compatible**
   (label/availability varies by version).
2. **Base URL**: `http://localhost:4000/v1`, **API key**: `LITELLM_MASTER_KEY`,
   **Model**: a `model_name` from your config.

## Verify

Send a message in the extension's chat. If it errors, check
`docker compose logs litellm` and confirm the model name matches your config.
