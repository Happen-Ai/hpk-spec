# Security Policy

## Scope

This repository contains the **HPK format specification** — not a runtime implementation. Security issues in scope for this repo are:

- Spec-level design flaws that would allow a malicious `.hpk` pack to compromise a user system **regardless of runtime**
- Issues with the signing/verification specification that could allow forged or replayed signatures
- Schema weaknesses that allow bypass of declared security guarantees

Out of scope for this repo:
- Vulnerabilities in the reference runtime implementation (report to the [happen-ai runtime repo](https://github.com/happen-ai/happen-ai))
- Plugin vulnerabilities (report to the plugin author)

## Known security design decisions

The following are **intentional design decisions** in v0.1, not vulnerabilities:

1. **Egress enforcement is informational.** `network.egress` declarations are advisory. Runtimes are not required to enforce them in v0.1. This is noted in SPEC.md §14.
2. **Signatures warn, not block.** Mismatched signatures warn but do not block install. This is intentional for trust flexibility (SPEC.md §9).
3. **Pre-flight is advisory.** A malicious pack could lie about `requirements:`. Pre-flight is a UX aid, not a security boundary (SPEC.md §14).
4. **Git-URL plugins require explicit confirmation.** This is a spec requirement, but enforcement is up to the runtime (SPEC.md §6.4).

## Reporting a format-level vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Email: abhi@happen-ai.com  
Subject: `[HPK SECURITY] <brief description>`

Include:
- The specific section of SPEC.md that is affected
- A description of the attack scenario
- Any proposed fix

We will respond within 72 hours and coordinate responsible disclosure.

## Embargo policy

We ask for 90 days from initial report to public disclosure. This gives time to update the spec, coordinate with known runtime implementors, and publish an advisory.

If you believe a vulnerability is already being actively exploited, contact us and we will prioritize accordingly.
