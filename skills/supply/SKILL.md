---
name: claude-supply-security-skill
description: Assess software supply-chain, dependency, build, action, and package integrity risks.
---

# SUPPLY security assessment

Assess software supply-chain, dependency, build, action, and package integrity risks.

## Operating rules

- Work only against systems, applications, accounts, and repositories where explicit authorization and a defined test window exist.
- Prefer local fixtures, staging environments, synthetic records, and non-destructive canaries. Do not access, alter, exfiltrate, or persist real user data.
- Establish rate, concurrency, payload-size, and stop limits before testing. Stop immediately if availability, confidentiality, or integrity could be affected.
- Treat a suspected issue as unconfirmed until the request, response, execution/data-flow evidence, affected principal, and security impact are recorded.
- Never use weaponized payloads when a harmless marker or controlled callback can demonstrate the same behavior.
- Redact secrets and personal data in notes. Report remediation guidance and the exact authorization scope alongside findings.

## Assessment workflow

1. Define scope, identities, environment, test limits, and rollback contacts.
2. Inventory relevant endpoints, inputs, parsers, trust boundaries, and user roles.
3. Start with passive inspection and benign markers; compare behavior across roles, methods, encodings, and content types.
4. Use the category prompt catalog below as hypotheses, adapting payloads to safe canaries and the approved environment.
5. Capture reproducible evidence: timestamp, endpoint, method, sanitized request/response, actor, preconditions, observed result, and impact.
6. Validate fixes with regression tests, then document residual risk and monitoring recommendations.

## Finding format

- **Title / severity / confidence**
- **Affected asset and authorization context**
- **Preconditions and reproduction steps**
- **Sanitized evidence and source-to-sink or control-flow path**
- **Security impact and affected users/data**
- **Root cause**
- **Recommended remediation and regression test**

## Category-specific focus

Use the prompts below to guide a focused **SUPPLY** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 287. Dependency confusion

- **Difficulty:** HARD
- **Slug:** `dependency-confusion`
- **Source prompt:** Compare `package.json` internal deps to public npm. Publish stubs for unclaimed internal names.

### 288. Typosquatting check

- **Difficulty:** MED
- **Slug:** `typosquatting-check`
- **Source prompt:** Enumerate the org's dependencies. Search for typosquats (`reqests`, `loadash`).

### 289. Build-time SSRF / RCE

- **Difficulty:** HARD
- **Slug:** `build-time-ssrf-rce`
- **Source prompt:** Audit `postinstall` scripts in deps for outbound requests, file writes. Report risky packages.

### 290. GitHub Action takeover

- **Difficulty:** MED
- **Slug:** `github-action-takeover`
- **Source prompt:** Audit `uses:` references — pinned to commit? Or floating tag/branch (`@main`)? Document risk.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 4
