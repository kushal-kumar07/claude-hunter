---
name: claude-dos-security-skill
description: Assess resource exhaustion, parser complexity, connection handling, and expensive query behavior safely.
---

# DOS security assessment

Assess resource exhaustion, parser complexity, connection handling, and expensive query behavior safely.

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

Use the prompts below to guide a focused **DOS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 291. ReDoS in input validators

- **Difficulty:** MED
- **Slug:** `redos-in-input-validators`
- **Source prompt:** Submit `aaaa...!` (1000 a's) to regex-heavy inputs (email, URL validators). Measure response time.

### 292. XML / JSON billion laughs

- **Difficulty:** MED
- **Slug:** `xml-json-billion-laughs`
- **Source prompt:** POST nested entities / `[[[...]]]` deeply nested JSON. Report parser blowups.

### 293. Pagination DoS

- **Difficulty:** EASY
- **Slug:** `pagination-dos`
- **Source prompt:** Set `limit=10000000`. Test query timeouts.

### 294. Sort/filter DoS

- **Difficulty:** MED
- **Slug:** `sort-filter-dos`
- **Source prompt:** Sort large tables on unindexed columns. Measure CPU/time.

### 295. Hash collision DoS

- **Difficulty:** HARD
- **Slug:** `hash-collision-dos`
- **Source prompt:** Submit thousands of POST params engineered to collide in the framework's hashmap. Measure CPU spike.

### 296. Slowloris / slow POST

- **Difficulty:** MED
- **Slug:** `slowloris-slow-post`
- **Source prompt:** Hold connections open with partial headers / slow body writes. Test concurrent connection limit.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
