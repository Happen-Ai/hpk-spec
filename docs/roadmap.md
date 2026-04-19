# HPK Spec Roadmap

## Current: v0.1 (Draft)

**Status:** Published 2026-04-19. Request for comments. Not yet stable — breaking changes may occur before v1.0.

**What's in v0.1:**
- Core zip archive format with `workspace.yml` manifest
- Full manifest schema: identity, requirements, provider, plugins, knowledge, agents, workflow, env_schema, channels, UI hints
- Install lifecycle (fetch → extract → parse → pre-flight → env → plugins → knowledge → agents → ready)
- Export lifecycle with round-trip invariant
- Optional ed25519 signing
- Bridge providers (`bridge/claude-code`, `bridge/codex-cli`)
- Three plugin reference formats: hub, git-URL, local
- Multi-agent workflow via `handoffs`
- JSON Schema for `workspace.yml` (Draft 2020-12)

**Known gaps in v0.1:**
- Workflow execution semantics are declared but not formally specified (runtime-dependent)
- Plugin sandbox model is not defined
- Egress enforcement is informational only
- No cross-pack import or composition

---

## v0.2 (Target: 8 weeks post-v0.1)

**Theme: Workflow + Security**

### Workflow execution semantics
- Formal state machine for `workflow.handoffs`
- Conditional expressions (not just string conditions)
- Parallel branches: `handoffs[].parallel: true`
- Loop support: `handoffs[].loop: {until: condition, max_iterations: N}`
- Termination conditions

### Plugin sandbox model
- Define three sandbox levels: `none`, `subprocess`, `wasm`
- Hub plugins: `subprocess` by default
- Git-URL plugins: require explicit `sandbox: none` opt-in (scary, intentional)
- Local plugins: `subprocess` default

### Egress enforcement
- Runtimes SHOULD enforce `network.egress` in sandboxed deployments
- New field: `network.mode: ["strict", "permissive"]`

### Signatures v2
- Manifest hash includes pack version + created_at (prevents replay)
- Hub key registry API defined
- `hpk verify` CLI command defined

### Minor additions
- `agents[].provider` — override workspace-level provider per agent
- `knowledge[].refresh` — cron for URL-sourced knowledge (e.g. `refresh: "0 6 * * *"`)
- `channels[].auth` — token or basic auth on web channel

---

## v0.3 (Target: ~16 weeks post-v0.1)

**Theme: Composition + Discovery**

### Cross-workspace composition
- `imports: [{pack: "happen-ai.com/packs/web-research", as: research}]`
- Imported agents and knowledge scoped under namespace
- Dependency graph resolved at install time

### Streaming UI components
- `ui.components: [{type: "iframe", src: "starter/widget.html"}]`
- Runtime embeds pack-defined HTML widgets in dashboard
- Sandboxed origin (CSP enforced)

### Hub federation
- `registries: [{url: "hub.custom-corp.com"}]` — query custom registries at install
- `hpk search` command resolves across all declared registries

### Pack dependencies
- `dependencies: [{id: "@happen/base-writer", version: "^1.0"}]`
- Runtime installs transitive dependencies
- Conflict resolution: semver intersection

---

## v1.0 (Target: 6–12 months post-v0.1)

**Theme: Stability + Governance**

v1.0 represents a commitment to **no breaking changes** for at least 24 months after publication.

### Stability guarantees
- All required fields are locked
- No required field additions (only optional additions allowed)
- Any field removal requires 12-month deprecation with warnings
- Spec version `hpk/1.0` — runtimes must support for 24 months

### Open governance
- RFC process for spec changes (open GitHub issues with defined template)
- Maintainer group (minimum 3 independent implementors)
- Compatibility test suite published alongside spec
- `hpk-spec.org` or similar neutral home

### Formal conformance
- Published test corpus: 20+ packs covering all field combinations
- Conformance matrix: what each runtime supports vs. the spec
- "HPK Compliant" badge with link to test results

### Security audit
- External review of signing + verification spec
- Plugin sandbox threat model published
- Formal egress enforcement specification

---

## Post-v1.0

Ideas that are out of scope for v1.0 but worth tracking:

- **HPK Registry Protocol** — federated hub API spec (like OCI Distribution Spec)
- **Live packs** — workspace state (conversations, learned context) included in export
- **Pack channels** — async pub/sub between packs
- **Hardware acceleration hints** — GPU affinity, Apple Silicon vs. CUDA paths
- **Capability negotiation** — runtime advertises capabilities; pack selects features accordingly

---

## How to influence the roadmap

Open an issue at https://github.com/happen-ai/hpk-spec. See [CONTRIBUTING.md](../CONTRIBUTING.md) for the RFC process. Feedback welcome on all open questions listed in [SPEC.md](../SPEC.md#18-open-questions).
