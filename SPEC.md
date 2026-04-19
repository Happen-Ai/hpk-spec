> **Status: v0.1 (Draft)** — Request for comments. Not yet stable. Breaking changes possible before v1.0.
> **Canonical home:** https://happen-ai.com/spec | **Issues:** https://github.com/happen-ai/hpk-spec/issues

---

# HPK Specification

**Happen Pack — A Portable, Self-Hostable, BYOK-Native AI Agent Workspace Format**

| Field | Value |
|---|---|
| Version | 0.1.0-draft |
| Status | Draft — request for comments |
| Date | 2026-04-19 |
| Canonical home | https://happen-ai.com/spec |
| License | MIT (spec document — implementations free) |
| Reference implementation | https://github.com/happen-ai/happen-ai |

---

## 1. Introduction

An `.hpk` file (Happen Pack) is a portable, self-contained, zip-based archive describing a complete AI agent workspace — its prompt, plugins, knowledge base, workflow, starter files, and minimum runtime requirements. A compliant runtime reads the manifest and stands up the workspace in one command, either locally (using the user's own Claude Code / Codex subscription) or on a remote machine.

HPK is to AI agents what `docker-compose.yml` is to containerized services — a single shareable declarative artifact that any compliant runtime can execute.

---

## 2. Motivation

AI agent platforms today are fragmented and non-portable:

- **OpenAI GPTs** run only in ChatGPT
- **Claude Skills** run only in Claude
- **Dify DSL exports** run only in Dify
- **CrewAI / LangGraph** are code-first frameworks, not shareable artifacts
- **n8n / Flowise** export workflows as JSON blobs with no standardization

An agent you build on one platform cannot run on another. A workspace you configure cannot be shared as a single file. Power users cannot easily self-host what they designed on a hosted platform.

HPK solves this with a **single portable artifact format** + **open spec** + **BYOK-native runtime model** that treats the user's existing Claude Code or Codex subscription as a first-class provider.

---

## 3. Design Principles

1. **Portable.** A single `.hpk` file contains everything. Move it between machines, share via URL, fork on GitHub.
2. **Declarative.** YAML manifest describes the workspace. The runtime does the work.
3. **BYOK-native.** First-class support for user's own API keys OR user's own Claude/Codex CLI subscription. No mandatory vendor token markup.
4. **Self-hostable.** Runs on $4/mo VPS, laptop, Mac mini. No cloud lock-in.
5. **Honest requirements.** Workspaces declare what they need (RAM, models, plugins). Runtime pre-flights before install.
6. **Convention over invention.** Follows existing patterns (YAML frontmatter like Claude Skills, folder structure like jmac agents, zip packaging like VSIX).
7. **Versioned.** Manifest declares spec version. Runtime rejects incompatible versions clearly.

---

## 4. File Format

An `.hpk` file is a **zip archive** with the following structure:

```
my-pack.hpk (zip)
├── workspace.yml              # required — the manifest
├── IDENTITY.md                # optional — agent personality/voice
├── SOUL.md                    # optional — tone/vibe
├── TOOLS.md                   # optional — env-specific notes
├── agents/                    # optional — sub-agent definitions
│   ├── {agent-name}/
│   │   ├── CLAUDE.md          # system prompt
│   │   └── IDENTITY.md
│   └── ...
├── skills/                    # optional — plugin capabilities
│   ├── {skill-name}/
│   │   ├── SKILL.md           # YAML frontmatter + docs
│   │   └── {files}            # scripts, refs, templates
│   └── ...
├── knowledge/                 # optional — starter knowledge
│   ├── {topic}.md             # markdown files
│   └── ...
├── starter/                   # optional — sample files for the user
│   ├── prompts/
│   ├── examples/
│   └── assets/
├── scripts/                   # optional — executable helpers
└── signature                  # optional — ed25519 signature over manifest + contents
```

Only `workspace.yml` is required. All other paths are optional.

---

## 5. Manifest Schema (workspace.yml)

```yaml
# ── Identity ─────────────────────────────────────────────────────────
spec: hpk/0.1                          # REQUIRED — spec version
name: video-generator                  # REQUIRED — lowercase, kebab-case
display_name: "Video Generator"        # REQUIRED — human-readable
version: "1.0.0"                       # REQUIRED — semver
description: "Seedance + Remotion video production pipeline"
author:
  name: "Abhishek Paul"
  email: "abhi@happen-ai.com"
  url: "https://happen-ai.com"
license: "MIT"                         # or "proprietary", or SPDX id
tags: [video, creative, production]
icon: "starter/icon.png"               # optional — file inside pack
homepage: "https://happen-ai.com/packs/video-generator"
repository: "https://github.com/happen-ai/pack-video-generator"

# ── Provenance (for credit / verification) ───────────────────────────
provenance:
  origin: "happen-ai.com"
  created_at: "2026-04-19T10:00:00Z"
  updated_at: "2026-04-19T10:00:00Z"
  signature_alg: "ed25519"             # if pack is signed

# ── Requirements (pre-flight check) ──────────────────────────────────
requirements:
  runtime:
    min_version: "0.1"                 # min Happen runtime version
  hardware:
    min_ram_mb: 4096
    min_cpu_cores: 2
    min_disk_mb: 10000
    gpu: optional                      # or {required: true, vram_mb: 8000}
  model:
    compatible:
      - "anthropic/claude-sonnet-4"
      - "anthropic/claude-opus-4"
      - "bridge/claude-code"           # uses user's Claude Max subscription
      - "openai/gpt-4.1"
    recommended: "bridge/claude-code"
    min_context_window: 200000
    requires_tool_calling: true
    requires_vision: false
  plugins:
    node: ">=20"                       # optional runtime binaries
    python: ">=3.11"
    system: [ffmpeg, git]              # system packages
  network:
    egress:                            # hosts the pack will call
      - api.anthropic.com
      - api.seedance.com

# ── Provider (which LLM backs the agents) ────────────────────────────
provider:
  default: bridge/claude-code          # uses user's Claude subscription
  allow_override: true                 # user can switch at install

# ── Bootstrap prompt (first-run self-heal) ───────────────────────────
# Claude Code runs this BEFORE the main agent. It verifies the environment,
# fills missing creds, validates tooling, then hands over.
bootstrap_prompt: |
  1. Verify system meets `requirements:` (RAM, disk, binaries).
  2. Check .env for every var in `env_schema:`.
  3. For each missing credential:
     a. Create/update `.env` with a placeholder and a comment with the "where" hint.
     b. Open `.env` in the user's default editor OR ask the user to paste the value in chat.
  4. Validate each credential with a tiny probe (ping Discord, test API key).
  5. Report "READY" and hand off to the main agent.

# ── Channels (how the user talks to the agent) ───────────────────────
channels:
  - type: web                          # default — auto-opens http://localhost:7878
    auto_open: true
    port: 7878
  - type: terminal                     # stdin/stdout in the shell that launched hpk
  - type: discord                      # bot, single guild or DM
    bot_token: "${DISCORD_BOT_TOKEN}"
    guild_id: "${DISCORD_GUILD_ID}"
  - type: teams                        # webhook-driven
    webhook_url: "${TEAMS_WEBHOOK_URL}"
  - type: whatsapp                     # via wacli bridge (future)
    number: "${WA_NUMBER}"

# ── Plugins (tools the agents can call) ──────────────────────────────
plugins:
  - id: "@happen/seedance"
    version: "^2.0"
    config:
      api_key: "${SEEDANCE_API_KEY}"   # env var or vault reference
  - id: "@happen/remotion"
    version: "^1.0"
  - id: "@happen/s3-storage"
    config:
      bucket: "${S3_BUCKET}"
      region: "${S3_REGION}"
  - id: "github.com/user/my-plugin@v1.2.0"   # git-URL installable
    config:
      webhook_url: "${WEBHOOK_URL}"

# ── Knowledge (RAG sources) ──────────────────────────────────────────
knowledge:
  - name: "brand-voice"
    sources:
      - type: file
        path: "knowledge/brand-voice.md"
      - type: url
        url: "https://example.com/style-guide"
      - type: pdf
        path: "starter/brand-guidelines.pdf"
    embedding_model: "sentence-transformers/bge-small-en-v1.5"

# ── Agents (multi-agent workspace) ───────────────────────────────────
agents:
  - id: director
    display_name: "Video Director"
    prompt_file: "agents/director/CLAUDE.md"
    tools:
      - "@happen/seedance.generate"
      - "@happen/remotion.render"
    knowledge: ["brand-voice"]
    params:
      temperature: 0.7
      max_tokens: 4096
  - id: editor
    display_name: "Video Editor"
    prompt_file: "agents/editor/CLAUDE.md"
    tools:
      - "@happen/remotion.render"
      - "@happen/s3-storage.upload"

# ── Workflow (optional — multi-agent handoffs) ───────────────────────
workflow:
  entry: director
  handoffs:
    - from: director
      to: editor
      condition: draft_ready

# ── Starter files (copied to user's workspace on install) ────────────
starter_files:
  - starter/prompts/
  - starter/examples/
  - starter/assets/

# ── Environment schema (prompts user at install) ─────────────────────
env_schema:
  - name: SEEDANCE_API_KEY
    description: "Seedance 2.0 API key (get from seedance.com)"
    required: true
    secret: true
  - name: S3_BUCKET
    description: "S3 bucket name for rendered videos"
    required: true
  - name: S3_REGION
    default: "us-east-1"
    required: false

# ── UI (marketplace display + default view) ──────────────────────────
ui:
  theme: riso                          # color scheme preset
  home_agent: director                 # default agent on workspace open
  cover_image: "starter/cover.png"     # marketplace thumbnail
  demo_video_url: "https://youtube.com/watch?v=..."
```

---

## 6. Manifest Field Reference

### 6.1 Required Fields

| Field | Type | Description |
|---|---|---|
| `spec` | string | Spec version, e.g. `hpk/0.1`. Runtime rejects unknown versions. |
| `name` | string | Lowercase kebab-case identifier. Must match regex `^[a-z][a-z0-9-]{2,39}$`. |
| `display_name` | string | Human-readable name. |
| `version` | string | Semver. Changes to config increment minor; schema-breaking changes increment major. |

### 6.2 `requirements`

All subfields optional. Runtime's pre-flight checker validates each declared field against the local environment and blocks install if any fail (unless `--force`).

- `hardware.min_ram_mb` — runtime measures free + buffered RAM
- `hardware.min_cpu_cores` — logical cores
- `hardware.min_disk_mb` — free disk at `~/.happen/`
- `hardware.gpu` — `optional` or `{required: true, vram_mb: N}`
- `model.compatible` — list of supported models in format `{provider}/{model-id}`
- `model.recommended` — one entry from `compatible` shown as the default
- `model.min_context_window` — minimum context tokens
- `model.requires_tool_calling` — blocks install if user's chosen model doesn't support tools
- `plugins.node` / `plugins.python` — version ranges (npm-style)
- `plugins.system` — binaries checked via `which`
- `network.egress` — reserved for sandboxed deployments (MVP: informational only)

### 6.3 `provider`

- `default` — one of: `anthropic/<model>`, `openai/<model>`, `bridge/claude-code`, `bridge/codex-cli`, `openai-compatible/<endpoint>`, `ollama/<model>`
- `allow_override` — if true, user can swap provider at install

**Bridge providers** use the user's local CLI subscription instead of an API key:
- `bridge/claude-code` → invokes local `claude` CLI (requires Claude Code installed + logged in)
- `bridge/codex-cli` → invokes local `codex` CLI

### 6.4 `plugins`

Plugin references use one of three formats:

1. **Scoped hub plugin:** `@{org}/{name}` + `version: "^1.0"` — resolved from `hub.happen-ai.com`
2. **Git-URL plugin:** `github.com/{user}/{repo}@{tag}` — cloned and built at install
3. **Local plugin:** `./plugins/{name}` — bundled inside the `.hpk`

### 6.5 `agents`

Each agent is an addressable sub-agent with its own prompt, tools, and knowledge scope.

- `id` — unique within pack, kebab-case
- `prompt_file` — relative path to markdown file with system prompt
- `tools` — array of plugin tool IDs (format: `{plugin-id}.{tool-name}`)
- `knowledge` — array of knowledge collection names declared in `knowledge:`
- `params` — model invocation params (temp, max_tokens, top_p, etc.)

### 6.6 `workflow`

Optional. If present, declares multi-agent handoff graph.

- `entry` — agent ID that receives user input first
- `handoffs` — conditions under which control transfers between agents
- Conditions are tool outputs or explicit tool calls (`@workflow.handoff_to(editor)`)

### 6.7 `env_schema`

Variables prompted at install. Stored in the runtime's credential vault. Referenced in `workspace.yml` as `${VAR_NAME}`.

- `secret: true` — value is encrypted at rest and never shown in logs/UI
- `required` — install blocks until provided
- `default` — pre-fills the input

---

## 7. Install Lifecycle

A compliant runtime performs these steps on `hpk install <pack>`:

1. **Fetch.** Download `.hpk` from URL or accept local path. Verify signature if present.
2. **Extract.** Unzip to temporary directory.
3. **Parse.** Load `workspace.yml`. Reject if `spec` version unsupported.
4. **Pre-flight.** Evaluate every field in `requirements:` against local environment.
   - Pass → proceed.
   - Fail → display actionable error (e.g., *"Needs 4GB RAM, detected 2GB. Upgrade host or use `--force`."*). Exit non-zero.
5. **Prompt for env.** For each entry in `env_schema`, prompt user. Validate required. Encrypt secrets into vault.
6. **Install plugins.** Resolve and install each plugin declared. Hub plugins are downloaded and verified. Git-URL plugins are cloned. Local plugins are copied.
7. **Ingest knowledge.** For each knowledge collection, parse sources, chunk, embed (using `embedding_model`), upsert to vector store.
8. **Copy starter files.** Extract `starter_files:` paths into the user's workspace directory (`~/.happen/packs/{name}/starter/`).
9. **Register agents.** Create agent records in runtime DB with resolved prompts, tool bindings, knowledge refs.
10. **Register workflow.** Store handoff graph if present.
11. **Ready.** Emit `pack.installed` event. User can now open the workspace and chat.

---

## 8. Export Lifecycle

A compliant runtime performs these steps on `hpk export <workspace> -o my-pack.hpk`:

1. Serialize current workspace to `workspace.yml`.
2. Inline or reference all prompt files, knowledge sources, starter files.
3. Strip secrets — replace with `${VAR_NAME}` placeholders from `env_schema`.
4. Zip everything into `.hpk`.
5. Optionally sign with author's ed25519 key.

**Round-trip invariant:** `export` → `install` produces a functionally equivalent workspace (excluding ingested conversation history).

---

## 9. Signing and Verification

Optional but recommended for hub-published packs.

1. Author generates ed25519 keypair.
2. On export, compute `sha256(workspace.yml || concat(file paths sorted))` → `digest`.
3. Sign `digest` → `signature`.
4. Include `signature` file at pack root and `signature_alg: ed25519` in manifest.
5. Publisher's public key is recorded in hub metadata.

At install, runtime verifies signature against publisher's registered public key. Mismatched signatures warn the user but do not block (for trust flexibility). Hub-verified packs display a checkmark badge.

---

## 10. Provider Resolution

At runtime, when an agent needs to invoke an LLM:

```
1. Resolve agent.provider (falls back to workspace.provider.default)
2. If provider starts with "bridge/":
     a. Check local CLI exists (claude / codex)
     b. Invoke via claude_agent_sdk (or equivalent subprocess)
     c. Stream responses back
3. Else if provider starts with "anthropic/" or "openai/":
     a. Lookup API key from credential vault
     b. Call provider API via LiteLLM
     c. Stream responses back
4. Emit Usage event (tokens, cost, latency) to runtime's metering
```

**Bridge providers cost zero to the user beyond their existing Claude/Codex subscription.** This is the killer feature.

---

## 11. Runtime Compliance

A runtime is HPK-compliant if it:

1. Accepts `.hpk` files per the zip format above
2. Parses `workspace.yml` per this spec's schema
3. Rejects unsupported `spec:` versions with a clear error
4. Implements pre-flight validation for all `requirements:` subfields it recognizes
5. Supports at least one provider (including ability to say "provider not supported")
6. Supports plugins declared as local (relative path)
7. Registers agents and makes them invokable

Optional:
- Hub plugin resolution
- Git-URL plugin resolution
- Bridge providers
- Workflow execution
- Signing verification
- Export

The reference implementation (`happen-ai`) supports everything.

---

## 12. Namespacing

- **Plugin names:** `@{org}/{name}` (npm-style scopes). `@happen/` reserved for first-party plugins.
- **Pack names:** globally unique within a hub. First-come-first-served registration.
- **Tool names:** scoped under plugins (`@happen/seedance.generate`).

---

## 13. Versioning

- **Spec version** in `spec:` field (`hpk/0.1`, `hpk/0.2`, `hpk/1.0`)
- **Pack version** in `version:` field (semver)
- **Plugin version** in `plugins[].version` (semver range)

Breaking spec changes bump major (`hpk/0.x` → `hpk/1.0`). Additive changes bump minor.

---

## 14. Security Considerations

1. **Secrets never travel in `.hpk` files.** `env_schema` describes inputs; actual values are prompted at install and stored in runtime vault.
2. **Plugins are code.** Installing a plugin executes its code. Hub-curated plugins are reviewed; git-URL plugins require explicit user confirmation.
3. **Pre-flight checks are advisory, not security boundaries.** A malicious pack could lie about requirements. Runtime enforces sandboxing separately.
4. **Signatures verify authenticity, not safety.** A signed pack from a verified author can still contain malicious plugins.
5. **Egress declarations are informational in v0.1.** Future versions may enforce via firewall rules in sandboxed runtimes.

---

## 15. Example: Minimal Pack

```yaml
# workspace.yml
spec: hpk/0.1
name: hello-world
display_name: "Hello World Agent"
version: "1.0.0"
description: "Minimal HPK example"
author: {name: "Abhi", email: "abhi@happen-ai.com"}
license: MIT

provider:
  default: bridge/claude-code

agents:
  - id: greeter
    display_name: "Greeter"
    prompt_file: "agents/greeter/CLAUDE.md"
```

Folder structure:
```
hello-world.hpk (zip)
├── workspace.yml
└── agents/
    └── greeter/
        └── CLAUDE.md
```

`agents/greeter/CLAUDE.md`:
```markdown
You are a friendly greeter. Respond warmly to anyone who says hi.
```

That's it. `hpk install hello-world.hpk` → agent runs using user's Claude Code subscription.

---

## 16. Relationship to Existing Formats

| Format | Relationship to HPK |
|---|---|
| **Claude Skills** (`SKILL.md`) | Used verbatim for plugins (`skills/{name}/SKILL.md`). HPK is the workspace-level container around skills. |
| **Docker Compose** (`compose.yml`) | Spiritual ancestor. Single declarative file + portable artifact + multi-component. Different domain. |
| **OCI Image Spec** | Same split: format is open, reference runtime is branded. HPK = format, Happen AI = reference impl. |
| **VSIX** (VS Code extensions) | Same packaging model: zip with manifest + assets. HPK borrows the UX. |
| **Helm charts** | Same templating/install lifecycle. HPK is declarative rather than templated. |
| **Dify DSL** | Closest functional analog. Dify DSL is runtime-locked to Dify. HPK is runtime-agnostic. |
| **CrewAI `agents.yaml`** | Agent-definition sibling. CrewAI is code-framework; HPK is packaged artifact. |

---

## 17. Roadmap

### v0.2 (target: 8 weeks post-v0.1)
- Workflow execution semantics (loops, conditionals, parallel branches)
- Egress enforcement in sandboxed runtimes
- Plugin sandbox model (WASM? subprocess? TBD)

### v0.3
- Cross-workspace composition (one pack imports another)
- Streaming UI components in pack (custom widgets)
- Hub-federated discovery (query multiple hubs at install time)

### v1.0
- Lock schema for 2+ years
- Formalize through open governance (RFC process, maintainer group)

---

## 18. Open Questions

Comments welcome via GitHub issues.

- Should workflow execution be Turing-complete (risk) or restricted (safe)?
- Should knowledge ingestion be synchronous at install, or deferred?
- Should we standardize a plugin SDK or leave implementations free?
- What's the right sandboxing model for untrusted packs?

File issues at https://github.com/happen-ai/hpk-spec

---

## 19. Credits

- Anthropic — for Claude Skills packaging pattern that inspired the plugin layout
- Docker — for proving that a file format + reference implementation + branded runtime can coexist with an open spec
- The many agent platforms (Dify, CrewAI, LangGraph, Flowise, n8n) that explored the problem space and showed what's missing
- Early reviewers: [names to be added]

---

**Specification copyright © 2026 Abhishek Paul. Licensed MIT. Reference implementation copyright © 2026 Happen AI, proprietary.**
