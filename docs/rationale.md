# Why HPK Exists

## The problem: AI agents are trapped in silos

Every AI platform today has a different way to define an agent:

- **ChatGPT Custom GPTs** — configured in a web UI, stored on OpenAI's servers, runs nowhere else
- **Claude Projects** — markdown system prompts, files uploaded per session, no packaging
- **Dify** — visual DSL with export, but the export only runs on Dify
- **CrewAI / LangGraph / AutoGen** — Python code, no standard packaging, requires environment setup
- **n8n / Flowise / Make** — workflow JSON, proprietary format, platform-locked

An agent you build on one platform cannot run on another. A workspace you configure cannot be shared as a single file. A consultant building a specialized research agent for a client has no standard way to package and hand it off.

The developer community has been quietly expressing this frustration. Every new framework that ships includes its own config format, its own deployment model, its own plugin API. We have more agent frameworks than we have standardized ways to package agents.

## The analogy that unlocks it

In 2014, Docker published a spec for container images. Docker itself was one implementation, but the format became a standard. Today, every major cloud provider runs OCI images. The format is open; the runtime tooling is where value accumulates.

In 2016, Docker introduced Compose files — a single YAML that describes a multi-container application. You can't run a Compose file without a runtime, but any Compose-compatible runtime (Docker, Podman, Rancher) will handle it identically.

AI agents need the same thing. Not a new framework. Not a new platform. A **portable packaging format** that any runtime can execute.

## What HPK standardizes

An `.hpk` file (Happen Pack) is a zip archive containing:

- **`workspace.yml`** — the manifest (declarative, YAML, human-readable)
- **Agent prompts** — markdown files, one per agent
- **Skills/plugins** — self-describing capability modules
- **Knowledge** — starter RAG corpus
- **Starter files** — examples, templates, assets

The manifest declares what the workspace needs: which LLM models it's compatible with, what system dependencies are required, what environment variables must be set. A compliant runtime reads this manifest and stands up the workspace — prompting for missing credentials, installing plugins, ingesting knowledge.

## The BYOK insight

Every existing hosted agent platform requires you to use their API key pool. You pay their markup. Your data goes through their infrastructure.

HPK's `bridge/claude-code` provider type flips this. If you already pay for Claude Max (or Codex Pro), the HPK runtime uses your existing subscription directly — zero API markup, zero additional cost. The runtime is just glue code between the manifest and your existing tools.

This makes HPK uniquely positioned for:
- **Power users** who already have AI subscriptions
- **Enterprises** who need to self-host
- **Consultants** who build agents for clients on the client's own keys
- **Offline/air-gapped deployments** via local Ollama

## What HPK does not standardize

HPK deliberately leaves certain things to implementations:

- **Conversation history** — each runtime stores this in its own DB; it is stripped on export
- **Vector store backends** — `embedding_model` is declared but the store (Qdrant, ChromaDB, pgvector) is the runtime's choice
- **Plugin execution sandbox** — v0.1 is advisory; v0.2+ will define sandboxing more precisely
- **UI rendering** — `ui:` hints are best-effort; each runtime may render differently

## The format is the moat, not the runtime

The Docker ecosystem taught us something important: when a format becomes a standard, it becomes infrastructure. Infrastructure is sticky. Infrastructure accretes tooling (linters, validators, converters, CI plugins, registries).

HPK's bet is that the format — `workspace.yml` + the zip structure + the field semantics — is worth standardizing now, before the AI agent ecosystem calcifies around a dozen incompatible proprietary formats.

The reference implementation (Happen AI) is one runtime. Others are welcome to implement the spec. The format is MIT-licensed. The runtime is proprietary. Same playbook as Docker, same playbook as OCI, same playbook as Kubernetes.

## Prior art acknowledged

HPK builds on patterns that already work:

| Prior art | What HPK borrows |
|---|---|
| `docker-compose.yml` | Declarative YAML + pre-flight checks + portable artifact |
| VS Code Extensions (VSIX) | Zip packaging + manifest + plugin architecture |
| Claude Skills (`SKILL.md`) | Plugin definition format used directly for `skills/` |
| Helm charts | Install lifecycle + environment variable injection |
| npm/pip packages | Versioned registry + scoped namespacing |

HPK is not a novel invention in isolation. It is a **synthesis** of patterns that work, applied to AI agent workspaces — a problem space that has not yet been standardized.
