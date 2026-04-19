# HPK — Happen Pack

> Portable AI agent workspaces in a single file.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Spec Version](https://img.shields.io/badge/spec-v0.1--draft-blue)](SPEC.md)
[![CI](https://github.com/happen-ai/hpk-spec/actions/workflows/validate.yml/badge.svg)](https://github.com/happen-ai/hpk-spec/actions/workflows/validate.yml)

---

## What is .hpk?

An `.hpk` file (Happen Pack) is a zip archive that describes a complete AI agent workspace — its system prompt, skills, knowledge base, plugins, workflow, and environment requirements — in a single shareable file.

**HPK is to AI agents what `docker-compose.yml` is to containerized services.**

One file. Any compliant runtime. Your own API keys.

```yaml
# workspace.yml — the only required file inside every .hpk
spec: hpk/0.1
name: hello-world
display_name: "Hello World Agent"
version: "1.0.0"
description: "Minimal HPK example"
author:
  name: "Your Name"
  email: "you@example.com"
license: MIT

provider:
  default: bridge/claude-code   # uses your Claude subscription, zero markup

agents:
  - id: greeter
    display_name: "Greeter"
    prompt_file: "agents/greeter/CLAUDE.md"
```

That's a complete agent. Zip it as `hello-world.hpk`. Ship it.

---

## Install with the reference runtime

```bash
# Install the Happen runtime (reference implementation)
pip install happen-ai

# Install any .hpk pack
hpk install hello-world.hpk

# Or directly from the hub
hpk install happen-ai.com/packs/content-creator
```

The runtime is a separate, proprietary product. The format is open.
Reference runtime: [happen-ai.com](https://happen-ai.com) | Source: [github.com/happen-ai/happen-ai](https://github.com/happen-ai/happen-ai)

---

## Why this exists

AI agent platforms today are fragmented and non-portable:

- **OpenAI GPTs** run only in ChatGPT
- **Claude Projects** run only in Claude.ai
- **LangChain / CrewAI** are code frameworks, not packaged artifacts
- **Dify DSL exports** are locked to Dify

An agent you build on one platform cannot run on another. A workspace you configure cannot be handed to a colleague as a single file.

HPK fixes this with three ideas:
1. **One file.** Everything needed to instantiate an agent workspace — prompts, skills, knowledge, config — lives in a single `.hpk` zip.
2. **BYOK-native.** Uses the user's existing Claude Code or Codex subscription. Zero API markup.
3. **Open spec, proprietary runtime.** Anyone can implement the format. The reference runtime ([happen-ai.com](https://happen-ai.com)) is the commercial product.

---

## Repository structure

| Path | Contents |
|---|---|
| [`SPEC.md`](SPEC.md) | Authoritative format specification v0.1 |
| [`schema/workspace.schema.json`](schema/workspace.schema.json) | JSON Schema for `workspace.yml` validation |
| [`examples/content-creator/`](examples/content-creator/) | Working sample pack with two agents |
| [`docs/rationale.md`](docs/rationale.md) | Why a new format is needed |
| [`docs/comparison.md`](docs/comparison.md) | HPK vs docker-compose, LangChain, OpenAI Assistants |
| [`docs/roadmap.md`](docs/roadmap.md) | v0.1 → v0.2 → v1.0 plan |
| [`scripts/validate.py`](scripts/validate.py) | Validate a `workspace.yml` against the schema |
| [`scripts/pack.sh`](scripts/pack.sh) | Zip a directory into a `.hpk` |
| [`scripts/ots-stamp.sh`](scripts/ots-stamp.sh) | OpenTimestamps proof-of-existence for commits |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Spec changes follow an RFC pattern — open an issue before sending a PR.

## Trademark

"Happen Pack™" and ".hpk™" are trademarks. See [TRADEMARK.md](TRADEMARK.md).

## License

The HPK specification is [MIT licensed](LICENSE). The reference runtime is proprietary — see [happen-ai.com](https://happen-ai.com) for commercial terms.
