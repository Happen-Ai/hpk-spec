# HPK Compared to Existing Formats

## Feature matrix

| | **.hpk** | **docker-compose.yml** | **LangChain templates** | **OpenAI Assistants JSON** | **GPT Store apps** |
|---|---|---|---|---|---|
| **Single-file portability** | Yes — zip archive | Yes — one YAML | No — Python project | No — API resource | No — platform-locked |
| **BYOK support** | Native (bridge/claude-code) | N/A | Yes (env vars) | No — OpenAI API only | No |
| **Multiple agents** | Yes — agents[] array | Yes — services | Code-level (multi-agent chains) | No — one assistant | No |
| **Skill/plugin composition** | Yes — plugins[] + skills/ | Yes — via images | Via tools + custom code | Function calling JSON | GPT Actions |
| **Knowledge embedding** | Declared in manifest | No | Via VectorStore code | File search (platform) | File uploads |
| **Multi-agent workflow** | Yes — workflow.handoffs | Via depends_on | LangGraph (code) | No | No |
| **Offline / self-hostable** | Yes | Yes | Yes | No | No |
| **Pre-flight validation** | Built-in requirements: block | Health checks | None | None | None |
| **Open format** | MIT | Apache 2.0 | MIT (but no format spec) | No | No |
| **Environment secrets** | env_schema + vault | .env + secrets: | Python dotenv | Platform secrets | Platform settings |
| **Declarative (no code)** | Yes | Yes | No | Partial | Partial |
| **Version pinning** | spec: + version: + semver plugins | image tags | requirements.txt | N/A | N/A |

## Notes on each comparison

### docker-compose.yml

The closest structural parallel. Compose is a single declarative YAML that describes a multi-component system. HPK is explicitly inspired by Compose.

Key differences:
- Compose manages **containers** (infrastructure). HPK manages **AI agents** (cognition + knowledge + tools).
- Compose has no concept of prompts, knowledge, or LLM providers.
- Compose services are code-agnostic; HPK agents are prompt-first with optional code tools.
- HPK includes BYOK/bridge support, which has no Compose equivalent.

Both share: single portable artifact, declarative field semantics, pre-flight validation, plugin/service composition, version pinning.

### LangChain templates

LangChain templates are Python project templates for common LLM application patterns. They are code-first, not declarative.

Key differences:
- LangChain templates are Python code; HPK is a declarative YAML manifest.
- Sharing a LangChain template means sharing a git repo + Python environment + setup instructions. Sharing an HPK pack means sharing a single `.hpk` file.
- LangChain has no standard for prompts-as-files, knowledge collections, or agent handoffs.
- LangChain is vendor-agnostic at the code level; HPK is vendor-agnostic at the format level.

### OpenAI Assistants JSON

OpenAI's Assistants API lets you define an assistant with tools and files. You can export the JSON definition.

Key differences:
- Assistants JSON is a **platform-specific resource** (OpenAI API) — it cannot run anywhere else.
- HPK is **platform-agnostic** — any compliant runtime can install it.
- Assistants JSON has no concept of BYOK, self-hosting, or bridge providers.
- Assistants JSON has no equivalent of `requirements:` pre-flight, `workflow:` handoffs, or nested agent composition.
- OpenAI Assistants are single-agent; HPK supports multi-agent workspaces natively.

### GPT Store apps

GPT Store apps (Custom GPTs) are configured via a web UI and can only run in ChatGPT.

Key differences:
- GPT Store apps are fully locked to OpenAI's platform and pricing.
- They cannot be self-hosted, exported as a file, or installed by third-party runtimes.
- Configuration is UI-driven with no standard format.
- GPT Actions are a closed API integration format.

### Dify DSL

Dify exports workflows as YAML DSL. Functionally, this is the closest analog to HPK.

Key differences:
- Dify DSL only runs on Dify (open-source or cloud). It is not an open standard.
- Dify DSL is workflow-centric (node graphs); HPK is agent-centric (prompts + knowledge + tools).
- HPK has an open spec + JSON Schema. Dify DSL does not have a versioned, published schema.
- HPK explicitly separates format (MIT) from runtime (proprietary). Dify is all-in-one.

## Summary

HPK fills a gap that no existing format covers: a **portable, declarative, open-format packaging standard** for AI agent workspaces that:
1. Works offline and self-hosted
2. Supports BYOK natively (including existing Claude/Codex subscriptions)
3. Is runtime-agnostic (any compliant implementation can run it)
4. Covers the full workspace surface: prompts + plugins + knowledge + workflow + env

None of the formats above check all five boxes. HPK does.
