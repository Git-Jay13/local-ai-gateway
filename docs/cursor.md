# Connect Cursor to the gateway

Cursor lets you override the OpenAI base URL and add custom model names. This
routes Cursor's "OpenAI" requests through your local LiteLLM gateway.

> **Prefer a sidebar agent button?** Install the **Continue** extension (it works
> in Cursor too) and use the ready-made config at
> [`clients/continue/config.yaml`](../clients/continue/config.yaml). The steps
> below are for Cursor's *native* model settings instead.

## Steps

1. Start the gateway (`./scripts/start.sh`) and confirm it answers:
   `curl http://localhost:4000/v1/models -H "Authorization: Bearer $LITELLM_MASTER_KEY"`.
2. Cursor → **Settings** (`Ctrl/Cmd + Shift + J`) → **Models**.
3. Under **API Keys**, expand **OpenAI API Key**:
   - **API Key**: your `LITELLM_MASTER_KEY`.
   - Enable **Override OpenAI Base URL** and set it to:
     ```
     http://localhost:4000/v1
     ```
   - Click **Verify** / save.
4. In the **Models** list, turn off the default models and **+ Add model**,
   typing the exact `model_name` from `litellm/config.yaml`
   (e.g. `gpt-4o`, `claude-sonnet`, `llama3-local`, `my-custom-endpoint`).

## Notes & limits

- Cursor's verify step calls the OpenAI-style endpoint with one of your custom
  model names — make sure at least one model name you added actually resolves in
  the gateway, or verification fails.
- Some Cursor **agent/Tab** features depend on Cursor's own backend models and
  won't use your custom endpoint; chat and "cmd-K" edits will.
- Cursor must reach `localhost:4000`. If you run Cursor on a different machine
  than the gateway, expose the gateway over your network (with TLS/auth) and use
  that host instead of `localhost`.
