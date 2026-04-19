# Content Creator — Happen Pack

A two-agent workspace for writing + editing scroll-stopping short-form content.

## Install

```bash
hpk install content-creator.hpk
```

Runtime will:
1. Pre-flight your system (RAM, Python, git, Claude Code CLI)
2. Prompt for optional env vars (Notion token if you want auto-publish)
3. Ingest `knowledge/` into your local vector store
4. Register the Writer and Editor agents
5. Open http://localhost:7878

## Use

Chat with the Writer. Give it an idea. It drafts. Hands off to the Editor. Editor polishes and publishes to Notion.

## Customize

Edit `knowledge/brand-voice.md` and `knowledge/audience.md` to match your voice.

## BYOK

This pack defaults to your Claude Code subscription (bridge provider). **Zero API cost.** Override at install with `--provider anthropic/claude-sonnet-4` to use a direct API key instead.

## License

Proprietary — purchased from hub.happen-ai.com. Personal use only. See LICENSE.
