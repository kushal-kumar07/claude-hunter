---
name: claude-ldap-security-skill
description: Assess LDAP filter and distinguished-name construction for injection and directory boundary failures.
---

# LDAP security assessment

Assess LDAP filter and distinguished-name construction for injection and directory boundary failures.

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

Use the prompts below to guide a focused **LDAP** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 255. LDAP injection in login

- **Difficulty:** MED
- **Slug:** `ldap-injection-in-login`
- **Source prompt:** Send `*)(uid=*))(|(uid=*` and `admin)(&)` in username fields against LDAP-backed auth.

### 256. Blind LDAP via boolean

- **Difficulty:** HARD
- **Slug:** `blind-ldap-via-boolean`
- **Source prompt:** Use `*)(cn=a*` to enumerate values; observe true/false response diffs.

### 257. LDAP search filter injection

- **Difficulty:** HARD
- **Slug:** `ldap-search-filter-injection`
- **Source prompt:** On search endpoints backed by LDAP, inject filter operators to bypass constraints.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 3
