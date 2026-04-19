# Changelog

All notable changes to the HPK specification are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Spec versioning follows the pattern `hpk/{major}.{minor}`.

---

## [hpk/0.1] — 2026-04-19

Initial public release of the HPK (Happen Pack) specification.

### Added

- Core zip archive format: `workspace.yml` + optional `agents/`, `skills/`, `knowledge/`, `starter/`, `scripts/`, `signature`
- Manifest schema v0.1 with all top-level fields: `spec`, `name`, `display_name`, `version`, `description`, `author`, `license`, `tags`, `icon`, `homepage`, `repository`
- `provenance` block for origin + signature metadata
- `requirements` block: `runtime`, `hardware`, `model`, `plugins`, `network`
- `provider` block with bridge provider types (`bridge/claude-code`, `bridge/codex-cli`)
- `bootstrap_prompt` field for first-run environment validation
- `channels` block: `web`, `terminal`, `discord`, `teams`, `whatsapp`
- `plugins` block with three plugin formats: scoped hub, git-URL, local
- `knowledge` block with file, URL, PDF source types and `embedding_model`
- `agents` array with `id`, `display_name`, `prompt_file`, `tools`, `knowledge`, `params`
- `workflow` block with `entry` and `handoffs` for multi-agent graphs
- `starter_files` list
- `env_schema` with `secret`, `required`, `default` per variable
- `ui` block with `theme`, `home_agent`, `cover_image`, `demo_video_url`
- Install lifecycle specification (11 steps: fetch → ready)
- Export lifecycle specification with round-trip invariant
- Optional ed25519 signing and verification specification
- Provider resolution algorithm
- Runtime compliance definition (required vs. optional capabilities)
- Plugin namespacing: `@{org}/{name}` scopes, `@happen/` reserved
- JSON Schema for `workspace.yml` (Draft 2020-12)
- `content-creator` reference example pack
- `scripts/validate.py` — workspace.yml validation script
- `scripts/pack.sh` — directory to .hpk packaging script
- `scripts/ots-stamp.sh` — OpenTimestamps proof-of-existence helper
- GitHub Actions CI: validate all examples on push + PR

---

*Next: [hpk/0.2](docs/roadmap.md) — workflow execution semantics, plugin sandbox model, egress enforcement.*
