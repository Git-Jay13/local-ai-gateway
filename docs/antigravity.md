# Connect Antigravity to the gateway

[Antigravity](https://antigravity.google) is Google's agentic IDE. Like other
AI IDEs it supports bringing your own model via an OpenAI-compatible endpoint,
so you can route it through the gateway.

## Steps

1. Start the gateway and verify `http://localhost:4000/v1/models` responds.
2. In Antigravity, open **Settings → Models / Providers** (wording may differ by
   version) and look for **Add model** / **Custom** / **OpenAI-compatible**.
3. Configure:
   - **Base URL / Endpoint**: `http://localhost:4000/v1`
   - **API key**: your `LITELLM_MASTER_KEY`
   - **Model**: a `model_name` from `litellm/config.yaml`
     (e.g. `gpt-4o`, `claude-sonnet`, `my-custom-endpoint`).
4. Select that model in the chat/agent panel.

## Notes & limits

- The exact menu names move around between Antigravity releases. The constants
  are always the same three fields: **base URL**, **API key**, **model name**.
- Some agentic features may be tied to Antigravity's first-party models and may
  not honor a custom endpoint; standard chat/completion requests will.
- If a setting only accepts a raw OpenAI key (no base-URL override), you can't
  point it at the gateway from that field — use whichever section exposes a
  custom/compatible **endpoint**.

If your installed version doesn't expose an endpoint override, tell me the
version and I'll dig into its current settings layout.
