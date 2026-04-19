# Contributing to the HPK Spec

The HPK specification is maintained as an open standard. Contributions are welcome — but spec changes carry weight, and we take a deliberate process to keep the format stable and coherent.

## Types of contributions

| Type | Process |
|---|---|
| Typo / wording fix in SPEC.md | PR directly |
| New field or minor additive change | RFC issue → discussion → PR |
| Breaking change to existing field | RFC issue → extended discussion (min 2 weeks) → PR |
| New example pack in `examples/` | PR directly (must pass CI) |
| New doc in `docs/` | PR directly |
| Schema fix | PR directly if non-breaking |

## RFC process (for spec changes)

1. **Open an issue** titled `RFC: <short description>`. Use the RFC issue template.
2. **Describe:** What problem does this solve? What does the new/changed field look like? Which existing fields does it interact with?
3. **Wait for discussion** — minimum 7 days for minor changes, 14 days for breaking changes.
4. **If consensus reached:** maintainer (@abhiFSD) labels it `accepted` and you (or they) open a PR.
5. **PR must:** update SPEC.md, update schema/workspace.schema.json, add/update an example if relevant, update CHANGELOG.md.

## Schema changes

All schema changes must be accompanied by a `workspace.yml` example that exercises the new field. The CI workflow validates all files in `examples/`. If you add a new field, add it to the content-creator example or add a new example pack.

## Style guide

- SPEC.md uses RFC-style numbered headings (already in place). Don't renumber existing sections — append to the end if adding a new top-level section.
- Field names in the schema are `snake_case`.
- YAML examples use 2-space indentation.
- Prefer concrete examples over abstract descriptions.

## What will NOT be accepted

- Changes that add mandatory dependencies on external services
- Changes that break the round-trip invariant (export → install produces equivalent workspace)
- Changes that require a specific runtime implementation detail
- Runtime implementation code (this repo is spec-only)

## Questions?

Open an issue or email abhi@happen-ai.com.
